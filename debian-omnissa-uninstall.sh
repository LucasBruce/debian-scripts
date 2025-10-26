#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Script: uninstall-omnissa-horizon-debian-trixie-x11.sh
# Descrição: Remove completamente o Omnissa Horizon Client
#            do Debian 13 (Trixie) com Plasma X11
# ==========================================================

LOGFILE="/var/log/omnissa-horizon-uninstall.log"
TMP_DIR="/tmp/omnissa-horizon-uninstall"

if [[ $EUID -ne 0 ]]; then
  echo "❌ Este script deve ser executado como root (use sudo)."
  exit 1
fi

mkdir -p "$TMP_DIR"

echo "=== [Omnissa Horizon Client - Desinstalação] ===" | tee -a "$LOGFILE"
echo "Data: $(date)" | tee -a "$LOGFILE"
echo "Log: $LOGFILE" | tee -a "$LOGFILE"
echo "==============================================" | tee -a "$LOGFILE"

# ----------------------------------------------------------
# 1. Parar processos relacionados
# ----------------------------------------------------------
echo "[1/5] Finalizando processos do Horizon Client..." | tee -a "$LOGFILE"
pkill -f vmware-view || true
pkill -f horizon || true

# ----------------------------------------------------------
# 2. Remover pacotes instalados
# ----------------------------------------------------------
echo "[2/5] Removendo pacotes..." | tee -a "$LOGFILE"
apt remove -y omnissa-horizon-client vmware-horizon-client >> "$LOGFILE" 2>&1 || true
apt purge -y omnissa-horizon-client vmware-horizon-client >> "$LOGFILE" 2>&1 || true

# ----------------------------------------------------------
# 3. Limpar dependências opcionais (não essenciais)
# ----------------------------------------------------------
echo "[3/5] Limpando dependências opcionais..." | tee -a "$LOGFILE"
apt autoremove -y >> "$LOGFILE" 2>&1 || true

# ----------------------------------------------------------
# 4. Remover arquivos de configuração e diretórios locais
# ----------------------------------------------------------
echo "[4/5] Removendo arquivos de configuração..." | tee -a "$LOGFILE"
rm -rf ~/.vmware
rm -rf ~/.config/VMware
rm -rf ~/.local/share/VMware
rm -rf "$TMP_DIR"

# ----------------------------------------------------------
# 5. Verificação final
# ----------------------------------------------------------
echo "[5/5] Verificando se o Horizon Client foi removido..." | tee -a "$LOGFILE"
if ! command -v vmware-view >/dev/null 2>&1; then
    echo "✅ Omnissa Horizon Client foi desinstalado com sucesso!" | tee -a "$LOGFILE"
else
    echo "❌ O comando 'vmware-view' ainda existe. Pode haver arquivos remanescentes." | tee -a "$LOGFILE"
fi

echo "=== Desinstalação concluída ===" | tee -a "$LOGFILE"
