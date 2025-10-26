#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Script: debian-nvm-uninstall.sh
# Descrição: Remove o NVM (Node Version Manager) do Debian
# ==========================================================

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script deve ser executado como root (use sudo)."
    exit 1
fi

USER_HOME=$(eval echo "~${SUDO_USER:-$USER}")
LOG_UNINSTALL="/var/log/nvm-uninstall.log"

echo "=== [Desinstalação do NVM] ===" | tee -a "$LOG_UNINSTALL"
echo "Data: $(date)" | tee -a "$LOG_UNINSTALL"
echo "Usuário detectado: ${SUDO_USER:-$USER}" | tee -a "$LOG_UNINSTALL"
echo "Diretório home: $USER_HOME" | tee -a "$LOG_UNINSTALL"
echo "===================================================" | tee -a "$LOG_UNINSTALL"

# 1️⃣ Remover diretório do NVM
echo "[1/3] Removendo diretório do NVM..." | tee -a "$LOG_UNINSTALL"
rm -rf "$USER_HOME/.nvm"

# 2️⃣ Remover entradas do NVM do shell
echo "[2/3] Limpando ~/.bashrc e ~/.zshrc..." | tee -a "$LOG_UNINSTALL"
for shell_rc in "$USER_HOME/.bashrc" "$USER_HOME/.zshrc"; do
    if [[ -f "$shell_rc" ]]; then
        sed -i '/nvm.sh/d' "$shell_rc"
        sed -i '/export NVM_DIR/d' "$shell_rc"
    fi
done

# 3️⃣ Informar finalização
echo "[3/3] NVM removido com sucesso!" | tee -a "$LOG_UNINSTALL"
echo "Abra um novo terminal para que as alterações tenham efeito." | tee -a "$LOG_UNINSTALL"
