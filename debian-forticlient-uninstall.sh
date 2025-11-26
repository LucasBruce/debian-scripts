#!/usr/bin/env bash

set -e

echo "=== Desinstalador FortiClient VPN para Debian ==="

# --- Verificar se é root ---
if [[ "$EUID" -ne 0 ]]; then
  echo "Execute este script com sudo."
  exit 1
fi

echo "[1/6] Finalizando processos do FortiClient..."
pkill -f forti 2>/dev/null || true
pkill -f Forti 2>/dev/null || true

echo "[2/6] Removendo pacote FortiClient VPN..."
apt remove -y forticlient-vpn || true
apt purge -y forticlient-vpn || true
dpkg --purge forticlient-vpn 2>/dev/null || true

echo "[3/6] Removendo dependências órfãs..."
apt autoremove -y || true

echo "[4/6] Limpando caches..."
apt clean -y || true

echo "[5/6] Removendo arquivos residuais..."
rm -rf /opt/forticlient
rm -rf /opt/fortinet
rm -rf /usr/local/FortiClient
rm -rf /usr/local/share/FortiClient
rm -f /usr/bin/forticlient
rm -f /usr/bin/FortiClient

echo "Removendo atalhos de menu..."
rm -f /usr/share/applications/forticlient.desktop
rm -f /usr/share/applications/FortiClient.desktop
rm -f /usr/local/share/applications/forticlient.desktop
rm -f /usr/local/share/applications/FortiClient.desktop

echo "[6/6] Limpando workspace..."
updatedb 2>/dev/null || true

echo "=== FortiClient removido completamente! ==="
