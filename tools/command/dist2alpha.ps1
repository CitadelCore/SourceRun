<#
.SYNOPSIS
Converts distance to alpha.

.DESCRIPTION
Transforms distance information to the alpha layer with width and height parameters.

.PARAMETER Path
Path to the source .tga file.
.PARAMETER DestinationPath
Path to the output transformed .tga file.

.PARAMETER Width
Width, in pixels, of the transform.
.PARAMETER Height
Height, in pixels, of the transform.

.EXAMPLE
C:\PS> Convert-DistanceToAlpha -Path "C:\test\materialsrc\src_bm.tga" -DestinationPath "C:\test\materials\dest_bm.tga" -Width 512 -Height 512

#>
function Convert-DistanceToAlpha {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("tga");})]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [string]$DestinationPath,

        [Parameter(Mandatory=$True)]
        [string]$Width,
        [Parameter(Mandatory=$True)]
        [string]$Height,
    )

    $params = "`"$Path`" `"$DestinationPath`" $Width $Height";
    Invoke-SourceTool -Tool "dist2alpha" -Parameters $params | Out-Null;
}