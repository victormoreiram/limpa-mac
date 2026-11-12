# 🧹 LimpaMac — Script de Limpeza Avançada para macOS

Um script em Bash leve, seguro e automatizado para liberar espaço em disco, remover caches acumulados de aplicativos, limpar resíduos de desenvolvimento e otimizar o desempenho geral do macOS.

---

## ✨ O que o script faz?

Diferente de limpezas agressivas que podem quebrar permissões ou apagar configurações importantes, o **LimpaMac** foca apenas em arquivos descartáveis e caches seguros:

* **Caches e Logs do Sistema/Usuário:** Limpa `~/Library/Caches`, `/Library/Caches`, logs antigos e esvazia a Lixeira.
* **Relatórios de Falha (Crash Reports):** Remove diagnósticos acumulados em `DiagnosticReports` e `CrashReporter`.
* **Ambiente de Desenvolvimento (Xcode & Apple):** Limpa `DerivedData`, `Index.noindex`, `iOS DeviceSupport`, caches do Swift Package Manager, Carthage e remove simuladores obsoletos via `xcrun`.
* **Gerenciadores de Pacotes:** Limpa caches do **Homebrew**, **npm**, **Yarn**, **CocoaPods** e **pip** (executado automaticamente caso estejam instalados).
* **Caches de Aplicativos Pesados:** Remove arquivos temporários de apps como **VS Code**, **Slack**, **Discord** e **Spotify**.
* **Limpeza Segura de Sistema:**
  * Apaga apenas arquivos antigos (`.log`, `.gz`, `.old`, etc.) em `/var/log` sem destruir a estrutura de diretórios necessária para os serviços do sistema.
  * Remove arquivos temporários em `/private/var/tmp` não acessados há mais de 3 dias, evitando travamentos em aplicativos abertos.
* **Otimizações Visuais e de Rede:**
  * Reseta o cache de miniaturas do Finder (`QuickLook`).
  * Renova o cache de DNS do macOS (`mDNSResponder`).
  * *(Opcional)* Reconstrói o banco de dados do `LaunchServices` e reinicia a Central de Notificações/Dock para eliminar widgets fantasmas de apps já desinstalados.
* **Relatório de Espaço:** Calcula e exibe ao final quantos megabytes (MB) foram liberados após a execução.

---

## 🛡️ Segurança e Boas Práticas

* **Preserva seus dados:** Não apaga documentos pessoais, favoritos da barra lateral do Finder ou configurações de aplicativos.
* **Compatível com SIP (System Integrity Protection):** Ignora silenciosamente diretórios protegidos nativamente pelo macOS (como caches internos do Safari e CloudKit) para evitar alertas desnecessários no Terminal.
* **Confirmação antes de executar:** Exige confirmação manual (`s/n`) antes de iniciar qualquer remoção.

---

## 🚀 Como usar:

### 1. Clone o repositório ou baixe o script:
```bash
git clone [https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git](https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git)
cd SEU-REPOSITORIO
```

### 2. Dê permissão de execução ao arquivo:
No Terminal, torne o script executável (e remova eventuais bloqueios de quarentena do macOS, se necessário):
```bash
chmod +x LimpaMac.sh
xattr -c LimpaMac.sh
```
### 3. Execute o script:
```bash
./LimpaMac.sh
```
Nota: Será solicitada a sua senha de administrador (sudo) para limpar caches globais e logs do sistema. Digite sua senha normalmente (os caracteres não aparecem na tela por segurança) e pressione Enter.

## ⚠️ Aviso Legal
* Este script foi desenvolvido para remover apenas arquivos temporários e caches seguros. Ainda assim, utilize-o por sua conta e risco e certifique-se de salvar seus trabalhos abertos antes de iniciar a limpeza.


## 📄 Licença
* Este projeto está sob a licença MIT. Sinta-se à vontade para usar, modificar e distribuir.
