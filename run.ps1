#Requires -RunAsAdministrator
Param ([string] $distro = "ubuntu")

Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop'

$TEXT_INFO = (Get-Culture).TextInfo
# Distro to install.
$TARGET_DISTRO = "$($TEXT_INFO.toLower($distro))"
# List of supported distros.
$TARGET_DISTROS_AVAILABLE = @("arch-linux", "ubuntu")
# Dictionary of supported distros.
$TARGET_DISTROS_ENUM = [pscustomobject]@{
  archLinux = $TARGET_DISTROS_AVAILABLE[0]
  ubuntu    = $TARGET_DISTROS_AVAILABLE[1]
}
# Friendly name for the new distro instance.
$TARGET_INSTANCE = "${TARGET_DISTRO}-dx"

### [Utilities] ###

# Welcome to Windows. The OS where the DX is 💩 and the encoding doesn't matter.
function Write-Emoji {
  param (
    [Parameter(Position = 0, Mandatory = $true)] [string] $Emoji
  )

  $Unicode = "u+${Emoji}" -replace 'U\+', ''
  [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

function Write-Heading {
  param (
    [Parameter(Position = 0, Mandatory = $true)] [string] $Heading,
    [Int16] $Depth = 0
  )

  $HeadingColor = "Gray"
  $Indent = ""
  $Prefix = "=> "

  For ($i = 0; $i -lt $Depth; $i++) {
    $Indent += " ${Indent}"
  }

  if (($Depth -eq 0)) {
    $HeadingColor = "Green"
    $Prefix = ""
  }

  if (($Depth -eq 1)) {
    $HeadingColor = "White"
  }

  Write-Host `
    "${Indent}${Prefix}" -ForegroundColor DarkGray -BackgroundColor Black -NoNewline; `
    Write-Host ${Heading} -ForegroundColor ${HeadingColor} -BackgroundColor Black
  ;
}

# https://stackoverflow.com/a/37353046/2716192
function Test-FeatureIsEnabled {
  param(
    [Parameter(Position = 0, Mandatory = $true)] [string] $FeatureName
  )

  if ((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online).State -eq "Enabled") {
    return $true;
  }

  return $false;
}

# https://stackoverflow.com/a/3919904/2716192
function Test-CommandDoesExist {
  param(
    [Parameter(Position = 0, Mandatory = $true)] [string] $Command
  )

  if (Get-Command $Command -errorAction SilentlyContinue) {
    return $true
  }

  return $false
}

### [Tasks] ###

function Show-BuildParams {
  Write-Host `
    "[" -ForegroundColor DarkGray -BackgroundColor Black -NoNewline; `
    Write-Host "$(Write-Emoji "1F427") WSL DX Scripts $(Write-Emoji "1F427")" -ForegroundColor White -BackgroundColor Black -NoNewline; `
    Write-Host "]" -ForegroundColor DarkGray -BackgroundColor Black `n
  ;

  if (!($TARGET_DISTROS_AVAILABLE -contains $TARGET_DISTRO)) {
    Write-Host -ForegroundColor Red -BackgroundColor Black "Invalid '-distro' provided, must be one of:"

    ForEach ($Node in $TARGET_DISTROS_AVAILABLE) {
      Write-Host -ForegroundColor Red -BackgroundColor Black " - $($Node)"
    }

    Write-Host -ForegroundColor White -BackgroundColor Black `n"Exiting"`n

    exit
  }

  Write-Host `
    "Installing distro '" -ForegroundColor White -BackgroundColor Black -NoNewline; `
    Write-Host "${TARGET_DISTRO}" -ForegroundColor Green -BackgroundColor Black -NoNewline; `
    Write-Host "' as '" -ForegroundColor White -BackgroundColor Black -NoNewline; `
    Write-Host "${TARGET_INSTANCE}" -ForegroundColor Green -BackgroundColor Black -NoNewline; `
    Write-Host "'" -ForegroundColor White -BackgroundColor Black `n
}

function Install-WSL {
  Write-Heading "Install WSL"

  if ((Test-FeatureIsEnabled "Microsoft-Windows-Subsystem-Linux") -eq $false) {
    Write-Heading -Depth 1 "Installing WSL"
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
  }
  else {
    Write-Heading -Depth 1 "WSL is already installed $(Write-Emoji "1f389")"
  }

  Write-Heading -Depth 1 "Setting default WSL version"
  wsl --set-default-version 2
}

function Install-Distro {
  Write-Heading "Install Distro"

  if ((Test-CommandDoesExist "${TARGET_DISTRO}.exe")) {
    Write-Heading -Depth 1 "$($TEXT_INFO.ToTitleCase($TARGET_DISTRO)) is already installed $(Write-Emoji "1f389")"
  }
  else {
    if ((Test-CommandDoesExist "choco") -eq $false) {
      Write-Heading -Depth 1 "Installing Chocolately on Windows"
      Set-ExecutionPolicy Bypass -Scope Process -Force; `
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      ;
    }
    else {
      Write-Heading -Depth 1 "Chocolately is already installed $(Write-Emoji "1f389")"
    }

    # Default distro to Ubuntu.
    $Distro = "wsl-ubuntu-2004"

    if (($TARGET_DISTRO) -eq ($TARGET_DISTROS_ENUM.archLinux)) {
      $Distro = "wsl-archlinux"
    }

    Write-Heading -Depth 1 "Installing ${Distro}"
    Invoke-Expression choco install ${Distro} -y
  }

  $TargetBaseDirectory = "$HOME\.wsl"
  Write-Heading -Depth 1 "Instantiating install in '${TargetBaseDirectory}'"
  [void][System.IO.Directory]::CreateDirectory($TargetBaseDirectory)

  Push-Location $TargetBaseDirectory
  & wsl --export $TARGET_DISTRO "${TARGET_DISTRO}.tar"
  & wsl --import $TARGET_INSTANCE .\$TARGET_INSTANCE "${TARGET_DISTRO}.tar" --version 2
  Pop-Location
}

function Install-Packages {
  Write-Heading "Install Packages"
  Write-Heading -Depth 1 "Installing distro packages"
  Write-Heading -Depth 1 "Installing distro-agnostic packages"
}

function Copy-Dotfiles {
  Write-Heading "Copy dotfiles from Windows"
  Write-Heading -Depth 1 "Copying .gitconfig"
  Write-Heading -Depth 1 "Copying .ssh"
  Write-Heading -Depth 1 "Copying .vimrc"
  Write-Heading -Depth 1 "Copying VSCode preferences"
}

function Start-PostHooks {
  Write-Heading "Run Post Hooks"
}

function Show-Done {
  Write-Host -ForegroundColor White -BackgroundColor Black `n"That was pretty sweet $(Write-Emoji "1f9c1")"`n
}

# 🚀
Show-BuildParams
Install-WSL
Install-Distro
Install-Packages
Copy-Dotfiles
Start-PostHooks
Show-Done
