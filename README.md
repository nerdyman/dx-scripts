# Developer Experience (DX) Scripts

Scripts to improve Developer Experience.

## What do the Scripts do?

- Install useful distro packages
- Install and configure [Zsh](https://www.zsh.org/)
  - Set the default shell to Zsh
  - Install [Oh My Zsh](https://ohmyz.sh/)
  - [Enable Oh My Zsh plugins](./agnostic.sh#L23)
  - Enable [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- Install and configure [Starship Cross-Shell Prompt](https://starship.rs/)
- Install and configure [Node Version Manager (nvm)](https://github.com/nvm-sh/nvm)
  - Enable Zsh hook to automatically load Node.js version from an `.nvmrc` config
- Install and configure [Generic Colouriser (grc)](https://github.com/garabik/grc)
  - Configure Zsh settings to for better `ls` colours
- Install and configure [fzf](https://github.com/junegunn/fzf) (fuzzy finder)
  - Configure fzf for Zsh
- Install and configure SSH
  - Configure SSH for Zsh

## Install

```sh
bash -c "$(curl -fsSL https://raw.github.com/nerdyman/dx-scripts/main/install.sh)"
```

## Alias and Environment Files

Aliases are set in [`~/.config/aliases`](./.config/aliases).

`~p` is aliased to `~/Documents/projects`, you can use it like:

```
~p/my-cool-project/hello-world.sh
```

The following paths are also sourced in `.zshrc` if they exist:

- `~/.config/aliases.private`
- `~/.config/env.private`

## Supported Platforms

The agnostic script _should_ work on any Unix/Linux OS. Ubuntu is currently the only
distro with its own script to auto install dependencies for the agnostic script.

## Scripts

- [`agnostic.sh`](./agnostic.sh) \*
  - Install and configure Oh My Zsh
  - Install and configure nvm
  - Install and configure Starship Cross-Shell Prompt
  - Configure default shell (Zsh)
  - Configure fzf for Zsh (fzf install is handled in distro script)
  - Configure grc for Zsh (grc install is handled in distro script)
  - Configure SSH for Zsh (SSH install is handled in distro script)
- [`ubuntu.sh`](./ubuntu.sh) - Install and configure Ubuntu packages
  - [Install fzf, SSH, Zsh, and useful shell utilities](./ubuntu.sh#L9)

\* Only tested on Ubuntu.
