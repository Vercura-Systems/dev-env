#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 01 - CLI Tools & Terminal Power Suite
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [01/07] Installing CLI Power Tools & Developer Typography...${NC}"

# Core packages
sudo apt-get update -y
sudo apt-get install -y curl git zsh fzf ripgrep btop terminator unzip fontconfig jq

# 1. Install Starship Prompt
if ! command -v starship &>/dev/null; then
    echo -e "${GREEN}[+] Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Link Zenith Starship config
mkdir -p "$HOME/.config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$SCRIPT_DIR/configs/starship.toml" "$HOME/.config/starship.toml"

# 2. Install eza (modern replacement for ls)
if ! command -v eza &>/dev/null; then
    echo -e "${GREEN}[+] Installing eza...${NC}"
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y eza || true
fi

# 3. Install bat (syntax-highlighted cat)
if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
    sudo apt-get install -y bat || true
fi
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
fi

# 4. Install zoxide (smart cd)
if ! command -v zoxide &>/dev/null; then
    echo -e "${GREEN}[+] Installing zoxide...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# 5. Install lazygit
if ! command -v lazygit &>/dev/null; then
    echo -e "${GREEN}[+] Installing lazygit...${NC}"
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [ -n "$LAZYGIT_VERSION" ]; then
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar -xf /tmp/lazygit.tar.gz -C /tmp
        sudo install /tmp/lazygit /usr/local/bin
        rm -rf /tmp/lazygit*
    fi
fi

# 6. Install Fira Code font with ligatures
echo -e "${GREEN}[+] Checking Fira Code fonts...${NC}"
mkdir -p "$HOME/.local/share/fonts"
if ! fc-list : family | grep -qi "fira code"; then
    echo -e "${GREEN}[+] Downloading Fira Code fonts...${NC}"
    curl -sLo /tmp/firacode.zip "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
    unzip -q /tmp/firacode.zip -d /tmp/firacode
    cp /tmp/firacode/ttf/*.ttf "$HOME/.local/share/fonts/"
    rm -rf /tmp/firacode*
    fc-cache -f "$HOME/.local/share/fonts"
fi

# 7. Configure Aliases & Shell integration
echo -e "${GREEN}[+] Linking aliases to ~/.aliases...${NC}"
cp "$SCRIPT_DIR/configs/aliases.sh" "$HOME/.aliases"

# Ensure ~/.zshrc and ~/.bashrc source ~/.aliases and starship
for RC in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$RC" ]; then
        if ! grep -q "source ~/.aliases" "$RC"; then
            echo -e "\n# Zenith Dev-Env Aliases" >> "$RC"
            echo "[[ -f ~/.aliases ]] && source ~/.aliases" >> "$RC"
        fi
        if ! grep -q "starship init" "$RC"; then
            echo -e "\n# Starship Prompt" >> "$RC"
            if [[ "$RC" == *".zshrc"* ]]; then
                echo 'eval "$(starship init zsh)"' >> "$RC"
            else
                echo 'eval "$(starship init bash)"' >> "$RC"
            fi
        fi
        if ! grep -q "zoxide init" "$RC"; then
            if [[ "$RC" == *".zshrc"* ]]; then
                echo 'eval "$(zoxide init zsh)"' >> "$RC"
            else
                echo 'eval "$(zoxide init bash)"' >> "$RC"
            fi
        fi
    fi
done

echo -e "${GREEN}✔ Module 01: CLI Tools complete.${NC}"
