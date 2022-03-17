# ================= environ variables ================== #
$ENV:PATH += ";$ENV:USERPROFILE\bin"
$ENV:EDITOR = "nvim-qt"
$ENV:TERMINAL_WALLPAPER_DIR = "$ENV:USERPROFILE\wallpaper"

# ================= terminal variables ================== #
# ターミナルの文字コードをUTF-8に変更
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

# nvim設定ファイル
$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"
# pandoc datadir
$PANDOC_DATADIR = "$ENV:APPDATA\pandoc"
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

Function catu() {

  Param (
    [Parameter(Mandatory=$true)][String]$Target
  )
  Get-Content -Encoding UTF8 -Path $Target
}

try {
    Remove-Item alias:ls
    Function ls() {
      ls.exe --color=auto $args
    }
} catch {
    Write-Output "(skip) $_.Exception_Message"
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
Function Convert-Markdown2HTML() {

  Param(
    [Parameter(mandatory=$true)][String]$InputFile,
    [String]$OutputFile,
    [Switch]$Browse
  )

  if (-Not(Test-Path $InputFile)) {
    throw "$InputFile is not exists."
  }

  md2html $InputFile $OutputFile

  if ($Browse) {
    chrome --new-window $OutputFile
  }
}

Function Get-TerminalBackgroundImage() {
  python $ENV:USERPROFILE\bin\term_background_image.py get | ConvertFROM-JSON
}

Function Set-TerminalBackgroundImage() {

  Param(
    [String]$BackgroundImage,
    [Float]$BackgroundImageOpacity,
    [Switch]$Save
  )

  $arguments = ""
  if (-Not([string]::IsNullOrEmpty($BackgroundImage))) {
    $arguments = $Args + "--background-image=$BackgroundImage"
  }
  if ($BackgroundImageOpacity -ne 0) {
    $arguments = $arguments + " --background-image-opacity=$BackgroundImageOpacity"
  }
  if ($Save) {
    $arguments = $arguments + " --save-terminal-setting-json"
  }

  $cmd = "python $ENV:USERPROFILE\bin\term_background_image.py set $arguments"
  Invoke-Expression $cmd
}

Function Invoke-Explorer() {

  Param(
    [String]$Target
  )

  if ([string]::IsNullOrEmpty($Target)) {
    $Target = $PWD
  }
  explorer.exe $Target
}

Function Invoke-ScoopUpdate() {
  #Start-Process -FilePath powershell -ArgumentList $ENV:USERPROFILE\bin\scoop_update.ps1 -Wait
  scoop_update.ps1
}

Function Update-MyEnv() {
  (Invoke-WebRequest -Uri https://raw.githubusercontent.com/holly/windows-work-preparation/main/install.ps1).Content | Invoke-Expression
}

# ================= alias ================== #

Set-Alias ex Invoke-Explorer
Set-Alias vi nvim
Set-Alias qt nvim-qt
Set-Alias isu Invoke-ScoopUpdate
Set-Alias gbi Get-TerminalBackgroundImage
Set-Alias sbi Set-TerminalBackgroundImage
Set-Alias chrome "$ENV:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
Set-Alias edge "$ENV:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe"

try {
  Remove-Item alias:curl
  Set-Alias curl "$ENV:USERPROFILE\scoop\apps\gow\current\bin\curl.exe"
} catch {
  Write-Output "(skip) $_.Exception_Message"
}

# ================= for PSFzf ================== #
# PSFzfの読み込みとAlias有効化
# https://qiita.com/SAITO_Keita/items/f1832b34a9946fc8c716
Import-Module PSFzf
Enable-PsFzfAliases
# ZLocationの読み込み
Import-Module ZLocation

