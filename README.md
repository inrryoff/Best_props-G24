# ⚡ Best_props-G24 - Módulo Magisk de Performance

**Otimizações avançadas de sistema para Moto G24 (Helio G85)**

[![Magisk](https://img.shields.io/badge/Magisk-27.0+-green.svg)](https://github.com/topjohnwu/Magisk)
[![Android](https://img.shields.io/badge/Android-12+-blue.svg)](https://www.android.com)
[![Device](https://img.shields.io/badge/Device-Moto_G24-orange.svg)](https://motorola.com)

---

## 📱 Sobre

Best_props-G24 é um módulo Magisk que aplica otimizações de performance ao sistema, com **failsafe integrado** que previne bootloop.

### Características

- ⚡ **Props otimizadas** para Helio G85
- 🔧 **Failsafe automático** (restaura tudo em 2 boots falhos)
- 🎮 **Melhorias de GPU/UI**
- 📊 **Otimizações de RAM e I/O**
- 🔄 **Backup automático** das props originais

---

## ✅ Requisitos

| Requisito | Especificação |
|-----------|--------------|
| **Dispositivo** | Moto G24 (fogorow) |
| **Android** | 12+ |
| **Magisk** | 27.0+ |
| **Root** | Sim |

---
### ⚠️ Aviso
Este modulo foi desenvolvido em uma GSI (Ganeric System Image) **CrDroid** portanto o uso deste modulo em ROM Stock (Original) pode ter incosistencias

## 📥 Instalação

### Instalação normal

1. Baixe o arquivo ZIP
2. Abra o Magisk Manager
3. Módulos → Instalar do armazenamento
4. Selecione o ZIP
5. Reinicie

### LICENÇA MIT
Faça oq quiser com o codigo apenas de os creditos ao dev originial [@inrryoff](https://github.com/inrryoff)

### Verificação da instalação

```bash
# Verificar se módulo está ativo
ls /data/adb/modules/Config_props/

# Verificar props aplicadas
getprop | grep -E "debug.hwui|debug.renderengine|dalvik.vm"
