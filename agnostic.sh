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
    mv "${_zshrc_path}" "${_zshrc_path}.old"
fi

echo "[agnostic][Oh My Zsh]"
echo "[agnostic] => Installing..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "[agnostic] => Enabling plugins"
sed -i 's/plugins=(git/plugins=(\n dircycle\n colored-man-pages\n extract\n fzf\n git\n git-flow-avh\n grc\n npm\n nvm\n ssh-agent\n yarn\n/' "${_zshrc_path}"

echo "[agnostic][Set Shell Defaults]"
cat >> "${_zshrc_path}" <<_EOF_
export CLICOLOR=1
export EDITOR=vim
export TERM=xterm-256color

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
if test -n "${__ZSH_SYNTAX_HIGHLIGHTING_PATH__}"; then
  echo -e "source ${__ZSH_SYNTAX_HIGHLIGHTING_PATH__}\n" >> "$_zshrc_path"
else
  echo "[agnostic] => __ZSH_SYNTAX_HIGHLIGHTING_PATH__ environment variable is not set, cannot configure plugin"
fi

echo "[agnostic][Set Up Aliases]"
mkdir -p "${HOME}/.config"
cp ./.config/aliases "${HOME}/.config"
cat >> "$_zshrc_path" <<_EOF_
[[ -f "${HOME}/.config/aliases" ]] && source "${HOME}/.config/aliases"
[[ -f "${HOME}/.config/aliases.private" ]] && source "${HOME}/.config/aliases.private"
[[ -f "${HOME}/.config/env.private" ]] && source "${HOME}/.config/env.private"

_EOF_

echo "[agnostic][Install nvm]"
echo -e "export NVM_AUTOLOAD=1\n" >> "$_zshrc_path"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

echo "[agnostic][Add Zsh hooks]"
cat >> "$_zshrc_path" << _EOF_
autoload -U add-zsh-hook
autoload bashcompinit
bashcompinit

_EOF_

echo "[agnostic][Starship Cross-Shell Prompt]"
echo "[agnostic] => Installing..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
cat >> "${_zshrc_path}" <<_EOF_
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export STARSHIP_SHELL=zsh
eval "$(starship init zsh)"
_EOF_

if ! test -n "${__HAS_PREINSTALL_SCRIPT__}"; then
  zsh
fi

echo -e "[agnostic] Done\n"
