#!/usr/bin/env bash
# =========================================================
# Script de instalação do navegador Brave (para Debian/Ubuntu)
# Autor: Lucas Bruce + ChatGPT
# =========================================================

set -e  # Interrompe o script se ocorrer algum erro

# --- Funções auxiliares ---
function echo_ok()    { echo -e "\e[32m[✔]\e[0m $1"; }
function echo_info()  { echo -e "\e[34m[ℹ]\e[0m $1"; }
function echo_warn()  { echo -e "\e[33m[!]\e[0m $1"; }
function echo_error() { echo -e "\e[31m[✖]\e[0m $1"; }

# --- Verifica se é root ---
if [ "$EUID" -ne 0 ]; then
  echo_error "Por favor, execute este script com sudo ou como root."
  exit 1
fi

echo_info "Atualizando lista de pacotes..."
apt update -y

# --- Instala dependências ---
echo_info "Instalando dependências necessárias..."
apt install -y curl apt-transport-https gnupg ca-certificates
echo_ok "Dependências instaladas."

# --- Adiciona a chave GPG oficial da Brave ---
echo_info "Adicionando chave GPG do repositório Brave..."
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo_ok "Chave GPG adicionada."

# --- Adiciona o repositório Brave ---
echo_info "Adicionando repositório do Brave..."
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" \
  | tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
echo_ok "Repositório adicionado."

# --- Atualiza e instala Brave ---
echo_info "Instalando Brave Browser..."
apt update -y
apt install -y brave-browser
echo_ok "Brave instalado com sucesso."

# --- Mensagem final ---
echo_ok "✅ Instalação concluída!"
echo_info "Você pode abrir o Brave pelo menu do sistema ou digitando 'brave-browser' no terminal."
