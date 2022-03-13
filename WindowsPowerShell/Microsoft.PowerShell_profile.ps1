$ENV:PATH += ";$ENV:USERPROFILE\bin"
$ENV:EDITOR = "nvim"

$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"
$TERMINAL_SETTINGS = "$ENV:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$TERMINAL_WALLPAPER_DIR = "$ENV:USERPROFILE\wallpaper"


# ターミナルの文字コードをUTF-8に変更
$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

# ================= function ================== #

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

Function uptime() {
  [DateTime]::Now -  [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem).LastBootUpTime) |
  Select-Object Days, Hours, Seconds, Milliseconds| Format-Table -AutoSize
}

Function home() {
  Set-Location $ENV:USERPROFILE
}

Function gco() {
  Param (
    [String] $Comment
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
        [Parameter(Mandatory=$true)][string]$Target
    )
    Remove-Item -Recurse -Force $Target
}

Function Invoke-ScoopUpdate() {
  #Start-Process -FilePath powershell -ArgumentList $ENV:USERPROFILE\bin\scoop_update.ps1 -Wait
  scoop_update.ps1
}

# ================= alias ================== #

Set-Alias vi nvim
Set-Alias qt nvim-qt
Set-Alias isu Invoke-ScoopUpdate

# ================= for PSFzf ================== #
# PSFzfの読み込みとAlias有効化
# https://qiita.com/SAITO_Keita/items/f1832b34a9946fc8c716
Import-Module PSFzf
Enable-PsFzfAliases
# ZLocationの読み込み
Import-Module ZLocation
