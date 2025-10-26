#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Script: debian-vscode-install.sh
# Descrição: Instala o Visual Studio Code no Debian Trixie via repositório oficial
#            totalmente não interativo, sem software-properties-common
# ==========================================================

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script deve ser executado como root (use sudo)."
    exit 1
fi

LOG_INSTALL="/var/log/vscode-install.log"
echo "=== [Instalação do Visual Studio Code] ===" | tee -a "$LOG_INSTALL"
echo "Data: $(date)" | tee -a "$LOG_INSTALL"
echo "===================================================" | tee -a "$LOG_INSTALL"

# 0️⃣ Garantir que não há locks do apt
echo "[0/5] Verificando locks do apt..." | tee -a "$LOG_INSTALL"
fuser -vki /var/lib/dpkg/lock || true
fuser -vki /var/lib/apt/lists/lock || true
dpkg --configure -a >> "$LOG_INSTALL" 2>&1 || true

# 1️⃣ Instalar dependências básicas de forma não interativa
echo "[1/5] Instalando dependências básicas..." | tee -a "$LOG_INSTALL"
DEBIAN_FRONTEND=noninteractive apt update -y >> "$LOG_INSTALL" 2>&1
DEBIAN_FRONTEND=noninteractive apt install -y wget gpg apt-transport-https >> "$LOG_INSTALL" 2>&1

# 2️⃣ Adicionar chave GPG do VSCode
echo "[2/5] Adicionando chave GPG do repositório Microsoft..." | tee -a "$LOG_INSTALL"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg

# 3️⃣ Adicionar repositório do VSCode
echo "[3/5] Adicionando repositório do VSCode..." | tee -a "$LOG_INSTALL"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    > /etc/apt/sources.list.d/vscode.list

# 4️⃣ Atualizar lista de pacotes ignorando warnings de outros repositórios
echo "[4/5] Atualizando lista de pacotes..." | tee -a "$LOG_INSTALL"
DEBIAN_FRONTEND=noninteractive apt update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true >> "$LOG_INSTALL" 2>&1

# 5️⃣ Instalar VSCode de forma não interativa
echo "[5/5] Instalando Visual Studio Code..." | tee -a "$LOG_INSTALL"
DEBIAN_FRONTEND=noninteractive apt install -y code >> "$LOG_INSTALL" 2>&1

echo "✅ Visual Studio Code instalado com sucesso!" | tee -a "$LOG_INSTALL"
echo "Para iniciar: code" | tee -a "$LOG_INSTALL"
