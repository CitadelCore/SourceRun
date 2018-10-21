<#
.SYNOPSIS
Converts heightmaps to normals.

.DESCRIPTION
Converts heightmap files to normal files.
.PARAMETER Path
Path to the texture normal.

.EXAMPLE
C:\PS> Convert-HeightToNormal -Path "C:\test\tex1_normal.txt"

#>
function Convert-HeightToNormal {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("txt");})]
        [string]$Path,
    )

    $params = Resolve-ParamList @{
        "-quiet" = $True;
    }

    $params = "$params $Path"
    Invoke-SourceTool -Tool "height2normal" -Parameters $params | Out-Null;
}