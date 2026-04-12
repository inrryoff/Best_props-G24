#!/system/bin/sh

detect_gsi() {
  if getprop ro.crdroid.version > /dev/null 2>&1; then return 0
  elif getprop ro.lineage.version > /dev/null 2>&1; then return 0
  elif getprop ro.gsi.version > /dev/null 2>&1; then return 0
  else return 1
  fi
}

if ! detect_gsi; then
  ui_print "❌ Este módulo é APENAS para GSI"
  abort
fi

ui_print "✅ GSI detectada! Continuando..."

ui_print "- Criando backup das propriedades atuais..."
getprop > $MODPATH/system.prop.backup

ui_print "- Definindo permissões..."
set_perm $MODPATH/system.prop 0 0 0755
set_perm $MODPATH/system.prop.backup 0 0 0755
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755
