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

# Set default CLI to PHP 8.4
if command -v php8.4 &>/dev/null; then
    echo -e "${GREEN}[+] Setting PHP 8.4 as primary default...${NC}"
    sudo update-alternatives --set php /usr/bin/php8.4 2>/dev/null || true
    sudo update-alternatives --set phar /usr/bin/phar8.4 2>/dev/null || true
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.4 2>/dev/null || true
fi

echo -e "${GREEN}✔ Module 02: Multi-PHP Stack complete.${NC}"
php -v | head -1
