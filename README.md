# WSL Developer Experience (DX) Scripts

Scripts to improve DX on Windows Subsystem for Linux distros.

## What do the Scripts do?

- Install WSL Ubuntu if not already installed
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
- Install and configure [fzf](https://github.com/junegunn/fzf)
  - Configure fzf for Zsh
- Install and configure SSH
  - Configure SSH for Zsh

## Install

1. Open a PowerShell prompt as an Administrator
1. run

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nerdyman/wsl-dx-scripts/main/clone.ps1'))
   ```

   **OR**

   [Download the Zip](https://github.com/nerdyman/wsl-dx-scripts/archive/refs/heads/main.zip), extract it, and run `./run.ps1` manually

## Available Scripts

Although this is primarily aimed towards WSL installs, the actual distro scripts can run directly on a Linux box.

- [`agnostic.sh`](./agnostic.sh) - \*_should_ work on any Linux distro
  - Install and configure Oh My Zsh
  - Install and configure nvm
  - Install and configure Starship Cross-Shell Prompt
  - Configure default shell (Zsh)
  - Configure fzf for Zsh (fzf install is handled in distro script)
  - Configure grc for Zsh (grc install is handled in distro script)
  - Configure SSH for Zsh (SSH install is handled in distro script)
- [`ubuntu.sh`](./ubuntu.sh) - Install and configure Ubuntu packages
  - [Install fzf, SSH, Zsh, and useful shell utilities](./ubuntu.sh#L8)
  - Configure Zsh Syntax Highlighting

\* Only tested on Ubuntu.

## Notes

[Chocolatey](https://chocolatey.org/) is used to install the distro.
