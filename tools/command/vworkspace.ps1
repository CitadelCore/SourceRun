function Set-VWorkspace {
    param(
        [ValidateScript({
            return Test-FolderValidation -Path $_;
        })]
        [Parameter(ParameterSetName = "Path")]
        [string]$Path,

        [Parameter(ParameterSetName = "Clear")]
        [switch]$Clear
    )

    if ($Clear.IsPresent) {
        Set-Variable -Name "VWorkspace" -Value $null;
        return;
    }

    $configPath = Join-Path -Path $Path -ChildPath "workspace.json";
    if (!(Test-FileValidation -Path $configPath -Extensions @("json"))) {
        throw "Failed to load the workspace.";
    }
    
    Set-Variable -Name "VWorkspace" -Value $Path -Option Constant -Scope Global;
    Write-Output "Workspace definition found at $configPath. Successfully loaded.";
}

function Get-VWorkspace {
    return (Get-Variable -Name "VWorkspace" -Scope Global -ValueOnly);
}