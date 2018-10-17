. (Join-Path $PSScriptRoot "shared.ps1")
function Invoke-CacheRebuild {
    $branches = Get-JsonFile "$PSScriptRoot/branches.json";
    $config = Get-JsonFile "$PSScriptRoot/config.json";
}