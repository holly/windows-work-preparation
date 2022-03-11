$ENV:PATH += ";$ENV:USERPROFILE\bin"
$ENV:EDITOR = "nvim"

$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"


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

Function gico() {
  Param (
    [String] $Comment
  )
  git commit -m "$Comment"
}


Function giph() {
  git push origin main
}

Function gipl() {
  git pull
}

Function gipl() {
  git pull
}

Function gidf() {
  git diff
}

Function gist() {
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

Function sup() {
  Start-Process -FilePath powershell -ArgumentList $ENV:USERPROFILE\bin\scoop_update.ps1 -Wait
}

Function rmfr() {

    Param(
        [Parameter(Mandatory=$true)][string]$Target
    )
    Remove-Item -Recurse -Force $Target
}

# ================= alias ================== #

Set-Alias vi nvim
Set-Alias qt nvim-qt

# ================= for PSFzf ================== #
# PSFzfの読み込みとAlias有効化
# https://qiita.com/SAITO_Keita/items/f1832b34a9946fc8c716
Import-Module PSFzf
Enable-PsFzfAliases
# ZLocationの読み込み
Import-Module ZLocation
