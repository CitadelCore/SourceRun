<#
.SYNOPSIS
Converts heightmaps to SSBump textures.

.DESCRIPTION
Converts heightmap files to special SSBump textures.
.PARAMETER Path
Path to the input heightmap TGA.
.PARAMETER BumpScale
Ratio to scale the bump map by.

.PARAMETER Rays
Sets the number of rays. Default is 250. More rays take more time.
.PARAMETER Normal
Generates a conventional normal map.
.PARAMETER AoAlpha
Generates ambient occlusion in the alpha channel.
.PARAMETER FilterRadius
Sets the smoothing filter radius. Default is 10. 0 is no filter.
.PARAMETER FilterWrite
Writes out the filtered results to filterd.tga.

.EXAMPLE
C:\PS> Convert-HeightToSSBump -Path "C:\test\materialsrc\heightmap.tga" -BumpScale 1.0

#>
function Convert-HeightToSSBump {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("tga");})]
        [string]$Path,
        [string]$BumpScale,

        [string]$Rays,
        [switch]$Normal,
        [switch]$AoAlpha,
        [string]$FilterRadius,
        [switch]$FilterWrite
    )

    $params = Resolve-ParamList @{
        "-r" = $Rays;
        "-n" = $Normal.IsPresent;
        "-A" = $AoAlpha.IsPresent;
        "-f" = $FilterRadius;
        "-D" = $FilterWrite.IsPresent;
    }

    $params = "$params $Path $BumpScale"
    Invoke-SourceTool -Tool "height2ssbump" -Parameters $params | Out-Null;
}