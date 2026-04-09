#!/system/bin/sh

MODDIR=${0%/*}

# Arquivos de controle
FLAG_SUCCESS="/data/local/tmp/config_props_boot_success"
BOOT_COUNT="/data/local/tmp/config_props_boot_count"
MAX_RETRIES=2

# ============================================
# FUNÇÃO: Verifica se o boot foi bem sucedido
# ============================================
check_boot_success() {
    local wait_time=0
    local max_wait=120
    
    while [ $wait_time -lt $max_wait ]; do
        if [ "$(getprop sys.boot_completed)" = "1" ]; then
            return 0
        fi
        sleep 2
        wait_time=$((wait_time + 2))
    done
    
    return 1
}

# ============================================
# FUNÇÃO: Restaura props originais do backup
# ============================================
restore_original_props() {
    log -p i -t "ConfigProps" "Restaurando props originais..."
    
    if [ -f "$MODDIR/system.prop.backup" ]; then
        # Lê o backup linha por linha
        while IFS='=' read -r key value; do
            # Pula linhas vazias e comentários
            [ -z "$key" ] && continue
            echo "$key" | grep -q "^#" && continue
            
            # Remove espaços
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            
            # Restaura o valor original
            if [ -n "$key" ] && [ -n "$value" ]; then
                resetprop "$key" "$value" 2>/dev/null
                log -p i -t "ConfigProps" "Restaurado: $key=$value"
            fi
        done < "$MODDIR/system.prop.backup"
    fi
    
    # Desativa o módulo
    touch "$MODDIR/disable"
    
    log -p i -t "ConfigProps" "Props restauradas. Módulo desativado."
    
    # Reinicia para aplicar
    (sleep 2 && setprop sys.powerctl reboot) &
}

# ============================================
# FUNÇÃO: Marca boot como mal sucedido
# ============================================
mark_boot_failed() {
    local count=0
    if [ -f "$BOOT_COUNT" ]; then
        count=$(cat "$BOOT_COUNT")
    fi
    
    count=$((count + 1))
    echo "$count" > "$BOOT_COUNT"
    
    log -p w -t "ConfigProps" "Falha de boot detectada. Tentativa $count de $MAX_RETRIES"
    
    if [ $count -ge $MAX_RETRIES ]; then
        log -p e -t "ConfigProps" "Máximo de tentativas atingido! Restaurando..."
        restore_original_props
    fi
}

# ============================================
# FUNÇÃO: Marca boot como bem sucedido
# ============================================
mark_boot_success() {
    echo "1" > "$FLAG_SUCCESS"
    rm -f "$BOOT_COUNT" 2>/dev/null
    log -p i -t "ConfigProps" "Boot bem sucedido! Contador resetado."
}

# ============================================
# EXECUÇÃO PRINCIPAL
# ============================================

# Verifica se o backup existe (deve existir, você já criou)
if [ ! -f "$MODDIR/system.prop.backup" ]; then
    log -p e -t "ConfigProps" "ERRO: Backup não encontrado!"
    log -p e -t "ConfigProps" "Criando backup automático..."
    
    # Tenta criar backup automaticamente
    getprop > "$MODDIR/system.prop.backup"
    chmod 644 "$MODDIR/system.prop.backup"
fi

# Inicia monitoramento em background
(
    if check_boot_success; then
        mark_boot_success
    else
        mark_boot_failed
    fi
) &

log -p i -t "ConfigProps" "Módulo Config_props carregado. Failsafe ativo."
log -p i -t "ConfigProps" "Backup localizado em: $MODDIR/system.prop.backup"
