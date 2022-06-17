#!/usr/bin/env bash
set -ex
# 判断当前的发行版平台
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/x64/g')

## 获取最新的稳定版本
wget -q https://update.code.visualstudio.com/latest/linux-deb-${ARCH}/stable -O vs_code.deb
dpkg -i vs_code.deb
mkdir -p /usr/share/icons/hicolor/apps
sed -i '/Icon=/c\Icon=/usr/share/icons/hicolor/apps/vscode.svg' /usr/share/applications/code.desktop
sed -i 's#/usr/share/code/code#/usr/share/code/code --no-sandbox##' /usr/share/applications/code.desktop
cp /usr/share/applications/code.desktop $HOME/Desktop
chmod +x $HOME/Desktop/code.desktop
chown 1000:1000 $HOME/Desktop/code.desktop
rm vs_code.deb

# Conveniences for python development
apt-get update
apt-get install -y --no-install-recommends python3-setuptools python3-venv python3-virtualenv
apt-get clean -y
rm -rf /var/lib/apt/lists/*
