#!/usr/bin/env bash
# ==========================================================
# Script de desinstalação completa do Microsoft Edge no Debian
# Autor: ChatGPT (GPT-5)
# ==========================================================

set -e

echo "🔹 Removendo pacotes do Microsoft Edge..."
sudo apt remove -y microsoft-edge-stable microsoft-edge-beta microsoft-edge-dev || true
sudo apt purge -y microsoft-edge-stable microsoft-edge-beta microsoft-edge-dev || true

echo "🔹 Removendo repositório do Microsoft Edge..."
sudo rm -f /etc/apt/sources.list.d/microsoft-edge.list

echo "🔹 Removendo chave GPG do Microsoft Edge..."
sudo rm -f /usr/share/keyrings/microsoft-edge.gpg

echo "🔹 Limpando pacotes e dependências não utilizadas..."
sudo apt autoremove -y
sudo apt clean

echo "🔹 Limpando caches do Edge (se existirem)..."
rm -rf ~/.config/microsoft-edge* ~/.cache/microsoft-edge*

echo "✅ Microsoft Edge removido completamente do sistema."
