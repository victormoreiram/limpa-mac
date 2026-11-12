#!/bin/bash

# Garantir que $HOME aponte para o usuário real mesmo se rodado com sudo
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})

echo "=========================================="
echo "🧹 SCRIPT DE LIMPEZA AVANÇADA DO MACOS"
echo "=========================================="
read -p "Tem certeza que deseja iniciar a limpeza? (s/n): " confirmacao

if [[ ! "$confirmacao" =~ ^[Ss]$ ]]; then
    echo "❌ Operação cancelada."
    exit 0
fi

# Solicitar senha de administrador no início e manter ativa
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Capturar espaço livre inicial (em KB)
ESPACO_INICIAL=$(df -k / | tail -1 | awk '{print $4}')

# Lista de diretórios seguros para esvaziar completamente
PASTAS_PARA_LIMPAR=(
    # Caches e Logs do Usuário e Sistema
    "$USER_HOME/Library/Caches"
    "/Library/Caches"
    "$USER_HOME/Library/Logs"
    "/Library/Updates"
    "$USER_HOME/.Trash"

    # Relatórios de Crash / Diagnóstico
    "$USER_HOME/Library/Application Support/CrashReporter"
    "$USER_HOME/Library/Logs/DiagnosticReports"
    "/Library/Logs/DiagnosticReports"

    # Estados Salvos de Aplicativos
    "$USER_HOME/Library/Saved Application State"

    # Xcode e Desenvolvimento Apple
    "$USER_HOME/Library/Caches/com.apple.dt.Xcode"
    "$USER_HOME/Library/Logs/Xcode"
    "$USER_HOME/Library/Developer/Xcode/DerivedData"
    "$USER_HOME/Library/Developer/Xcode/Index.noindex"
    "$USER_HOME/Library/Developer/Xcode/iOS DeviceSupport"
    "$USER_HOME/Library/Developer/CoreSimulator/Caches"
    "$USER_HOME/Library/Caches/org.carthage.CarthageKit"
    "$USER_HOME/Library/Caches/com.apple.swiftpm"

    # Caches de Apps Pesados (executados apenas se existirem)
    "$USER_HOME/Library/Application Support/Slack/Cache"
    "$USER_HOME/Library/Application Support/Slack/Service Worker/CacheStorage"
    "$USER_HOME/Library/Application Support/discord/Cache"
    "$USER_HOME/Library/Application Support/discord/Code Cache"
    "$USER_HOME/Library/Application Support/Spotify/PersistentCache"
    "$USER_HOME/Library/Application Support/Code/Cache"
    "$USER_HOME/Library/Application Support/Code/CachedData"
    "$USER_HOME/Library/Application Support/Code/User/workspaceStorage"

    # Gerenciadores de Pacotes (Arquivos brutos de cache)
    "$USER_HOME/.npm/_cacache"
    "$USER_HOME/.cache/pip"
    "$USER_HOME/Library/Caches/Homebrew"
    "$USER_HOME/Library/Caches/CocoaPods"
    "$USER_HOME/Library/Caches/Yarn"
)

# Função para limpar o conteúdo de uma pasta (incluindo arquivos ocultos)
limpar_pasta() {
    local pasta="$1"
    if [ -d "$pasta" ]; then
        echo "Limpando: $pasta"
        # Limpa arquivos normais e ocultos sem apagar a pasta-mãe
        sudo find "$pasta" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
        echo "✅ Conteúdo de $pasta removido."
    else
        echo "⏭️  Ignorando (não encontrado): $pasta"
    fi
}

echo -e "\n--- 1. Limpando Diretórios de Cache e Logs ---"
for pasta in "${PASTAS_PARA_LIMPAR[@]}"; do
    limpar_pasta "$pasta"
done

echo -e "\n--- 2. Limpando /var/log de forma segura ---"
# Apaga apenas arquivos de log antigos/compactados sem destruir a estrutura de pastas
sudo find /var/log -type f \( -name "*.log" -o -name "*.gz" -o -name "*.bz2" -o -name "*.out" -o -name "*.old" \) -delete 2>/dev/null
echo "✅ Logs de sistema (/var/log) limpos."

echo -e "\n--- 3. Limpando arquivos temporários antigos (/tmp) ---"
# Apaga apenas arquivos não acessados nos últimos 3 dias para não travar apps abertos
sudo find /private/var/tmp -mindepth 1 -mtime +3 -delete 2>/dev/null
echo "✅ Arquivos temporários antigos removidos."

echo -e "\n--- 4. Ferramentas de Desenvolvimento e Sistema ---"

# Simulador do Xcode: remove simuladores que não são mais suportados pela versão atual
if command -v xcrun &> /dev/null; then
    echo "Removendo simuladores indisponíveis do Xcode..."
    xcrun simctl delete unavailable 2>/dev/null
    echo "✅ Simuladores obsoletos removidos."
fi

# Homebrew Cleanup
if command -v brew &> /dev/null; then
    echo "Executando limpeza do Homebrew..."
    brew cleanup --prune=all -s 2>/dev/null
    echo "✅ Homebrew limpo."
fi

# Limpar cache de miniaturas do QuickLook (Finder)
echo "Resetando cache do QuickLook..."
qlmanage -r cache &>/dev/null
echo "✅ Cache do QuickLook limpo."

# Limpar cache de DNS
echo "Limpando cache de DNS..."
sudo dscacheutil -flushcache 2>/dev/null
sudo killall -HUP mDNSResponder 2>/dev/null
echo "✅ Cache de DNS renovado."

# Cálculo do espaço recuperado
ESPACO_FINAL=$(df -k / | tail -1 | awk '{print $4}')
DIFERENCA_KB=$((ESPACO_FINAL - ESPACO_INICIAL))

echo "=========================================="
if [ "$DIFERENCA_KB" -gt 0 ]; then
    DIFERENCA_MB=$((DIFERENCA_KB / 1024))
    echo "🎉 Limpeza concluída! Espaço aproximado liberado: ${DIFERENCA_MB} MB"
else
    echo "🎉 Limpeza concluída! Seu sistema já estava bem enxuto."
fi
echo "=========================================="
