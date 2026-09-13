#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 05 - Apache Web Server & Virtual Hosts
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [05/07] Configuring Apache Web Server & Virtual Hosts...${NC}"

sudo apt-get install -y apache2 libapache2-mod-fcgid

echo -e "${GREEN}[+] Enabling essential Apache modules...${NC}"
sudo a2enmod rewrite proxy proxy_fcgi proxy_http headers ssl setenvif 2>/dev/null || true

# Copy virtual hosts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -d "$SCRIPT_DIR/vhosts" ]; then
    echo -e "${GREEN}[+] Deploying virtual hosts to /etc/apache2/sites-available/...${NC}"
    sudo cp "$SCRIPT_DIR/vhosts/"*.conf /etc/apache2/sites-available/
    
    # Enable all custom site configs
    for CONF in "$SCRIPT_DIR/vhosts/"*.conf; do
        SITE_NAME=$(basename "$CONF")
        echo "  - Enabling: $SITE_NAME"
        sudo a2ensite "$SITE_NAME" 2>/dev/null || true
    done
fi

# Ensure /var/www/html permissions
sudo mkdir -p /var/www/html
sudo chown -R www-data:"$USER" /var/www/html
sudo chmod -R 775 /var/www/html

# Update /etc/hosts with local development domains
HOSTS_TEMPLATE="$SCRIPT_DIR/configs/hosts.template"
if [ -f "$HOSTS_TEMPLATE" ]; then
    echo -e "${GREEN}[+] Checking /etc/hosts entries...${NC}"
    while IFS= read -r line; do
        # Ignore comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue
        
        DOMAIN=$(echo "$line" | awk '{print $2}')
        if [ -n "$DOMAIN" ] && ! grep -q "$DOMAIN" /etc/hosts; then
            echo "$line" | sudo tee -a /etc/hosts > /dev/null
            echo "  - Added domain: $DOMAIN"
        fi
    done < "$HOSTS_TEMPLATE"
fi

# Reload and restart Apache
sudo systemctl reload apache2
sudo systemctl restart apache2

echo -e "${GREEN}✔ Module 05: Apache & Virtual Hosts complete.${NC}"
