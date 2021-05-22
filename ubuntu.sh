#!/bin/bash -e

# shellcheck disable=SC1091

echo "[Ubuntu]"
echo "=> Installing packages"
sudo apt update
sudo apt install bash-completion colordiff curl fzf git grc gzip jq lzop p7zip unzip xz zip zsh zsh-syntax-highlighting

source agnostic.sh

echo "=> Adding zsh-syntax-highlighting to zshrc"

echo "[/Ubuntu]"
