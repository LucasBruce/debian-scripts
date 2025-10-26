#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Script: install-omnissa.sh
# Descrição: Instala o Omnissa Horizon Client de forma simples
# ==========================================================

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script deve ser executado como root (use sudo)."
    exit 1
fi

USER_HOME=$(eval echo "~${SUDO_USER:-$USER}")

DEB_FILE="$USER_HOME/Downloads/omnissa-horizon.deb"

echo "=== [Instalação do Omnissa Horizon Client] ==="
echo "Data: $(date)"
echo "Verificando arquivo .deb em $DEB_FILE ..."

if [[ ! -f "$DEB_FILE" ]]; then
    echo "❌ Nenhum arquivo .deb do Horizon Client encontrado em $DEB_FILE"
    echo "Baixe o arquivo do site oficial e coloque em ~/Downloads"
    exit 1
fi

# 1️⃣ Instalar dependências do sistema
echo "[1/3] Instalando dependências necessárias..."
DEBIAN_FRONTEND=noninteractive apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y libglib2.0-0 libgtk-3-0 libnss3 libasound2 >> /dev/null

# 2️⃣ Instalar o pacote Omnissa
echo "[2/3] Instalando Omnissa Horizon Client..."
dpkg -i "$DEB_FILE" || apt-get install -f -y

# 3️⃣ Finalização
echo "[3/3] Instalação concluída!"
echo "✅ Omnissa Horizon Client instalado com sucesso!"
