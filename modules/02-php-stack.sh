#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 02 - Multi-PHP Development Stack (7.4 -> 8.4)
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==> [02/07] Installing Multi-PHP Engine (Ondřej Surý PPA)...${NC}"

sudo apt-get install -y software-properties-common ca-certificates lsb-release apt-transport-https

# Add Ondřej Surý PHP repository if missing
if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
    echo -e "${GREEN}[+] Adding ppa:ondrej/php repository...${NC}"
    sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    sudo apt-get update -y
fi

# Target PHP versions
PHP_VERSIONS=("7.4" "8.0" "8.1" "8.3" "8.4")

for VER in "${PHP_VERSIONS[@]}"; do
    echo -e "${GREEN}[+] Installing PHP ${VER} and extensions...${NC}"
    sudo apt-get install -y \
        "php${VER}-cli" \
        "php${VER}-fpm" \
        "php${VER}-common" \
        "php${VER}-mysql" \
        "php${VER}-redis" \
        "php${VER}-curl" \
        "php${VER}-xml" \
        "php${VER}-mbstring" \
        "php${VER}-zip" \
        "php${VER}-bcmath" \
        "php${VER}-intl" \
        "php${VER}-gd" \
        "php${VER}-soap" || true
done

# Install Composer globally if missing
if ! command -v composer &>/dev/null; then
    echo -e "${GREEN}[+] Installing Composer globally...${NC}"
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer
fi

# Configure generous developer limits (upload size, execution time, memory)
echo -e "${GREEN}[+] Tuning php.ini settings for Laravel & modern web apps...${NC}"
for VER in "${PHP_VERSIONS[@]}" "7.2"; do
    for TARGET in fpm cli; do
        INI_FILE="/etc/php/${VER}/${TARGET}/php.ini"
        if [ -f "$INI_FILE" ]; then
            sudo sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 128M/" "$INI_FILE"
            sudo sed -i "s/^post_max_size = .*/post_max_size = 128M/" "$INI_FILE"
            sudo sed -i "s/^max_execution_time = .*/max_execution_time = 300/" "$INI_FILE"
            sudo sed -i "s/^max_input_time = .*/max_input_time = 300/" "$INI_FILE"
            if grep -q "^max_input_vars" "$INI_FILE"; then
                sudo sed -i "s/^max_input_vars = .*/max_input_vars = 5000/" "$INI_FILE"
            else
                echo "max_input_vars = 5000" | sudo tee -a "$INI_FILE" > /dev/null
            fi
            if [ "$TARGET" = "fpm" ]; then
                sudo sed -i "s/^memory_limit = .*/memory_limit = 512M/" "$INI_FILE"
            else
                sudo sed -i "s/^memory_limit = .*/memory_limit = -1/" "$INI_FILE"
            fi
        fi
    done
    sudo systemctl restart "php${VER}-fpm" 2>/dev/null || true
done

echo -e "${GREEN}✔ Module 02: Multi-PHP Stack complete.${NC}"
php -v | head -1

