$ErrorActionPreference = "Stop"

$REPO_URL        = "https://raw.githubusercontent.com/holly/windows-work-preparation/main"
$SCOOP_LIST      = "$REPO_URL/scoop.txt"
$PS_START_SCRIPT = "$REPO_URL/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$SCOOP_INSTALLER = "https://get.scoop.sh"
$PLUG_VIM        = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

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
    "$ENV:USERPROFILE\bin"
    )

$NVIM_TEMPLATE_FILES = @("python.txt")
$MY_SCRIPTS          = @("x86_64-w64-mingw32-gcc.ps1", "scoop_update.ps1")
$SHORTCUTS           = @("$ENV:USERPROFILE\scoop\apps\neovim\current\bin\nvim-qt.exe")


Write-Output "=== start ==="

Write-Output "making directories"
$DIRS | ForEach-Object {
    if (Test-Path $PSItem) {
        Write-Output "$PSItem is exists. skip"
    } else {
        New-Item $PSItem -ItemType Directory
    }
}

Write-Output ""
Write-Output "install scoop"
if (Test-Path "$ENV:USERPROFILE\scoop") {
    Write-Output "scoop already installed. skip"
} else {
    # https://scoop.sh/
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString($SCOOP_INSTALLER)
}



Write-Output ""
Write-Output "download powershell start script"
$save_path = "$ENV:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri $PS_START_SCRIPT -OutFile $save_path
Write-Output "save as $save_path"

Write-Output ""
Write-Output "download nvim init.vim"
$save_path = "$ENV:LOCALAPPDATA\nvim\init.vim"
$url       = "$REPO_URL/nvim/init.vim"
Invoke-WebRequest -Uri $url -OutFile $save_path
Write-Output "save as $save_path"

Write-Output ""
Write-Output "download vim-plug"
$save_path = "$ENV:LOCALAPPDATA\nvim-data\site\autoload\plug.vim"
Invoke-WebRequest -Uri $PLUG_VIM -OutFile $save_path
Write-Output "save as $save_path"

Write-Output ""
Write-Output "download vim template"
$NVIM_TEMPLATE_FILES | ForEach-Object {

    $save_path = "$ENV:LOCALAPPDATA\nvim\template\$PSItem"
    $url       = "$REPO_URL/nvim/template/$PSItem"

    Invoke-WebRequest -Uri $url -OutFile $save_path
    Write-Output "save as $save_path"

}

Write-Output ""
Write-Output "download my scripts"
$MY_SCRIPTS | ForEach-Object {

    $save_path = "$ENV:USERPROFILE\bin\$PSItem"
    $url       = "$REPO_URL/bin/$PSItem"

    Invoke-WebRequest -Uri $url -OutFile $save_path
    Write-Output "save as $save_path"

}

Write-Output ""
Write-Output "install scoop apps"
Start-Process -FilePath powershell -ArgumentList $ENV:USERPROFILE\bin\scoop_update.ps1 -Wait

Write-Output ""
Write-Output "create desktop shortcut"
$SHORTCUTS | ForEach-Object {
    $WSShell = New-Object -ComObject WScript.Shell
    $ShortCut = $WSShell.CreateShortcut("$ENV:USERPROFILE\Desktop\" + [System.IO.Path]::GetFileName($PSItem) + ".lnk")
    $ShortCut.TargetPath   = $PSItem
    $ShortCut.IconLocation = $PSItem
    $ShortCut.Save()
}

Write-Output ""
Write-Output "finishd."
