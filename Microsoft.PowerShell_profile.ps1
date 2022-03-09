$ENV:PATH += ";$ENV:USERPROFILE\bin"

$MYVIMRC = "$ENV:LOCALAPPDATA\nvim\init.vim"


# ================= function ================== #

Function prompt() {

  $date = Get-Date -Format "HH:mm:ss"  # 日付
  $path = Split-Path -Path $pwd -Leaf  # カレントディレクトリ

  Write-Host $date -NoNewline
  Write-Host " "   -NoNewline
  Write-Host $path -NoNewline
  Write-Host " $"  -NoNewline
  return " "
}

Function uptime() {
  [DateTime]::Now -  [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem).LastBootUpTime) |
  Select-Object Days, Hours, Seconds, Milliseconds| Format-Table -AutoSize
}

Function home() {
  Set-Location $ENV:USERPROFILE
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

# ================= alias ================== #

Set-Alias vi nvim
