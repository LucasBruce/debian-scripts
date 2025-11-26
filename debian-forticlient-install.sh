#!/usr/bin/env bash

set -e

echo "=== Instalador FortiClient VPN para Debian Trixie ==="

# --- Verificar se é root ---
if [[ "$EUID" -ne 0 ]]; then
  echo "Execute este script como root (sudo)."
  exit 1
fi

echo "[1/5] Atualizando pacotes..."
apt update -y

echo "[2/5] Instalando dependências necessárias..."
apt install -y wget apt-transport-https libayatana-appindicator3-1

# URL oficial da Fortinet (sempre redireciona para a versão mais recente)
FC_URL="https://links.fortinet.com/forticlient/deb/vpnagent"

echo "[3/5] Baixando FortiClient VPN..."
wget -O forticlient-vpn.deb "$FC_URL"

# Verificar se o download realmente é um arquivo .deb
filetype=$(file forticlient-vpn.deb | grep -c "Debian binary package")
if [[ "$filetype" -eq 0 ]]; then
  echo "Erro: o arquivo baixado não é um pacote .deb válido."
  echo "O download pode ter retornado uma página HTML."
  exit 1
fi

echo "[4/5] Instalando FortiClient VPN..."
apt install -y ./forticlient-vpn.deb || true

echo "[5/5] Corrigindo dependências pendentes..."
apt install -f -y

echo "=== Limpando arquivos temporários ==="
rm forticlient-vpn.deb

echo "=== Instalação concluída com sucesso! ==="
echo "Para abrir:"
echo "  forticlient"
echo "Ou procure no menu: FortiClient VPN"
