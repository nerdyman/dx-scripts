# WSL Developer Experience Scripts

Scripts to improve Developer Experience (DX) on Windows Subsystem for Linux distros.

## What do the Scripts do?

- Install Ubuntu for WSL
- Install standard development utilities
- Install and configure [Zsh](https://www.zsh.org/)
  - Set the default shell to Zsh
  - Install [Oh My Zsh](https://ohmyz.sh/)
  - Enable useful Oh My Zsh plugins
  - Enable [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- Install and configure [Starship Cross-Shell Prompt](https://starship.rs/)
- Install and configure [Node Version Manager (nvm)](https://github.com/nvm-sh/nvm)
  - Enable Zsh hook to automatically load Node.js version from an `.nvmrc` config
- Install and configure [Generic Colouriser (grc)](https://github.com/garabik/grc)
  - Configure Zsh settings to for better `ls` colours
- Install and configure [fzf](https://github.com/junegunn/fzf)
  - Configure fzf for Zsh

## Install

Prerequisites:

- [winget](https://github.com/microsoft/winget-cli)

1. Open a PowerShell prompt
1. run

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nerdyman/wsl-dx-scripts/clone.ps1'))
   ```

   **OR**

   [Download the Zip](), extract it, and run `./run.ps1` manually

1. Get developin'

## Available Scripts

Although this is primarily aimed towards WSL installs, the actual distro scripts can run directly on a Linux machine.

- [`agnostic.sh`](./agnostic.sh) - \*_should_ work on any Linux distro
  - Install and configures Oh My Zsh
  - Install and configures nvm
  - Install and configure Starship Cross-Shell Prompt
  - Configure default shell (Zsh)
  - Configure fzf for Zsh (fzf install is handled in distro script)
  - Configure SSH for Zsh (SSH install is handled in distro script)
- [`ubuntu.sh`](./ubuntu.sh) - Install and configure Ubuntu packages
  - [Install fzf, SSH, Zsh, and useful shell utilities](./ubuntu.sh#L8)
  - Configure Zsh Syntax Highlighting

\* Only tested on Ubuntu.

## Notes

`run.ps1` uses [Chocolatey](https://chocolatey.org/) to install the distro.
