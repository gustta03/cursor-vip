#!/usr/bin/env bash
set -e

APP_WIFI_IFACE="wlp2s0"   # ajuste se necessário

echo "========================================"
echo " LIMPEZA LOCAL + RESET DE IDENTIDADE"
echo "========================================"

read -p "Isso apagará dados locais e resetará machine-id. Continuar? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortado."
  exit 1
fi

echo ""
echo "Fechando processos..."
pkill -f cursor || true
pkill -f code || true

echo "Removendo dados do Cursor..."
rm -rf ~/.config/Cursor \
       ~/.cache/Cursor \
       ~/.local/share/Cursor \
       ~/.cursor

echo "Removendo dados herdados do VS Code (opcional, mas incluso)..."
rm -rf ~/.config/Code \
       ~/.cache/Code \
       ~/.local/share/Code

echo "Limpando keyring do usuário..."
rm -rf ~/.local/share/keyrings/* || true

echo "Resetando machine-id (requer sudo)..."
sudo rm -f /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo systemd-machine-id-setup

echo "Tentando resetar MAC address da interface ${APP_WIFI_IFACE} (opcional)..."
if ip link show "$APP_WIFI_IFACE" > /dev/null 2>&1; then
  sudo ip link set "$APP_WIFI_IFACE" down
  sudo macchanger -p "$APP_WIFI_IFACE"
  sudo ip link set "$APP_WIFI_IFACE" up
else
  echo "   Interface ${APP_WIFI_IFACE} não encontrada. Pulando."
fi

echo ""
echo "Concluído."
read -p "Reiniciar agora? (y/N): " reboot_confirm
if [[ "$reboot_confirm" == "y" || "$reboot_confirm" == "Y" ]]; then
  sudo reboot
else
  echo "Reinicie manualmente para finalizar."
fi
