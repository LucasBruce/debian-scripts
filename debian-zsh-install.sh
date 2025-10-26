#!/usr/bin/env bash
# =========================================================
# Instalação/Reparo definitivo do Zsh + Oh My Zsh
# Usa git clone, inclui plugins e tema Powerlevel10k
# Corrige permissões automaticamente
# Compatível com Debian/Ubuntu
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

echo_info "Iniciando instalação/reparo do Zsh + Oh My Zsh..."

# --- Instala Zsh, git e curl se não existirem ---
for pkg in zsh git curl; do
  if ! command -v $pkg >/dev/null 2>&1; then
    echo_info "Instalando $pkg..."
    apt update -y
    apt install -y $pkg
  fi
done

# --- Instala/repara Oh My Zsh via git ---
if [ ! -d "$OHMYZSH_DIR" ] || [ ! -f "$OHMYZSH_DIR/oh-my-zsh.sh" ]; then
  echo_warn "Oh My Zsh ausente ou corrompido. Instalando via git..."
  rm -rf "$OHMYZSH_DIR"
  sudo -u "$USER_NAME" git clone https://github.com/ohmyzsh/ohmyzsh.git "$OHMYZSH_DIR"
fi

# --- Confirma existência ---
if [ ! -d "$OHMYZSH_DIR" ]; then
  echo_error "Falha ao criar o diretório $OHMYZSH_DIR. Abortando."
  exit 1
fi

echo_ok "Oh My Zsh instalado com sucesso."

# --- Corrige permissões ---
echo_info "Corrigindo permissões do diretório .oh-my-zsh..."
chown -R "$USER_NAME:$USER_NAME" "$OHMYZSH_DIR"
chmod -R u+rwX "$OHMYZSH_DIR"

# --- Cria ou corrige .zshrc ---
if [ ! -f "$ZSHRC" ]; then
  echo_info "Criando novo .zshrc básico..."
  sudo -u "$USER_NAME" bash -c "cat > '$ZSHRC'" <<EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "\$ZSH/oh-my-zsh.sh"
EOF
else
  sed -i "/oh-my-zsh.sh/d" "$ZSHRC"
  echo "source $OHMYZSH_DIR/oh-my-zsh.sh" >> "$ZSHRC"
  echo_info ".zshrc atualizado."
fi

chown "$USER_NAME:$USER_NAME" "$ZSHRC"

# --- Cria pastas custom para plugins e temas ---
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"
chown -R "$USER_NAME:$USER_NAME" "$ZSH_CUSTOM"

# --- Instala plugins ---
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo_info "Instalando plugin zsh-autosuggestions..."
  sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo_info "Instalando plugin zsh-syntax-highlighting..."
  sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- Instala tema Powerlevel10k ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo_info "Instalando tema Powerlevel10k..."
  sudo -u "$USER_NAME" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# --- Define Zsh como shell padrão ---
CURRENT_SHELL=$(getent passwd "$USER_NAME" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "$(command -v zsh)" ]; then
  echo_info "Definindo Zsh como shell padrão..."
  chsh -s "$(command -v zsh)" "$USER_NAME"
  echo_ok "Shell padrão alterado para Zsh."
else
  echo_warn "Zsh já é o shell padrão."
fi

echo_ok "✅ Instalação/reparo concluído com sucesso!"
echo_info "Abra um novo terminal ou execute: exec zsh"
echo_info "Na primeira vez, o Powerlevel10k iniciará o assistente de configuração."
