#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 03 - Node.js Environment & NVM
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [03/07] Installing NVM & Node LTS Suites...${NC}"

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
    echo -e "${GREEN}[+] Downloading and installing NVM...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Load NVM in current subshell
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v nvm &>/dev/null; then
    echo -e "${GREEN}[+] Installing standard Node LTS versions...${NC}"
    # Standard versions across legacy and modern projects
    nvm install 18 || true
    nvm install 20 || true
    nvm alias default 18
    nvm use 18

    # Install global package managers
    npm install -g yarn pnpm
fi

echo -e "${GREEN}✔ Module 03: Node & NVM complete.${NC}"
node -v 2>/dev/null || true
npm -v 2>/dev/null || true
