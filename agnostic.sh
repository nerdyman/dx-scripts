#!/bin/bash -e

# Distro-agnostic script to install and configure devtools

echo "[Set Shell]"
sudo chsh -s /bin/zsh
echo "[/Set Shell]"

_zshrc_path="${HOME}/.zshrc"

echo "[Set Shell Defaults]"
if test -f "${_zshrc_path}"; then
    echo "=> Copying existing ${_zshrc_path} to ${_zshrc_path}.old"
    cp "${_zshrc_path}" "${_zshrc_path}.old"
fi
sed -i '1s/^/export TERM=xterm\nexport EDITOR=vim\n/' ~/.zshrc
echo "[/Set Shell Defaults]"

echo "[Oh My Zsh]"
echo "=> Installing..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "=> Enabling plugins"
ed -i 's/plugins=(/plugins=(\n  dircycle\n  colored-man-pages\n  fzf\n  git\n  git-flow-avh\n  npm\n  yarn/' ~/.zshrc
echo "[/Oh My Zsh]"

echo "[Node Version Manager]"
echo "=> Installing"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# Auto-load `.nvmrc` files.
cat >> "${_zshrc_path}" <<_EOF_
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "\$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "\${nvmrc_path}")")

    if [ "\$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "\$nvmrc_node_version" != "\$node_version" ]; then
      nvm use
    fi
  elif [ "\$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
_EOF_
echo "[/Node Version Manager]"

echo "[Configure fzf for ZSH]"
cat >> "${_zshrc_path}" <<_EOF_
## fzf
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
export FZF_BASE=/usr/bin/fzf
_EOF_
echo "[/Configure fzf for ZSH]"

echo "[Generic Colouriser]"
echo "=> Configuring"
cat >> "${_zshrc_path}" <<_EOF_
# ls alias needed for grc to highlight dir listings correctly https://github.com/garabik/grc/issues/36
alias ls='grc --colour=auto ls --color=always'
source /etc/grc.zsh
_EOF_
echo "[/Generic Colouriser]"

echo "[Starship Cross-Shell Prompt]"
echo "=> Installing..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
cat >> "${_zshrc_path}" <<_EOF_
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export STARSHIP_SHELL=zsh
eval "$(starship init zsh)"
_EOF_
echo "[/Starship Cross-Shell Prompt]"
