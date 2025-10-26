#!/usr/bin/env bash
# =========================================================
# Script de configuração do sudo no Debian
# Autor: Lucas Bruce + ChatGPT
# =========================================================

set -e  # Interrompe o script em caso de erro

# --- Funções auxiliares ---
function echo_ok()    { echo -e "\e[32m[✔]\e[0m $1"; }
function echo_info()  { echo -e "\e[34m[ℹ]\e[0m $1"; }
function echo_warn()  { echo -e "\e[33m[!]\e[0m $1"; }
function echo_error() { echo -e "\e[31m[✖]\e[0m $1"; }

# --- Verifica se está como root ---
if [ "$EUID" -ne 0 ]; then
  echo_error "Por favor, execute este script como root (ex: sudo $0 ou login root)"
  exit 1
fi

# --- Solicita o nome de usuário ---
read -rp "Digite o nome do usuário para configurar o sudo: " USERNAME

# --- Verifica se o usuário existe ---
if ! id "$USERNAME" &>/dev/null; then
  echo_error "O usuário '$USERNAME' não existe no sistema."
  exit 1
fi

# --- Instala o sudo, se necessário ---
if ! command -v sudo &>/dev/null; then
  echo_info "Instalando o pacote sudo..."
  apt update -y
  apt install -y sudo
  echo_ok "sudo instalado."
else
  echo_ok "sudo já está instalado."
fi

# --- Adiciona o usuário ao grupo sudo ---
if groups "$USERNAME" | grep -qw "sudo"; then
  echo_warn "O usuário '$USERNAME' já faz parte do grupo sudo."
else
  usermod -aG sudo "$USERNAME"
  echo_ok "Usuário '$USERNAME' adicionado ao grupo sudo."
fi

# --- Oferece a opção de usar sudo sem senha ---
read -rp "Deseja permitir que '$USERNAME' use sudo sem senha? (s/N): " RESPOSTA
if [[ "$RESPOSTA" =~ ^[Ss]$ ]]; then
  SUDO_CONF="/etc/sudoers.d/${USERNAME}"
  echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "$SUDO_CONF"
  chmod 440 "$SUDO_CONF"
  echo_ok "Configuração de sudo sem senha criada em $SUDO_CONF."
else
  echo_info "Mantendo configuração padrão (sudo pedirá senha)."
fi

# --- Testa a configuração ---
echo_info "Testando configuração do sudo..."
su - "$USERNAME" -c "sudo -l" || echo_warn "⚠ Verifique se o sudo está configurado corretamente."

# --- Mensagem final ---
echo_ok "✅ Configuração do sudo concluída!"
echo_info "Agora o usuário '$USERNAME' pode usar comandos com 'sudo'."
echo_info "Exemplo: sudo apt update"
