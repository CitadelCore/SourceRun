<#
.SYNOPSIS
Performs various analysis on BSPs.

.DESCRIPTION
Performs various analysis on BSPs, can dump information, generate a GLView file and extract lumps.

.PARAMETER Path
Path to the BSP to be analyzed.

.PARAMETER Info
Dumps information about the BSP file to a series of files named filename_*.csv/txt.

.PARAMETER GLView
Emits a glview file (.gl) with the same name.

.PARAMETER ExtractLump
Emits the given lump to a file named filename_<index>.bin.
#>

function Measure-BSP {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("bsp");
        })]
        [string]$Path,

        [switch]$Info,
        [switch]$GLView,
        [string]$ExtractLump
    )

    $params = Resolve-ParamList @{
        "-info" = $Info.IsPresent;
        "-gl" = $GLView.IsPresent;
        "-lump" = $ExtractLump;
    }

    $params = $params + "`"$Path`"";
    Invoke-SourceTool -Tool "vbsp2" -Parameters $params;
}