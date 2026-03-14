# V2Ray Docker Setup (VLess + Reality)

## Quick Start

1. **Generate keys and UUID**:
   ```bash
   # Generate key pair
   docker run --rm ghcr.io/v2fly/v2ray:v5.47 v2ray xtls generate reality-keypair

   # Output will show:
   # Private key: [你的私钥]
   # Public key: [你的公钥]

   # Generate UUID
   docker run --rm ghcr.io/v2fly/v2ray:v5.47 v2ray uuid
   ```

2. **Update** `config.json`:
   - Replace `你的UUID` with your generated UUID
   - Replace `你的私钥` with your generated private key
   - Optionally change the `dest` (伪装目标) domain
   - Optionally customize `shortIds`

3. **Start the service**:
   ```bash
   docker-compose up -d
   ```

4. **View logs**:
   ```bash
   docker-compose logs -f v2ray
   ```

5. **Stop the service**:
   ```bash
   docker-compose down
   ```

## Reality Configuration

This setup uses **VLess + Reality** protocol for better anti-censorship:
- Port: **443** (masquerades as HTTPS traffic)
- Target: `dl.google.com:443` (looks like Google traffic)
- Flow: `xtls-rprx-vision`

## Client Configuration

Configure your V2Ray client with:
- **Protocol**: VLess
- **UUID**: Your generated UUID
- **Flow**: xtls-rprx-vision
- **Public Key**: The public key paired with your private key
- **Short ID**: 6f2c208f (or your custom value)
- **Server Name (SNI)**: dl.google.com
- **Fingerprint**: chrome or randomized

## Resources

- V2Fly documentation: https://www.v2fly.org/
- Reality protocol guide: https://github.com/XTLS/REALITY
