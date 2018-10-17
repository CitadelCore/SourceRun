. (Join-Path $PSScriptRoot "Invoke-CacheRebuild.ps1")

# Import all tool scripts from the Tools folder
Get-ChildItem (Join-Path $PSScriptRoot "tools") -Recurse | Where-Object { $_.Name -NotLike "__*" -and $_.Name -Like "*.ps1" } | ForEach-Object { . $_.FullName }