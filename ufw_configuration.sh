#!/usr/bin/env bash
# Basic Firewall Configuration with UFW
# Tested configuration target: Kali Linux / Ubuntu

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run this script with sudo: sudo ./ufw_configuration.sh"
    exit 1
fi

if ! command -v ufw >/dev/null 2>&1; then
    echo "[+] Installing UFW..."
    apt-get update
    apt-get install -y ufw
fi

echo "[+] Setting default policies..."
ufw default deny incoming
ufw default allow outgoing

echo "[+] Applying firewall rules..."
ufw allow 22/tcp comment 'Allow SSH'
ufw deny 80/tcp comment 'Block HTTP'
ufw allow 443/tcp comment 'Allow HTTPS'
ufw deny 23/tcp comment 'Block Telnet'

echo "[+] Enabling UFW..."
ufw --force enable

echo
echo "[+] Firewall configuration finished."
ufw status verbose
