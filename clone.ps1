Set-StrictMode -Version 3

# https://kpatnayakuni.com/2019/01/04/just-a-tip-4-download-a-zip-file-from-the-internet-and-extract-using-powershell/

$Url = "https://github.com/nerdyman/wsl-dx-scripts/archive/refs/heads/main.zip"
$OutFile = "${env:TEMP}\wsl-dx-zip" + $(Split-Path -Path $Url -Leaf)
$Destination = "${env:TEMP}\wsl-dx-scripts"

Invoke-WebRequest -Uri $Url -OutFile $OutFile

$ExtractShell = New-Object -ComObject Shell.Application
$Files = $ExtractShell.Namespace($OutFile).Items()
$ExtractShell.NameSpace($Destination).CopyHere($Files)
& "${Destination}\run.ps1"
