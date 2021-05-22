#Requires -RunAsAdministrator
Set-StrictMode -Version 3

# Welcome to Windows. The OS where the DX is 💩 and the encoding doesn't matter.
function Write-Emoji {
  param (
    [Parameter(Position = 0, Mandatory = $true)] [string] $Emoji
  )

  $Unicode = "u+${Emoji}" -replace 'U\+', ''
  [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

Write-Host `
  "[" -ForegroundColor DarkGray -BackgroundColor Black -NoNewline; `
  Write-Host "$(Write-Emoji "1F427") WSL DX Scripts $(Write-Emoji "1F427")" -ForegroundColor White -BackgroundColor Black -NoNewline; `
  Write-Host "]" -ForegroundColor DarkGray -BackgroundColor Black `n
;

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

  if ((Test-CommandDoesExist "ubuntu")) {
    Write-Heading -Depth 1 "Ubuntu is already installed $(Write-Emoji "1f389")"

    return
  }

  if ((Test-CommandDoesExist "choco") -eq $false) {
    Write-Heading -Depth 1 "Installing Chocolately on Windows Host"
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ;
  }
  else {
    Write-Heading -Depth 1 "Chocolately is already installed $(Write-Emoji "1f389")"
  }

  $Distro = "wsl-ubuntu-2004"

  if ((Test-ChocoPackageExists "${Distro}") -eq $false) {
    Write-Heading -Depth 1 "Installing ${Distro}"
    Invoke-Expression choco install ${Distro} -y
  }
  # Add-AppxPackage -Path "http://tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/7737ff0f-9d2c-4bf3-85a9-ae06cde4776b?P1=1621725193&P2=404&P3=2&P4=BOtk7nczjjgCj987sLsH9TB%2b6wpYONIflFjVF4qR4pCVdsH2gGFfswLfphel6UT7ZAXioz3XyzfjGsIVLRGRCg%3d%3d"
  # Invoke-Expression winget install Ubuntu --force
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
Install-WSL
Install-Distro
Install-Packages
Copy-Dotfiles
Start-PostHooks
Show-Done
