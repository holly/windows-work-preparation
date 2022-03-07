Write-Output ""
Write-Output "install or update scoop apps"
$res = Invoke-WebRequest "https://raw.githubusercontent.com/holly/windows-work-preparation/main/scoop.txt"
$body = $res.Content
$body.Split("`n") | ForEach-Object {
    $app = $PSItem.trim()
    if ($app.Length -ne 0) {
        scoop install $app
    }
}