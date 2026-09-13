#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 06 - MinIO Object Storage (S3 Media Bucket)
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [06/07] Setting up MinIO Local S3 Media Bucket...${NC}"

# 1. Download MinIO binary if missing
if [ ! -f "/usr/local/bin/minio" ]; then
    echo -e "${GREEN}[+] Downloading MinIO Server binary...${NC}"
    sudo curl -sLo /usr/local/bin/minio "https://dl.min.io/server/minio/release/linux-amd64/minio"
    sudo chmod +x /usr/local/bin/minio
fi

# 2. Prepare Storage & Config Directories
sudo mkdir -p /usr/local/share/minio
sudo mkdir -p /etc/minio
sudo chown -R "$USER":"$USER" /usr/local/share/minio

# 3. Deploy systemd service
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/configs/minio.service" ]; then
    echo -e "${GREEN}[+] Installing MinIO systemd service...${NC}"
    sudo cp "$SCRIPT_DIR/configs/minio.service" /etc/systemd/system/minio.service
    sudo systemctl daemon-reload
    sudo systemctl enable minio
    sudo systemctl restart minio || true
fi

echo -e "${GREEN}✔ Module 06: MinIO Object Storage complete.${NC}"
echo "  - S3 API: http://127.0.0.1:9000"
echo "  - Web Console: http://127.0.0.1:9001"
echo "  - Control: 'minio-start', 'minio-stop', 'minio-status'"
