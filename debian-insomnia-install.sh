#!/bin/bash
set -e

echo "Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependências necessárias..."
sudo apt install -y curl jq apt-transport-https

echo "Buscando última versão do Insomnia..."
LATEST_DEB_URL=$(curl -s https://api.github.com/repos/Kong/insomnia/releases/latest \
  | jq -r '.assets[] | select(.name | test("Insomnia.Core.*.deb$")) | .browser_download_url')

if [[ -z "$LATEST_DEB_URL" ]]; then
  echo "Não foi possível encontrar o arquivo .deb do Insomnia."
  exit 1
fi

echo "Baixando $LATEST_DEB_URL..."
TEMP_DEB="/tmp/insomnia.deb"
curl -L "$LATEST_DEB_URL" -o "$TEMP_DEB"

echo "Instalando Insomnia..."
sudo dpkg -i "$TEMP_DEB" || sudo apt -f install -y

echo "Removendo arquivo temporário..."
rm -f "$TEMP_DEB"

echo "Instalação concluída!"
insomnia --version
