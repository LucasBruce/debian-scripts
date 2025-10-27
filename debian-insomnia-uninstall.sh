#!/bin/bash
set -e

echo "Removendo Insomnia..."
sudo apt remove --purge -y insomnia

echo "Removendo dependências desnecessárias..."
sudo apt autoremove -y

echo "Removendo repositório e chave do Insomnia..."
sudo rm -f /etc/apt/sources.list.d/insomnia.list
sudo rm -f /usr/share/keyrings/insomnia-keyring.gpg

echo "Atualizando lista de pacotes..."
sudo apt update

echo "Desinstalação concluída!"
