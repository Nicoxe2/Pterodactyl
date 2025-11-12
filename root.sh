#!/bin/bash

# Verifica se está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script deve ser executado como root."
  exit 1
fi

echo "🔐 Configurando acesso SSH root com chave pública..."

# Cria o diretório .ssh do root com permissões corretas
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Copia a chave pública do usuário ubuntu
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

# Atualiza configurações do SSH
echo "🛠️ Editando /etc/ssh/sshd_config..."
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Reinicia o serviço SSH
echo "🔄 Reiniciando serviço SSH..."
systemctl restart ssh

echo "✅ Configuração concluída. Agora é possível acessar como root via chave pública."
