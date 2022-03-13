# ================= environ variables ================== #
$ENV:PATH += ";$ENV:USERPROFILE\bin"
$ENV:EDITOR = "nvim"
$ENV:TERMINAL_WALLPAPER_DIR = "$ENV:USERPROFILE\wallpaper"

# ================= terminal variables ================== #
# ターミナルの文字コードをUTF-8に変更
$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

# nvim設定ファイル
$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"

# ================= terminal function ================== #

function prompt () {
    $prompt = if (-not(([Security.Principal.WindowsPrincipal] `
                    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                    [Security.Principal.WindowsBuiltInRole] "Administrator"`
            ))) {
        " > "
    }else{
        " # "
    }
    "[$($env:USERNAME)@$($env:COMPUTERNAME) " + (Split-Path (Get-Location) -Leaf) + "]${prompt}"
}

# ================= basic function ================== #

Function uptime() {
  [DateTime]::Now -  [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem).LastBootUpTime) |
  Select-Object Days, Hours, Seconds, Milliseconds| Format-Table -AutoSize
}

Function home() {
  Set-Location $ENV:USERPROFILE
}

Function gco() {
  Param (
    [String]$Comment
  )
  git commit -m "$Comment"
}


Function gph() {
  git push origin main
}

Function gpl() {
  git pull
}

Function gdf() {
  git diff
}

Function gst() {
  git status
}

Function catu() {

  Param (
    [Parameter(Mandatory=$true)][String]$Target
  )
  Get-Content -Encoding UTF8 -Path $Target
}

del alias:ls  # PowerShell 側の ls を削除
Function ls() {
  ls.exe --color=auto $args
}
Function ll() {
  ls.exe --color=auto -l $args
}
Function la() {
  ls.exe --color=auto -la $args
}

Function rmfr() {

  Param(
    [Parameter(Mandatory=$true)][String]$Target
  )
  Remove-Item -Recurse -Force $Target
}

Function vimrc() {
  nvim-qt $MYVIMRC
}

# ================= custom function ================== #
Function Get-TerminalBackgroundImage() {
  python $ENV:USERPROFILE\bin\term_background_image.py get | ConvertFROM-JSON
}

Function Set-TerminalBackgroundImage() {

  Param(
    [String]$BackgroundImage,
    [Float]$BackgroundImageOpacity,
    [Switch]$Save
  )

  $argments = ""
  if (-Not([string]::IsNullOrEmpty($BackgroundImage))) {
    $argments = $Args + "--background-image=$BackgroundImage"
  }
  if ($BackgroundImageOpacity -ne 0) {
    $argments = $argments + " --background-image-opacity=$BackgroundImageOpacity"
  }
  if ($Save) {
    $argments = $argments + " --save-terminal-setting-json"
  }

  $cmd = "python $ENV:USERPROFILE\bin\term_background_image.py set $argments"
  Invoke-Expression $cmd
}

Function Invoke-ScoopUpdate() {
  #Start-Process -FilePath powershell -ArgumentList $ENV:USERPROFILE\bin\scoop_update.ps1 -Wait
  scoop_update.ps1
}

# ================= alias ================== #

Set-Alias vi nvim
Set-Alias qt nvim-qt
Set-Alias isu Invoke-ScoopUpdate
Set-Alias gbi Get-TerminalBackgroundImage
Set-Alias sbi Set-TerminalBackgroundImage

# ================= for PSFzf ================== #
# PSFzfの読み込みとAlias有効化
# https://qiita.com/SAITO_Keita/items/f1832b34a9946fc8c716
Import-Module PSFzf
Enable-PsFzfAliases
# ZLocationの読み込み
Import-Module ZLocation

