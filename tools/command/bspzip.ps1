<#
.SYNOPSIS
Embeds files into a BSP compiled map.

.DESCRIPTION
Embeds arbitrary files into a BSP using the Source tool bspzip.

.PARAMETER Path
Path to the BSP to embed the file(s) into.

.PARAMETER AddFile
Specifies the external path of a single file you want to add to the BSP.
.PARAMETER InnerPath
Specifies the internal path of a single file you want to add to the BSP. Must be used with -AddFile.

.PARAMETER AddList
Specifies the path to a list .txt file containing internal and external file paths for bulk addition.
.PARAMETER AllowUpdate
Allows the files specified in the list .txt to update/overwrite existing files in the BSP. Must be used with -AddList.

.PARAMETER Repack
Repacks the BSP which removes any compression unless -Compress is specified.
.PARAMETER Compress
Compresses the BSP. Must be used with -Repack.

.EXAMPLE
C:\PS> Add-BspFile -Path "test.bsp" -DestinationPath "packed.bsp" -AddFile "materials\test.vtf"
.EXAMPLE
C:\PS> Add-BspFile -Path "test.bsp" -DestinationPath "packed.bsp" -AddFile "C:\test.vtf" -InnerPath "materials\test.vtf"
.EXAMPLE
C:\PS> Add-BspFile -Path "test.bsp" -DestinationPath "packed.bsp" -AddList "C:\list.txt" -AllowUpdate
.EXAMPLE
C:\PS> Add-BspFile -Path "test.bsp" -Repack -Compress

#>
function Add-BspFile {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("bsp");})]
        [string]$Path,
        [string]$DestinationPath,

        [Parameter(ParameterSetName='addFile', Mandatory=$True)]
        [string]$AddFile,
        [Parameter(ParameterSetName='addFile', Mandatory=$True)]
        [string]$InnerPath,

        [Parameter(ParameterSetName='addList', Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("txt");})]
        [string]$AddList,
        [Parameter(ParameterSetName='addList')]
        [switch]$AllowUpdate,

        [Parameter(ParameterSetName='repack', Mandatory=$True)]
        [switch]$Repack,
        [Parameter(ParameterSetName='repack')]
        [switch]$Compress
    )

    if ($DestinationPath -eq "") {
        $DestinationPath = $Path;
    }

    if ($AddFile -ne "") {
        $params = "-addfile `"$Path`" `"$AddFile`" `"$InnerPath`" `"$DestinationPath`"";
    }

    if ($AllowUpdate -ne "") {
        $params = "-addorupdatelist `"$Path`" `"$AddList`" `"$DestinationPath`"";
    } elseif ($AddList -ne "") {
        $params = "-addlist `"$Path`" `"$AddList`" `"$DestinationPath`"";
    }

    if ($Repack.IsPresent) {
        $params = "-repack `"$Path`"";
    }
    if ($Compress.IsPresent) {
        $params = "-repack -compress `"$Path`"";
    }

    Invoke-SourceTool -Tool "bspzip" -Parameters $params;
}

<#
.SYNOPSIS
Extracts files from a BSP map.

.DESCRIPTION
Extracts and lists files in BSP maps.

.PARAMETER Path
Path to the BSP to extract data from.

.PARAMETER ExtractZip
Extracts the embedded data in the BSP to the specified .zip archive.
.PARAMETER ExtractFiles
Extracts the embedded data in the BSP to the folder where it resides, respecting the internal folder structure.
.PARAMETER ListFiles
Produces a list of all files embedded in the BSP.

#>
function Get-BspFile {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("bsp");})]
        [string]$Path,
        [Parameter(ParameterSetName='extractZip')]
        [string]$ExtractZip,
        [Parameter(ParameterSetName='extractFiles')]
        [switch]$ExtractFiles,
        [Parameter(ParameterSetName='listFiles')]
        [switch]$ListFiles
    )

    if ($ExtractZip -ne "") {
        $params = "-extract `"$Path`" `"$ExtractZip`"";
    }

    if ($ExtractFiles -ne "") {
        $params = "-extractfiles `"$Path`" `"$ExtractZip`"";
    }

    if ($ExtractZip -ne "") {
        $params = "-dir `"$Path`"";
    }

    Invoke-SourceTool -Tool "bspzip" -Parameters $params;
}

<#
.SYNOPSIS
Extracts cubemaps from a BSP map.

.DESCRIPTION
Extracts cubemap textures from BSP maps.

.PARAMETER Path
Path to the BSP to extract data from.
.PARAMETER DestinationFolder
Path to the folder to extract the cubemap textures to.

#>
function Get-BspCubeMaps {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("bsp");})]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [string]$DestinationFolder
    )

    Invoke-SourceTool -Tool "bspzip" -Parameters "-extractcubemaps `"$Path`" `"$DestinationFolder`"";
}

<#
.SYNOPSIS
Removes cubemaps from a BSP map.

.DESCRIPTION
Removes cubemap textures from BSP maps. Warning: this strips all VTF files in the BSP, not just cubemaps.

.PARAMETER Path
Path to the BSP to remove cubemaps from.

#>
function Clear-BspCubeMaps {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("bsp");})]
        [string]$Path
    )

    Invoke-SourceTool -Tool "bspzip" -Parameters "-deletecubemaps `"$Path`"";
}