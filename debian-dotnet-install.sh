#!/bin/bash
# Script para instalar .NET SDK e Runtime no Debian 13 Trixie
# Autor: Lucas Bruce
# Data: 2025-10-27

set -euo pipefail

echo "Atualizando pacotes do sistema..."
sudo apt update
sudo apt upgrade -y

echo "Instalando dependências necessárias..."
sudo apt install -y wget gnupg ca-certificates sudo apt-transport-https

echo "Adicionando chave GPG e repositório da Microsoft (Debian 12/Bookworm)..."
wget -q --show-progress https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb

echo "Atualizando lista de pacotes após adicionar repositório Microsoft..."
sudo apt update

echo "Instalando .NET SDK e Runtime..."
sudo apt install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0

echo ".NET instalado com sucesso!"
dotnet --version
