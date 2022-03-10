$ENV:PATH += ";$ENV:USERPROFILE\bin"

$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"


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

Function ucat() {

  Param (
    [String] $Path
  )
  Get-Content -Encoding UTF8 -Path $Path
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

# ================= alias ================== #

Set-Alias vi nvim
Set-Alias gvim nvim-qt

