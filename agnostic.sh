#!/bin/bash -e

# Distro-agnostic script to install and configure devtools

if test ! -f "/bin/zsh"; then
  echo "Zsh is not installed, cannot continue."
  exit 127
fi

echo "[agnostic][Set Up Aliases]"
_config_dir="${HOME}/.config"
mkdir -p  "$_config_dir"
cp ./.config/aliases "$_config_dir"

echo "[agnostic][Set Shell]"
sudo chsh -s /bin/zsh

_zshrc_path="${HOME}/.zshrc"

echo "[agnostic][Set Shell Defaults]"
if test -f "${_zshrc_path}"; then
    echo "[agnostic] => Copying existing ${_zshrc_path} to ${_zshrc_path}.old"
    cp "${_zshrc_path}" "${_zshrc_path}.old"
fi

echo "[agnostic][Oh My Zsh]"
echo "[agnostic] => Installing..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "[agnostic] => Enabling plugins"
sed -i 's/plugins=\n(/plugins=(\n  dircycle\n  colored-man-pages\n  extract\n  fzf\n  git-flow-avh\n  grc\n  npm\n  nvm\n  ssh\n  yarn\n/' ~/.zshrc
echo "NVM_AUTOLOAD=1" >> "$_zshrc_path"

echo "[agnostic][Set Shell Defaults]"
cat >> "${_zshrc_path}" <<_EOF_
export EDITOR=vim
export TERM=xterm
_EOF_

echo "[agnostic][Configure fzf for Zsh]"
cat >> "${_zshrc_path}" <<_EOF_
## fzf
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

_EOF_

echo "[agnostic][Configure Zsh Syntax Highlighting]"
if test -n "${__ZSH_SYNAX_HIGHLIGHTING_PATH__}"; then
  echo "source ${__ZSH_SYNAX_HIGHLIGHTING_PATH__}" >> "$_zshrc_path"
else
  echo "[agnostic] => __ZSH_SYNAX_HIGHLIGHTING_PATH__ environment variable is not set, cannot configure plugin"
fi

echo "[agnostic][Set Up Aliases]"
mkdir -p "${HOME}/.config"
cp aliases "${HOME}/.config"
cat >> "$_zshrc_path" <<_EOF_
[[ -f "${HOME}/.config/aliases" ]] && source "${HOME}/.config/aliases"
[[ -f "${HOME}/.config/aliases.private" ]] && source "${HOME}/.config/aliases.private"
[[ -f "${HOME}/.config/env.private" ]] && source "${HOME}/.config/env.private"

_EOF_

echo "[agnostic][Install nvm]"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

echo "[agnostic][Starship Cross-Shell Prompt]"
echo "[agnostic] => Installing..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
cat >> "${_zshrc_path}" <<_EOF_
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export STARSHIP_SHELL=zsh
eval "$(starship init zsh)"
_EOF_

zsh

echo "[agnostic] Done"
