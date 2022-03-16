$ErrorActionPreference = "Stop"

$REPO_URL            = "https://github.com/holly/windows-work-preparation.git"
$REPO_RAW_URL        = "https://raw.githubusercontent.com/holly/windows-work-preparation/main"
$SCOOP_LIST_URL      = "$REPO_RAW_URL/scoop.txt"
$SCOOP_INSTALLER_URL = "https://get.scoop.sh"
$PLUG_VIM_URL        = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

$DIRS = @(
    "$ENV:USERPROFILE\Documents\WindowsPowerShell",
    "$ENV:LOCALAPPDATA\nvim",
    "$ENV:LOCALAPPDATA\nvim-data",
    "$ENV:LOCALAPPDATA\nvim-data\site",
    "$ENV:LOCALAPPDATA\nvim-data\site\autoload",
    "$ENV:LOCALAPPDATA\nvim-data\plugged",
    "$ENV:LOCALAPPDATA\nvim\template",
    "$ENV:LOCALAPPDATA\nvim\pack",
    "$ENV:LOCALAPPDATA\nvim\pack\vack",
    "$ENV:LOCALAPPDATA\nvim\pack\vack\after",
    "$ENV:LOCALAPPDATA\nvim\pack\vack\opt",
    "$ENV:LOCALAPPDATA\nvim\pack\vack\start",
    "$ENV:USERPROFILE\bin",
    "$ENV:APPDATA\pandoc",
    "$ENV:APPDATA\pandoc\templates"

    )


$SHORTCUTS  = @("$ENV:USERPROFILE\scoop\apps\neovim\current\bin\nvim-qt.exe")

$StartDate = Get-Date

Write-Output "===== Start windows work prepation ====="

Write-Output ">> Make directories"
$DIRS | ForEach-Object {
    if (Test-Path $PSItem) {
        Write-Output "$PSItem is exists. skip"
    } else {
        New-Item $PSItem -ItemType Directory
    }
}


Write-Output ""
Write-Output ">> Install scoop"
try {
  # scoopのインストール確認
  Get-Command scoop -ErrorAction Stop
} 
catch [Exception] {
  # Scoopのインストール
  Set-ExecutionPolicy RemoteSigned -scope CurrentUser
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString($SCOOP_INSTALLER_URL)
}


Write-Output ""
Write-Output ">> Install scoop apps"
$Res = Invoke-WebRequest $SCOOP_LIST_URL
$Body = $Res.Content
$Body.Split("`n") | ForEach-Object {
    $app = $PSItem.trim()
    if ($app.Length -ne 0) {
        scoop install $app
    }
}


Write-Output ""
Write-Output ">> Download windows-work-preparation repository"
$LocalRepo = "$ENV:TEMP\windows-work-preparation"
Push-Location "$ENV:TEMP"
if (Test-Path $LocalRepo) {
  Remove-Item -Path $LocalRepo -Force -Recurse
}
echo "git clone $REPO_URL"
Start-Process -FilePath git -ArgumentList "clone $REPO_URL" -Wait
Pop-Location


Write-Output ""
Write-Output ">> Set powershell start script"
$Src = "$LocalRepo\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$Dest = $PROFILE
Copy-Item -Path $Src -Destination $Dest
Write-Output "Save as $Dest"


Write-Output ""
Write-Output ">> Save nvim init.vim"
$Src  = "$LocalRepo\nvim\init.vim"
$Dest = "$ENV:LOCALAPPDATA\nvim\init.vim"
Copy-Item -Path $Src -Destination $Dest
Write-Output "Save as $Dest"

Write-Output ""
Write-Output ">> Download vim-plug"
$Dest = "$ENV:LOCALAPPDATA\nvim-data\site\autoload\plug.vim"
Invoke-WebRequest -Uri $PLUG_VIM_URL -OutFile $Dest
Write-Output "Save as $Dest"

Write-Output ""
Write-Output ">> Save vim template"
Get-ChildItem -Path "$LocalRepo\nvim\template" -File | ForEach-Object {
  $Src  = $PSItem.FullName
  $Dest = "$ENV:LOCALAPPDATA\nvim\template\" + $PSItem.Name
  Copy-Item -Path $Src -Destination $Dest
  Write-Output "Save as $Dest"
}


Write-Output ""
Write-Output ">> Save my scripts"
Get-ChildItem -Path "$LocalRepo\bin" -File | ForEach-Object {
  $Src  = $PSItem.FullName
  $Dest = "$ENV:USERPROFILE\bin\" + $PSItem.Name
  Copy-Item -Path $Src -Destination $Dest
  Write-Output "Save as $Dest"
}


Write-Output ""
Write-Output ">> Set pandoc templates"
Get-ChildItem -Path "$LocalRepo\pandoc\templates" -File | ForEach-Object {
  $Src  = $PSItem.FullName
  $Dest = "$ENV:APPDATA\pandoc\templates\" + $PSItem.Name
  Copy-Item -Path $Src -Destination $Dest
  Write-Output "Save as $Dest"
}



Write-Output ""
Write-Output ">> Make desktop shortcut"
$SHORTCUTS | ForEach-Object {

	$Dest = "$ENV:USERPROFILE\Desktop\" + [System.IO.Path]::GetFileName($PSItem) + ".lnk"

    $WSShell = New-Object -ComObject WScript.Shell
    $ShortCut = $WSShell.CreateShortcut($Dest)
    $ShortCut.TargetPath   = $PSItem
    $ShortCut.IconLocation = $PSItem
    $ShortCut.Save()
	
    Write-Output "Shortcut as $Dest"
}

Write-Output ""
Write-Output ">> Install 3rd party modules"
Install-Module -Name PSFzf -scope currentUser -Force
Install-Module -Name ZLocation -scope currentUser -Force
# PSFzfの読み込みとAlias有効化
Import-Module PSFzf
Enable-PsFzfAliases
# ZLocationの読み込み
Import-Module ZLocation
# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Write-Output ""
Write-Output ">> Set git config"
git config --global core.autocrlf false
git config --global core.editor nvim
$res = (git config --global user.name)
if ([String]::IsNullOrEmpty($res)) {
	git config --global user.name $ENV:USERNAME
}
git config --global core.autocrlf
git config --global core.editor
git config --global user.name



$EndDate = Get-Date
$Elapced = ($EndDate - $StartDate).TotalSeconds 
$LastMessage = "finished. (" + $Elapced + "sec)"


Write-Output ""
Write-Output $LastMessage

