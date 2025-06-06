#!/usr/bin/env bash
set -euo pipefail

# Função para exibir erro e sair
die() {
  echo "Erro: $*" >&2
  exit 1
}

if [[ $EUID -ne 0 ]]; then
  echo "Este script precisa ser executado como root."
  echo "Executando via sudo..."
  exec sudo bash "$0" "$@"
fi

echo "=============================================================="
echo "ID atual da máquina (antes da regeneração):"
echo "--------------------------------------------------------------"
cat /etc/machine-id 
echo "=============================================================="
echo

echo "Removendo machine-id e dbus-id antigos..."
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id
echo "Feito."
echo

echo "Gerando novo machine-id via systemd-machine-id-setup..."
systemd-machine-id-setup
echo "Novo /etc/machine-id criado."
echo

if [[ ! -L /var/lib/dbus/machine-id ]]; then
  echo "Criando link simbólico para /var/lib/dbus/machine-id → /etc/machine-id"
  ln -sf /etc/machine-id /var/lib/dbus/machine-id
else
  echo "Link simbólico para D-Bus já existe e foi atualizado."
fi
echo

echo "=============================================================="
echo "ID novo da máquina (depois da regeneração):"
echo "--------------------------------------------------------------"
cat /etc/machine-id
echo "=============================================================="
echo

# Perguntar ao usuário se quer reiniciar agora
read -rp "Deseja reiniciar a máquina agora para aplicar mudanças? [s/N] " resposta
resposta=${resposta,,}  # transforma em minúsculas
if [[ $resposta =~ ^(s|sim)$ ]]; then
  echo "Reiniciando... (salve seus arquivos antes!)"
  reboot
else
  echo "Ok, reinicie manualmente quando achar conveniente."
  exit 0
fi

