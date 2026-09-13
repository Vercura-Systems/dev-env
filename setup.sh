#!/usr/bin/env bash
set -e

# =============================================================================
#  ███████╗███████╗███╗   ██╗██╗████████╗██╗  ██╗
#  ╚══███╔╝██╔════╝████╗  ██║██║╚══██╔══╝██║  ██║   DEV-ENV
#    ███╔╝ █████╗  ██╔██╗ ██║██║   ██║   ███████║   Automated Full-Stack Environment
#   ███╔╝  ██╔══╝  ██║╚██╗██║██║   ██║   ██╔══██║   Vercura Systems
#  ███████╗███████╗██║ ╚████║██║   ██║   ██║  ██║
#  ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝  ╚═╝
# =============================================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure scripts are executable
chmod +x "$SCRIPT_DIR/modules/"*.sh

clear
cat << "EOF"
  ███████╗███████╗███╗   ██╗██╗████████╗██╗  ██╗
  ╚══███╔╝██╔════╝████╗  ██║██║╚══██╔══╝██║  ██║   DEV-ENV
    ███╔╝ █████╗  ██╔██╗ ██║██║   ██║   ███████║   Automated Full-Stack Environment
   ███╔╝  ██╔══╝  ██║╚██╗██║██║   ██║   ██╔══██║   https://github.com/Vercura-Systems/dev-env
  ███████╗███████╗██║ ╚████║██║   ██║   ██║  ██║
  ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝  ╚═╝
EOF

echo -e "${CYAN}${BOLD}Welcome to Zenith Dev-Env Provisioner!${NC}"
echo "This suite installs and configures an entire production-grade developer workstation."
echo ""
echo "Select installation mode:"
echo "  [1] Full Installation (Recommended - Installs all 7 modules)"
echo "  [2] Custom Selection (Choose individual modules)"
echo "  [q] Quit"
echo ""

read -rp "Enter choice [1/2/q]: " CHOICE

case "$CHOICE" in
    1)
        echo ""
        echo -e "${GREEN}Starting Full Installation...${NC}"
        "$SCRIPT_DIR/modules/01-cli-tools.sh"
        "$SCRIPT_DIR/modules/02-php-stack.sh"
        "$SCRIPT_DIR/modules/03-node-stack.sh"
        "$SCRIPT_DIR/modules/04-database.sh"
        "$SCRIPT_DIR/modules/05-apache-vhosts.sh"
        "$SCRIPT_DIR/modules/06-minio.sh"
        "$SCRIPT_DIR/modules/07-ide.sh"
        ;;
    2)
        echo ""
        echo "Select modules to install (comma-separated, e.g. 1,2,4,7):"
        echo "  [1] CLI Power Tools (Starship, eza, bat, lazygit, Fira Code)"
        echo "  [2] Multi-PHP Engine (PHP 7.4 -> 8.4 + FPM + Composer + switcher)"
        echo "  [3] Node & NVM Suite (Node 18/20 + yarn + pnpm)"
        echo "  [4] MySQL Database & ~/.my.cnf Client Setup"
        echo "  [5] Apache Web Server & Virtual Hosts"
        echo "  [6] MinIO Local S3 Media Bucket"
        echo "  [7] IDE Styling (OLED Black, File Nesting, Extensions)"
        echo ""
        read -rp "Enter selection: " SELECTION

        IFS=',' read -ra MODS <<< "$SELECTION"
        for MOD in "${MODS[@]}"; do
            case "$(echo "$MOD" | xargs)" in
                1) "$SCRIPT_DIR/modules/01-cli-tools.sh" ;;
                2) "$SCRIPT_DIR/modules/02-php-stack.sh" ;;
                3) "$SCRIPT_DIR/modules/03-node-stack.sh" ;;
                4) "$SCRIPT_DIR/modules/04-database.sh" ;;
                5) "$SCRIPT_DIR/modules/05-apache-vhosts.sh" ;;
                6) "$SCRIPT_DIR/modules/06-minio.sh" ;;
                7) "$SCRIPT_DIR/modules/07-ide.sh" ;;
                *) echo -e "${YELLOW}Skipping unknown module: $MOD${NC}" ;;
            esac
        done
        ;;
    [Qq]*)
        echo "Setup aborted."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid selection. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}${BOLD}     ✔ ZENITH DEV-ENV INSTALLATION COMPLETE!                ${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Reload your shell:  ${CYAN}source ~/.zshrc${NC} (or restart terminal)"
echo -e "  2. Test PHP switcher:  ${CYAN}php-switch 8.4${NC}"
echo -e "  3. Test MySQL CLI:     ${CYAN}sql${NC} (or mysql)"
echo -e "  4. Test MinIO:         ${CYAN}minio-status${NC}"
echo -e "  5. Reload IDE:         Press ${CYAN}Ctrl+Shift+P${NC} -> 'Reload Window'"
echo ""
