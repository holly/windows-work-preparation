$CSS     = "$ENV:APPDATA\pandoc\templates\github-pandoc.css"
$DateStr = (Get-Date).ToString("yyyy-MM-ddZHH:mm:sszzz")

$PandocOptions = "-f markdown  -t html5 -s --template template.html --css $CSS --self-contained --toc --metadata=`"date-meta:$DateStr`""
$PandocOptions = $PandocOptions + " -i " + $args[0]

if ($args[1]) {
  $PandocOptions = $PandocOptions + " -o " + $args[1]
}

Write-Output ("pandoc.exe " + $PandocOptions) | Invoke-Expression
