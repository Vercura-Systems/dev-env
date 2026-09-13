#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 07 - IDE Settings & Extensions Suite
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [07/07] Configuring IDE Aesthetics, Smart File Nesting & Extensions...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IDE_SETTINGS="$SCRIPT_DIR/configs/ide-settings.json"

# Targets: VS Code and Antigravity
TARGET_DIRS=(
    "$HOME/.config/Code/User"
    "$HOME/.config/Antigravity/User"
)

for TDIR in "${TARGET_DIRS[@]}"; do
    if [ -d "$TDIR" ] || [ -d "$(dirname "$TDIR")" ]; then
        mkdir -p "$TDIR"
        echo -e "${GREEN}[+] Applying Zenith IDE settings to: $TDIR/settings.json${NC}"
        cp "$IDE_SETTINGS" "$TDIR/settings.json"
    fi
done

# Extensions to install
EXTENSIONS=(
    "amiralizadeh9480.laravel-extra-intellisense"
    "shufo.vscode-blade-formatter"
    "wallabyjs.console-ninja"
    "yoavbls.pretty-ts-errors"
    "streetsidesoftware.code-spell-checker"
    "mhutchie.git-graph"
    "bradlc.vscode-tailwindcss"
    "enkia.tokyo-night"
    "pkief.material-icon-theme"
    "shd101wyy.markdown-preview-enhanced"
    "janisdd.vscode-edit-csv"
    "esbenp.prettier-vscode"
    "usernamehw.errorlens"
    "bmewburn.vscode-intelephense-client"
)

if command -v code &>/dev/null; then
    echo -e "${GREEN}[+] Installing curated extensions in VS Code...${NC}"
    for EXT in "${EXTENSIONS[@]}"; do
        code --install-extension "$EXT" --force 2>/dev/null || true
    done
fi

# Sync to Antigravity extension store if present
if [ -d "$HOME/.vscode/extensions" ] && [ -d "$HOME/.antigravity/extensions" ]; then
    echo -e "${GREEN}[+] Synchronizing extensions to Antigravity...${NC}"
    cp -r "$HOME/.vscode/extensions/"* "$HOME/.antigravity/extensions/" 2>/dev/null || true
fi

echo -e "${GREEN}✔ Module 07: IDE Settings & Extensions complete.${NC}"
