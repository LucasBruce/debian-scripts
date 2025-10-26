#!/usr/bin/env bash
# ==========================================================
# Instalação do Microsoft Edge no Debian (Trixie, Bookworm, Bullseye)
# Autor: ChatGPT (GPT-5)
# ==========================================================

set -e

echo "🔹 Atualizando pacotes..."
sudo apt update -y

echo "🔹 Instalando dependências necessárias..."
# 'software-properties-common' pode não existir em algumas versões novas do Debian
sudo apt install -y wget gpg apt-transport-https ca-certificates lsb-release curl || true

echo "🔹 Adicionando repositório oficial do Microsoft Edge..."

# Garante que o diretório de keyrings exista
sudo mkdir -p /usr/share/keyrings

# Baixa e adiciona a chave GPG do Microsoft
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
  sudo gpg --dearmor -o /usr/share/keyrings/microsoft-edge.gpg

# Obtém o codinome da distribuição (ex: bookworm, bullseye, trixie)
DISTRO=$(lsb_release -cs || echo "bookworm")

# Adiciona o repositório à lista de fontes do APT
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] \
https://packages.microsoft.com/repos/edge stable main" | \
  sudo tee /etc/apt/sources.list.d/microsoft-edge.list > /dev/null

echo "🔹 Atualizando lista de pacotes..."
sudo apt update -y

echo "🔹 Instalando o Microsoft Edge..."
sudo apt install -y microsoft-edge-stable

echo "✅ Microsoft Edge instalado com sucesso!"
echo "Para abrir, execute: microsoft-edge"
