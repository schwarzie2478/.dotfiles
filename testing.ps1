git show 396a:vscode/extensions.json > previous.json
$previous = get-content .\previous.json | ConvertFrom-Json
$current  = get-content .\vscode\extensions\extensions.json | ConvertFrom-Json

$missingElements = Compare-Object $current $previous | Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty InputObject

# Output the missing elements
$missingElements