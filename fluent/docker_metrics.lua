-- Lua script to add Docker container stats to a log record

-- Load required libraries
local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("cjson.safe")

-- Main function called by Fluent Bit for each log record
function add_container_stats(tag, timestamp, record)
    -- Get the container ID from the log record. Docker log driver adds this.
    local container_id = record["container_id"]

    -- If there's no container ID, we can't get stats.
    if not container_id then
        return 1, timestamp, record
    end

    -- The Docker API endpoint for container stats
    -- We use a Unix socket to communicate directly with the Docker daemon.
    -- `stream=false` gets a single snapshot of stats.
    local api_path = "/v1.41/containers/" .. container_id .. "/stats?stream=false"
    local response_body = {}

    -- Make the HTTP request over the Unix socket
    local res, code, _, _ = http.request {
        method = "GET",
        url = "http://localhost" .. api_path,
        -- This is the key part for talking to the Docker socket
        path = "/var/run/docker.sock",
        sink = ltn12.sink.table(response_body)
    }

    -- If the request failed or returned a non-200 code, exit.
    if not res or code ~= 200 then
        -- You could add an error field to the log here if you want
        -- record['metric_error'] = "Failed to get stats, code: " .. (code or "nil")
        return 1, timestamp, record
    end

    -- Join the response table into a single string and parse the JSON
    local body = table.concat(response_body)
    local stats = cjson.decode(body)

    if not stats then
        return 1, timestamp, record
    end

    -- --- Add Memory Usage ---
    if stats.memory_stats and stats.memory_stats.usage then
        -- Add memory usage in bytes
        record["memory_usage_bytes"] = stats.memory_stats.usage
        -- Add memory limit in bytes
        record["memory_limit_bytes"] = stats.memory_stats.limit
    end

    -- --- CPU Usage Calculation (this part is complex) ---
    -- Docker stats calculation requires comparing two points in time.
    if stats.cpu_stats and stats.precpu_stats then
        local cpu_delta = stats.cpu_stats.cpu_usage.total_usage - stats.precpu_stats.cpu_usage.total_usage
        local system_cpu_delta = stats.cpu_stats.system_cpu_usage - stats.precpu_stats.system_cpu_usage
        local number_of_cpus = stats.cpu_stats.online_cpus or #stats.cpu_stats.cpu_usage.percpu_usage

        if system_cpu_delta > 0 and cpu_delta > 0 then
            -- Calculate percentage and format to 2 decimal places
            local cpu_percent = (cpu_delta / system_cpu_delta) * number_of_cpus * 100.0
            record["cpu_usage_percent"] = string.format("%.2f", cpu_percent)
        end
    end
    
    -- Return 1 to indicate success, plus the modified timestamp and record
    return 1, timestamp, record
end

