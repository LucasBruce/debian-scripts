#!/bin/bash
set -e

SDKMAN_DIR="$HOME/.sdkman"

echo "🔍 Verificando se o SDKMAN está instalado..."

if [ ! -d "$SDKMAN_DIR" ]; then
  echo "❌ SDKMAN não está instalado."
  exit 0
fi

echo "🧹 Removendo diretório $SDKMAN_DIR..."
rm -rf "$SDKMAN_DIR"

echo "🧽 Removendo inicialização automática do SDKMAN dos arquivos de shell..."

FILES=(
  "$HOME/.bashrc"
  "$HOME/.profile"
  "$HOME/.bash_profile"
  "$HOME/.zshrc"
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    sed -i '/sdkman/d' "$file"
  fi
done

echo "🔄 Limpando variáveis de ambiente da sessão atual..."
unset SDKMAN_DIR
unset SDKMAN_CANDIDATES_API
unset SDKMAN_PLATFORM

echo "✅ SDKMAN removido com sucesso!"
echo ""
echo "➡️ Feche e reabra o terminal para concluir a limpeza."
