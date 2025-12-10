# Reset Cursor
Script simples para limpar dados locais do Cursor/VS Code, zerar a machine-id e tentar restaurar o MAC da interface Wi-Fi.

## Aviso
- Execute por sua conta e risco; ele apaga dados locais e requer sudo para partes do processo.
- Reiniciar ao final é recomendado para aplicar totalmente o reset.

## Requisitos
- Linux com systemd
- sudo habilitado
- `macchanger` instalado (para o reset opcional de MAC)

## Uso rápido
1) Ajuste a interface em `APP_WIFI_IFACE` no `reset-cursor.sh` se não for `wlp2s0`.
2) Execute:
```
chmod +x reset-cursor.sh
./reset-cursor.sh
```
3) Confirme os prompts; ao final escolha se deseja reiniciar.

## O que o script faz
- Encerra processos do Cursor/VS Code.
- Remove caches e configs do Cursor e VS Code.
- Limpa keyring do usuário.
- Reseta `/etc/machine-id` e `/var/lib/dbus/machine-id` via `systemd-machine-id-setup`.
- Tenta restaurar o MAC da interface Wi-Fi configurada usando `macchanger -p`.

