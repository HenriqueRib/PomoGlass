#!/bin/bash

APP_NAME="PomoGlass"
BUILD_DIR="dist"
EXECUTABLE="Pomodoro"

echo "🔨 Iniciando Build do $APP_NAME..."

# Limpar build anterior
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/$APP_NAME.app/Contents/MacOS"
mkdir -p "$BUILD_DIR/$APP_NAME.app/Contents/Resources"

# Copiar Recursos (Localização, etc)
cp -R PomoGlass/Resources/* "$BUILD_DIR/$APP_NAME.app/Contents/Resources/"

# Compilar o código
swiftc $(find PomoGlass -name "*.swift") -o "$BUILD_DIR/$APP_NAME.app/Contents/MacOS/$APP_NAME" -framework Cocoa -framework SwiftUI -framework UserNotifications

# Criar o Info.plist básico necessário para Notificações, Bundle ID e Localização
cat > "$BUILD_DIR/$APP_NAME.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.henrique.zenbar</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>pt</string>
        <string>es</string>
    </array>
</dict>
</plist>
EOF

echo "✅ App criado com sucesso em $BUILD_DIR/$APP_NAME.app"
echo "🚀 Para rodar: open $BUILD_DIR/$APP_NAME.app"
