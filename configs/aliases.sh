#!/usr/bin/env bash
# =============================================================================
# Zenith Dev-Env: Universal Developer Shortcuts & Aliases
# Compatible with both Zsh and Bash.
# =============================================================================

# ─── Git Shortcuts ───────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add --all'
alias gp='git push'
alias gl='git pull'
alias gfc='git fetch && git checkout'
alias gmg='git merge'
export GIT_MERGE_AUTOEDIT=no

function gcm() {
    git commit -m "$*"
}

function gca() {
    git add --all && git commit -m "$*"
}

function gsm() {
    gca "$*" && git push
}

# Multi-Branch Workflow Helpers
alias gmgsmf='gfc stagingf_migration && gl && gfc odesigo && gmg stagingf_migration odesigo && gp'
alias gmgsmb='gfc stagingb_migration && gl && gfc odesigo && gmg stagingb_migration odesigo && gp'
alias gmgsm='gfc staging_migration && gl && gfc odesigo && gmg staging_migration odesigo && gp'
alias gmgep='gfc eze_migration && gl && gfc eze_parent && gmg eze_migration eze_parent && gp'

# ─── PHP Version Switcher (CLI + Apache FPM) ─────────────────────────────────
alias php-versions='ls -1 /etc/php/ 2>/dev/null | sort -V'
alias php-cli='sudo update-alternatives --config php'

function php-switch() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "Usage: php-switch [version]"
        echo "Available: 7.2, 7.4, 8.0, 8.1, 8.3, 8.4"
        return 1
    fi

    if [[ ! -d "/etc/php/${version}" ]]; then
        echo "PHP ${version} is not installed."
        echo "Install via: sudo apt-get install php${version}-fpm php${version}-redis"
        return 1
    fi

    echo "Disabling all PHP Apache modules & FPM configs..."
    sudo a2dismod php7.2 php7.4 php8.0 php8.1 php8.3 php8.4 2>/dev/null
    sudo a2disconf php7.2-fpm php7.4-fpm php8.0-fpm php8.1-fpm php8.3-fpm php8.4-fpm 2>/dev/null

    echo "Enabling PHP ${version}-fpm..."
    sudo a2enconf "php${version}-fpm" 2>/dev/null
    sudo systemctl restart "php${version}-fpm" 2>/dev/null || true
    sudo systemctl reload apache2

    echo "Switching CLI alternatives to PHP ${version}..."
    sudo update-alternatives --set php "/usr/bin/php${version}" 2>/dev/null || true
    sudo update-alternatives --set phar "/usr/bin/phar${version}" 2>/dev/null || true
    sudo update-alternatives --set phar.phar "/usr/bin/phar.phar${version}" 2>/dev/null || true

    echo "✅ Switched to PHP ${version} (Apache FPM + CLI)"
    php -v | head -1
}

alias php72='php-switch 7.2'
alias php74='php-switch 7.4'
alias php80='php-switch 8.0'
alias php81='php-switch 8.1'
alias php83='php-switch 8.3'
alias php84='php-switch 8.4'

function php-status() {
    echo "=== Current PHP Environment ==="
    echo "CLI Version: $(php -v 2>/dev/null | head -1)"
    echo "CLI Redis: $(php -m 2>/dev/null | grep -q redis && echo '✅ Loaded' || echo '❌ Not loaded')"
    echo ""
    echo "Apache Modules:"
    sudo apache2ctl -M 2>/dev/null | grep -E "php|proxy_fcgi" || echo "None detected"
    echo ""
    echo "Active PHP-FPM Services:"
    sudo systemctl list-units --type=service --state=running 2>/dev/null | grep -i fpm || echo "None running"
}

# ─── Laravel Shortcuts ───────────────────────────────────────────────────────
alias lnew='laravel new'
alias pa='php artisan'
alias pas='pa serve'
alias pasf='kill -9 $(lsof -t -i:8000 2>/dev/null) 2>/dev/null; pas'
alias pam='php artisan migrate'
alias pamm='php artisan module:migrate'
alias pammm='php artisan module:make-model'
alias vc='pa view:clear'
alias rc='pa route:clear'
alias lcc='pa config:clear'
alias ca='vc && rc && lcc'
alias larafresh='pa db:wipe && pam && pa db:seed'
alias qw='pa queue:work'
alias rq='pa queue:restart'
alias ss='pa schedule:work'
alias cll='echo "" > storage/logs/laravel.log'

