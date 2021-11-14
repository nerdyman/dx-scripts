#!/bin/sh -e

# shellcheck disable=SC1091

echo "[ubuntu]"

echo "[ubuntu] => Installing packages"
sudo apt update
sudo apt install -y bash-completion colordiff curl fzf git grc gzip jq keychain lzop neovim p7zip shellcheck sl unzip xz-utils zip zsh zsh-syntax-highlighting

export __ZSH_SYNAX_HIGHLIGHTING_PATH__="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

echo "[ubuntu] Running Agnostic Script"
source ./agnostic.sh

echo "[ubuntu] Done"
