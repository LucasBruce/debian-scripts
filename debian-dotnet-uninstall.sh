#!/bin/bash
# Script para desinstalar .NET SDK e Runtime no Debian 13 Trixie
# Autor: Lucas Bruce
# Data: 2025-10-27

set -e

echo "Removendo .NET SDK e Runtime..."
sudo apt remove --purge -y dotnet-sdk-* aspnetcore-runtime-* dotnet-runtime-*

echo "Removendo pacotes Microsoft do repositório..."
sudo dpkg -r packages-microsoft-prod || true

echo "Limpando pacotes desnecessários e cache..."
sudo apt autoremove -y
sudo apt clean

echo ".NET desinstalado com sucesso!"
