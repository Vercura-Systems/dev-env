# ⚡ Zenith Dev-Env

> **Automated, production-grade development workstation provisioner for Ubuntu/Debian.**  
> Transforms any clean Linux machine into an instant, high-performance full-stack development powerhouse in minutes.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-E95420?logo=ubuntu)](https://ubuntu.com)
[![PHP](https://img.shields.io/badge/PHP-7.4%20|%208.0%20|%208.1%20|%208.3%20|%208.4-777BB4?logo=php)](https://php.net)
[![Node](https://img.shields.io/badge/Node.js-NVM%20Multi--Version-339933?logo=node.js)](https://nodejs.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%20Client%20Auth-4479A1?logo=mysql)](https://mysql.com)

---

## 🚀 1-Line Quickstart

On any fresh Ubuntu/Debian machine, run:

```bash
git clone git@github.com:Vercura-Systems/dev-env.git && cd dev-env && ./setup.sh
```

*(Or via HTTPS: `git clone https://github.com/Vercura-Systems/dev-env.git && cd dev-env && ./setup.sh`)*

The interactive installer will ask for your local database credentials, securely generate your local config, and provision all modules automatically.

---

## 📦 What's Inside

| Module | What It Configures |
| :--- | :--- |
| **01. CLI Suite** | **Starship Prompt** (with dynamic Git, PHP `🐘`, Node `⬢`), `eza` (icons `ls`), `bat` (syntax `cat`), `zoxide` (smart `cd`), `lazygit`, `btop`, and **Fira Code font with ligatures**. |
| **02. Multi-PHP Engine** | Full Ondřej Surý PHP matrix: **7.4, 8.0, 8.1, 8.3, 8.4** with FPM, Redis, cURL, XML, mbstring, BCMath, and global **Composer**. Includes instant CLI switcher (`php-switch 8.4`). |
| **03. Node & NVM** | Node Version Manager with LTS environments (`v14`, `v16`, `v18`, `v20`), plus global `yarn` and `pnpm`. |
| **04. MySQL & Auth** | MySQL Server & Client setup with zero-leak **`~/.my.cnf`** credential provisioning (`chmod 600`) so you never type plaintext passwords on the CLI. |
| **05. Apache & Virtual Hosts** | Pre-configured Apache 2 with `mod_rewrite`, `mod_proxy_fcgi`, and ready-to-use virtual hosts for `.test` domains (`kataloq.test`, `servicepack.test`, etc.). |
| **06. MinIO Object Storage** | Local S3-compatible media bucket server pre-configured with background **systemd daemon** (`minio-start` / `minio-stop`). |
| **07. IDE Ergonomics** | Pitch-black **Tokyo Night OLED** theme, vibrant cyber-contrast token highlighting, **Smart File Nesting** (lockfiles grouped under manifests), and curated extensions for VS Code and Antigravity. |

---

## 🔒 Security by Design (Safe to Fork & Share)

This repository is **100% safe to be public**:
* **Zero Hardcoded Passwords**: All credentials (database users, MinIO keys) are prompted at install time and saved **locally** to `~/.my.cnf` (`chmod 600`).
* **Zero Private Certificates**: Only standard local development routes and configurations are tracked.
* **Strict `.gitignore`**: Blocks any accidental check-in of `.env`, `*.cnf`, `*.key`, or `*.pem` files.

---

## ⌨️ Productivity Shortcuts Cheat Sheet

Once installed, your shell inherits these aliases across both **Zsh** and **Bash**:

### Git Workflows
| Shortcut | Action |
| :--- | :--- |
| `gs` | `git status` |
| `ga` | `git add --all` |
| `gcm "msg"` | `git commit -m "msg"` |
| `gca "msg"` | `git add --all && git commit -m "msg"` |
| `gsm "msg"` | `git add --all && git commit -m "msg" && git push` |
| `gfc <branch>` | `git fetch && git checkout <branch>` |
| `lg` | Launch `lazygit` terminal UI |

### PHP Version Switching (Apache FPM + CLI)
| Shortcut | Action |
| :--- | :--- |
| `php74` / `php80` / `php84` | Instantly switch Apache FPM, system alternatives, and CLI to that version |
| `php-switch <version>` | Switch to any installed version with automated service reloading |
| `php-status` | Display CLI version, loaded modules, and running FPM services |

### Laravel & Artisan
| Shortcut | Action |
| :--- | :--- |
| `pa` | `php artisan` |
| `pas` | `php artisan serve` |
| `pasf` | Force kill port 8000 & start `php artisan serve` |
| `pam` / `pamm` | `php artisan migrate` / `php artisan module:migrate` |
| `ca` | Clear all: views, routes, and config caches |
| `larafresh` | `php artisan db:wipe && migrate && db:seed` |

### Database & MinIO
| Shortcut | Action |
| :--- | :--- |
| `sql` | Seamless MySQL CLI login (via `~/.my.cnf`) |
| `sqld` | Single-transaction `mysqldump` |
| `minio-start` | Start MinIO background service |
| `minio-stop` | Stop MinIO background service |
| `minio-status` | Check port 9000/9001 status |

---

## 🛠️ Customizing Modules

You can run individual modules at any time without running the entire suite:

```bash
# Example: Only setup PHP
./modules/02-php-stack.sh

# Example: Only deploy Apache virtual hosts
./modules/05-apache-vhosts.sh
```

---

## 📄 License
MIT © [Vercura Systems](https://github.com/Vercura-Systems)
