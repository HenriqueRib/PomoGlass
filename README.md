# 🍅 PomoGlass

**PomoGlass** é um timer Pomodoro focado em produtividade, minimalismo e estética. Inspirado na linguagem visual do iOS, ele vive silenciosamente na sua barra de menus do macOS, ajudando você a manter o foco sem interrupções desnecessárias.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/swift-6.0-orange.svg)

## ✨ Funcionalidades

- **100% Menu Bar:** Sem ícones no Dock ou janelas perdidas.
- **Design iOS Style:** Interface com Glassmorphism, bordas arredondadas e anel de progresso dinâmico.
- **Interação Rápida:** 1-Clique para iniciar/pausar.
- **Notificações Nativas:** Receba alertas sonoros e visuais quando sua sessão terminar.
- **Modos Pré-definidos:** Alternância rápida entre Foco (25min) e Pausa Curta (5min).

## 🚀 Como Executar (Desenvolvimento)

Para rodar o projeto localmente sem o Xcode:

1. Clone o repositório.
2. Execute o script de build para gerar o bundle `.app`:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
3. O aplicativo estará na pasta `dist/PomoGlass.app`.

## 🛠 Tech Stack

- **Linguagem:** Swift 6
- **Framework:** SwiftUI (Interface) & AppKit (Menu Bar Controller)
- **Engine:** UserNotifications para alertas nativos.

## 🤝 Contribuindo

Contribuições são o que fazem a comunidade open source um lugar incrível para aprender, inspirar e criar. Qualquer contribuição que você fizer será **muito apreciada**.

1. Faça um Fork do projeto.
2. Crie sua Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`).
4. Push para a Branch (`git push origin feature/AmazingFeature`).
5. Abra um Pull Request.

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---
Criado com ❤️ por [Seu Nome/Github]
