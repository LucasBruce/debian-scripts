#!/bin/bash
set -e

echo "📦 Instalando dependências necessárias..."
sudo apt update
sudo apt install -y curl zip unzip ca-certificates

# Evita instalar duas vezes
if [ -d "$HOME/.sdkman" ]; then
  echo "⚠️ SDKMAN já está instalado em $HOME/.sdkman"
else
  echo "⬇️ Instalando SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
fi

echo "🔄 Inicializando SDKMAN..."
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "🔍 Verificando instalação..."
sdk version

echo "✅ SDKMAN pronto para uso!"
echo ""
echo "➡️ Em novos terminais, o SDKMAN será carregado automaticamente."
echo "   Se não carregar, rode: source ~/.sdkman/bin/sdkman-init.sh"
