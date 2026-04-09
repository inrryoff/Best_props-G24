#!/system/bin/sh

MODPATH=${0%/*}
BACKUP="$MODPATH/system.prop.backup"

log() { echo "ConfigProps: $1"; }

log "Desinstalando..."

# Restaura props do backup
if [ -f "$BACKUP" ]; then
    while IFS='=' read -r key value; do
        [ -z "$key" ] && continue
        echo "$key" | grep -q "^\[" && continue
        
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        if [ -n "$key" ]; then
            if [ -n "$value" ]; then
                resetprop "$key" "$value" 2>/dev/null
            else
                resetprop --delete "$key" 2>/dev/null
            fi
        fi
    done < "$BACKUP"
    log "Props restauradas"
fi

# Limpa arquivos temporários
rm -f /data/local/tmp/config_props_* 2>/dev/null
rm -f /data/local/tmp/gamehub_* 2>/dev/null

# Restaura resolução
wm size reset 2>/dev/null
wm density reset 2>/dev/null

log "Desinstalação concluída"
exit 0