#!/usr/bin/env bash
# =========================================================
# Script de desinstalação do Zsh + Oh My Zsh
# Remove Oh My Zsh, plugins, tema Powerlevel10k e restaura shell
# =========================================================

set -e

# --- Funções visuais ---
function echo_ok()    { echo -e "\e[32m[✔]\e[0m $1"; }
function echo_info()  { echo -e "\e[34m[ℹ]\e[0m $1"; }
function echo_warn()  { echo -e "\e[33m[!]\e[0m $1"; }
function echo_error() { echo -e "\e[31m[✖]\e[0m $1"; }

# --- Verifica root ---
if [ "$EUID" -ne 0 ]; then
  echo_error "Execute este script com sudo ou como root."
  exit 1
fi

USER_NAME="$SUDO_USER"
USER_HOME=$(eval echo ~$USER_NAME)
ZSHRC="$USER_HOME/.zshrc"
OHMYZSH_DIR="$USER_HOME/.oh-my-zsh"
ZSH_CUSTOM="$OHMYZSH_DIR/custom"

echo_info "Iniciando remoção do Zsh + Oh My Zsh..."

# --- Remove .zshrc ---
if [ -f "$ZSHRC" ]; then
  rm -f "$ZSHRC"
  echo_ok ".zshrc removido."
else
  echo_warn ".zshrc não encontrado."
fi

# --- Remove Oh My Zsh e subpastas/plugins/tema ---
if [ -d "$OHMYZSH_DIR" ]; then
  rm -rf "$OHMYZSH_DIR"
  echo_ok "Diretório .oh-my-zsh removido."
else
  echo_warn ".oh-my-zsh não encontrado."
fi

# --- Restaura shell padrão para bash ---
CURRENT_SHELL=$(getent passwd "$USER_NAME" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/bash" ]; then
  chsh -s /bin/bash "$USER_NAME"
  echo_ok "Shell padrão restaurado para /bin/bash."
else
  echo_warn "Shell já está definido como /bin/bash."
fi

# --- (Opcional) Remover Zsh do sistema ---
read -p "Deseja remover o Zsh do sistema (apt remove zsh)? [s/N]: " remove_zsh
if [[ "$remove_zsh" =~ ^[Ss]$ ]]; then
  apt remove -y zsh
  echo_ok "Zsh removido do sistema."
else
  echo_info "Zsh não será removido do sistema."
fi

echo_ok "✅ Desinstalação concluída!"
echo_info "Reabra o terminal para aplicar alterações."
