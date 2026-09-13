#!/usr/bin/env bash
set -e

# =============================================================================
# Zenith Dev-Env: Module 04 - MySQL Database & Secure ~/.my.cnf
# =============================================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}==> [04/07] Setting up MySQL Server & Client Authentication...${NC}"

sudo apt-get install -y mysql-server mysql-client
sudo systemctl enable mysql
sudo systemctl start mysql

# Configure ~/.my.cnf for seamless, password-free CLI access without leaks
MY_CNF="$HOME/.my.cnf"

if [ -f "$MY_CNF" ]; then
    echo -e "${YELLOW}[!] Existing ~/.my.cnf detected.${NC}"
    read -rp "Do you want to overwrite your local ~/.my.cnf credentials? (y/N): " OVERWRITE_CNF
    if [[ ! "$OVERWRITE_CNF" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Keeping existing ~/.my.cnf.${NC}"
        chmod 600 "$MY_CNF"
        exit 0
    fi
fi

echo ""
echo -e "${CYAN}--- Configure Local MySQL Credentials ---${NC}"
echo "These credentials will be saved ONLY to your local ~/.my.cnf (chmod 600)."
echo "They are NEVER committed to Git or exposed in shell history."
echo ""

read -rp "Enter MySQL Username [default: admin]: " DB_USER
DB_USER=${DB_USER:-admin}

read -rsp "Enter MySQL Password [default: password]: " DB_PASS
echo ""
DB_PASS=${DB_PASS:-password}

cat <<EOF > "$MY_CNF"
[client]
user = ${DB_USER}
password = ${DB_PASS}
host = localhost
default-character-set = utf8mb4

[mysqldump]
user = ${DB_USER}
password = ${DB_PASS}
host = localhost
default-character-set = utf8mb4
EOF

chmod 600 "$MY_CNF"
echo -e "${GREEN}✔ ~/.my.cnf written with secure permissions (chmod 600).${NC}"

# Test connection
if mysql -e "SELECT 1;" &>/dev/null; then
    echo -e "${GREEN}✔ MySQL connection verified! You can now just type 'sql' or 'mysql'.${NC}"
else
    echo -e "${YELLOW}[!] Warning: Could not authenticate with user '${DB_USER}'. Make sure the user is created in MySQL.${NC}"
    echo "Tip: Run: sudo mysql -e \"CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}'; GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;\""
fi

echo -e "${GREEN}✔ Module 04: Database setup complete.${NC}"
