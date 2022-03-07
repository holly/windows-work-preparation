$ENV:PATH += ";$ENV:USERPROFILE\bin"

Set-Alias vi nvim

$myvimrc = "$ENV:LOCALAPPDATA\nvim\init.vim"

Function uptime() {
  [DateTime]::Now -  [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem).LastBootUpTime) |
  Select-Object Days, Hours, Seconds, Milliseconds| Format-Table -AutoSize
}

Function home() {
  Set-Location $ENV:USERPROFILE
}

Function gitps() {
  git push origin main
}

Function gitpl() {
  git pull
}
