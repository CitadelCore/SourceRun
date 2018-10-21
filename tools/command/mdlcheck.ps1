<#
.SYNOPSIS
Checks consistency of models.

.DESCRIPTION
Checks consistency of compiled models against their respective source.

.PARAMETER Path
Path to the model source directory.
.PARAMETER CompiledPath
Path to the compiled model directory. Folder structure must match that of the source directory.

.PARAMETER AnimationCheck
Checks models for large animation data.

.EXAMPLE
C:\PS> Compare-ModelSource -Path "C:\test\modelsrc" -CompiledPath "C:\test\models"

#>
function Compare-ModelSource {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FolderValidation -Path $_;})]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FolderValidation -Path $_;})]
        [string]$CompiledPath,

        [switch]$Log,
        [switch]$AnimationCheck
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log.IsPresent;
        "-a" = $AnimationCheck.IsPresent;
    }

    $params = "$params $Path $CompiledPath"
    Invoke-SourceTool -Tool "mdlcheck" -Parameters $params | Out-Null;
}