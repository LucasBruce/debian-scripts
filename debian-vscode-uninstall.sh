#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Script: debian-vscode-uninstall.sh
# Descrição: Remove o Visual Studio Code do Debian
# ==========================================================

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script deve ser executado como root (use sudo)."
    exit 1
fi

LOG_UNINSTALL="/var/log/vscode-uninstall.log"

echo "=== [Desinstalação do Visual Studio Code] ===" | tee -a "$LOG_UNINSTALL"
echo "Data: $(date)" | tee -a "$LOG_UNINSTALL"
echo "===================================================" | tee -a "$LOG_UNINSTALL"

# 1️⃣ Parar processos do VSCode
echo "[1/4] Parando processos do VSCode..." | tee -a "$LOG_UNINSTALL"
pkill -f code || true

# 2️⃣ Remover pacote
echo "[2/4] Removendo pacote VSCode..." | tee -a "$LOG_UNINSTALL"
apt remove -y code >> "$LOG_UNINSTALL" 2>&1 || true
apt purge -y code >> "$LOG_UNINSTALL" 2>&1 || true

# 3️⃣ Remover repositório e chave GPG
echo "[3/4] Removendo repositório e chave GPG..." | tee -a "$LOG_UNINSTALL"
rm -f /etc/apt/sources.list.d/vscode.list
rm -f /usr/share/keyrings/packages.microsoft.gpg
apt update -y >> "$LOG_UNINSTALL" 2>&1

# 4️⃣ Remover arquivos de configuração do usuário
echo "[4/4] Limpando arquivos de configuração..." | tee -a "$LOG_UNINSTALL"
rm -rf ~/.config/Code ~/.vscode

echo "✅ Visual Studio Code desinstalado com sucesso!" | tee -a "$LOG_UNINSTALL"
