#!/bin/bash

init_uv() {
    curl -LsSf https://astral.sh/uv/install.sh | sh
    cat > ~/.config/uv/uv.toml <<EOF
[[index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/"
default = true
EOF
}

init_pip() {
    if command -v pip >/dev/null 2>&1
    then
        echo "pip exists"
    else
        apt install python3-pip
    fi
    pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
}

init_pip