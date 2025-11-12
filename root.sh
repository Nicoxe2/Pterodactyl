#!/bin/bash

# Root-SSH-Oracle: Script para habilitar acesso SSH como root via chave pública
# Compatível com Ubuntu e pronto para uso com Git

set -e

# Verifica se está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Este script deve ser executado como root (use sudo)."
  exit 1
fi

# Usuário de origem (pode ser alterado conforme necessário)
ORIG_USER="ubuntu"
ORIG_AUTH_KEYS="/home/$ORIG_USER/.ssh/authorized_keys"

echo "🔍 Verificando chave pública de $ORIG_USER..."
if [ ! -f "$ORIG_AUTH_KEYS" ]; then
  echo "❌ Chave pública não encontrada em $ORIG_AUTH_KEYS"
  exit 1
fi

echo "🔐 Configurando diretório SSH do root..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cp "$ORIG_AUTH_KEYS" /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

echo "🛠️ Atualizando configurações do SSH..."
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

echo "🔄 Reiniciando serviço SSH..."
systemctl restart ssh

echo "✅ Root-SSH-Oracle: acesso SSH como root configurado com sucesso!"