# ─── Node & App Control ──────────────────────────────────────────────────────
alias node14='nvm use v14.16.0 2>/dev/null || nvm use 14'
alias node16='nvm use v16 2>/dev/null || nvm use 16'
alias node18='nvm use v18 2>/dev/null || nvm use 18'
alias node20='nvm use 20 2>/dev/null || nvm use 20'

alias startApp='node18; kill -9 $(lsof -t -i:3011 2>/dev/null) 2>/dev/null; kill -9 $(lsof -t -i:3000 2>/dev/null) 2>/dev/null; npm start'
alias ngf='node18; kill -9 $(lsof -t -i:4200 2>/dev/null) 2>/dev/null; ng serve'
alias nglanding='kill -9 $(lsof -t -i:43675 2>/dev/null) 2>/dev/null; ng serve --port=43675'
alias startssr='kill -9 $(lsof -t -i:4000 2>/dev/null) 2>/dev/null; npm run serve:ssr'
alias webstart='node14; kill -9 $(lsof -t -i:6001 2>/dev/null) 2>/dev/null; pa websocket:serve'
alias echostart='node14; kill -9 $(lsof -t -i:6001 2>/dev/null) 2>/dev/null; laravel-echo-server start'

# ─── MinIO Object Storage (S3 Media Bucket) ──────────────────────────────────
alias minio-start='sudo systemctl start minio 2>/dev/null || sudo minio server -C /etc/minio --address 127.0.0.1:9000 --console-address ":9001" /usr/local/share/minio/ > /dev/null 2>&1 &'
alias minio-stop='sudo systemctl stop minio 2>/dev/null || kill -9 $(lsof -t -i:9000 2>/dev/null) 2>/dev/null'
alias minio-status='sudo systemctl status minio 2>/dev/null || lsof -i:9000'

# ─── Database (Secure via ~/.my.cnf - No Hardcoded Passwords) ─────────────────
alias sql='mysql'
alias sqld='mysqldump --single-transaction'

# ─── Apache & Web Administration ─────────────────────────────────────────────
alias sar='sudo systemctl reload apache2 && sudo systemctl restart apache2'
alias apr='sudo systemctl restart apache2'
alias arr='sudo systemctl reload apache2'
alias aps='sudo service apache2 restart'
alias sav='cd /etc/apache2/sites-available/'
alias html='cd /var/www/html'
alias hosts='sudo "${EDITOR:-nano}" /etc/hosts'
alias modown='sudo chown -R www-data:www-data'
alias modperm='sudo chmod -R 775'

# ─── System & Process ────────────────────────────────────────────────────────
alias psg='ps aux | grep'
alias top='btop'
alias lg='lazygit'
alias sc='source ~/.zshrc 2>/dev/null || source ~/.bashrc'

# ─── Project Paths ───────────────────────────────────────────────────────────
alias lms='cd /var/www/html/service_pack/server'
alias lmsf='cd /var/www/html/service_pack/assets/modules'
alias lmsfh='cd /var/www/html/service_pack/assets/modules/highSchoolManagement'
alias lmsfj='cd /var/www/html/service_pack/assets/modules/juniorSchoolManagement'
alias lmsfp='cd /var/www/html/service_pack/assets/modules/preSchoolManagement'
alias lmsb='cd /var/www/html/service_pack/server/Modules'
alias lmsbh='cd /var/www/html/service_pack/server/Modules/HighSchoolManagement'
alias lmsbj='cd /var/www/html/service_pack/server/Modules/JuniorSchoolManagement'
alias lmsbp='cd /var/www/html/service_pack/server/Modules/PreSchoolManagement'
alias support='cd /var/www/html/educare_support/'
alias winexviv='cd /var/www/html/winexviv_website'
alias bs='cd /var/www/html/base_station'
