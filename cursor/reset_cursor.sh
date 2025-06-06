#!/bin/bash

echo "Encerrando o Cursor (se estiver em execução)..."
pkill -f Cursor

echo "Removendo cache, configs e dados do Cursor..."
rm -rf ~/.config/Cursor
rm -rf ~/.cache/Cursor
rm -rf ~/.local/share/Cursor

echo "Limpando concluído!"

echo "Tudo pronto. Reabra o Cursor manualmente."
