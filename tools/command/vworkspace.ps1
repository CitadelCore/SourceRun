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
        Remove-Variable -Name "VWorkspace" -Scope Global -Force -ErrorAction SilentlyContinue;
        return;
    }

    $configPath = Join-Path -Path $Path -ChildPath "workspace.json";
    if (!(Test-FileValidation -Path $configPath -Extensions @("json"))) {
        throw "Failed to load the workspace.";
    }
    
    Set-Variable -Name "VWorkspace" -Value $Path -Scope Global -Force;
    Write-Output "Workspace definition found at $configPath. Successfully loaded.";
}

function Get-VWorkspace {
    return (Get-Variable -Name "VWorkspace" -Scope Global -ValueOnly);
}

function Set-VToolOverride {
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
        Remove-Variable -Name "VToolOverride" -Scope Global -Force -ErrorAction SilentlyContinue;
        return;
    }

    Set-Variable -Name "VToolOverride" -Value $Path -Scope Global -Force;
}

function Get-VToolOverride {
    return (Get-Variable -Name "VToolOverride" -Scope Global -ValueOnly -ErrorAction SilentlyContinue);
}