<#
.SYNOPSIS
Extracts information from BSPs.

.DESCRIPTION
Extracts information from BSPs, such as trees, textures, models, props, lumps, and more.

.PARAMETER Path
Path to the BSP to be used.

.PARAMETER TreeInfo
Shows SpeedTree information.

.PARAMETER DrawTree
Draws SpeedTree information. Currently broken.

.PARAMETER WorldTextureStats
Shows world texture statistics.

.PARAMETER ModelStats
Shows model statistics.

.PARAMETER ListStaticProps
Shows static props.

.PARAMETER ExtractLump
Extracts BSP lump to file. i.e -Lump 0 extracts entity lump.

.PARAMETER ShowBounds
Shows .bsp worldmodel bounds.
#>

function Get-BSP {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("bsp");
        })]
        [string]$Path,

        [switch]$TreeInfo,
        [switch]$DrawTree,
        [switch]$WorldTextureStats,
        [switch]$ModelStats,
        [switch]$ListStaticProps,
        [string]$ExtractLump,
        [switch]$ShowBounds
    )

    $params = Resolve-ParamList @{
        "-treeinfo" = $TreeInfo.IsPresent;
        "-drawtree" = $DrawTree.IsPresent;
        "-worldtexturestats" = $WorldTextureStats.IsPresent;
        "-modelstats" = $ModelStats.IsPresent;
        "-liststaticprops" = $ListStaticProps.IsPresent;
        "-size" = $ShowBounds.IsPresent;
    }

    if ($ExtractLump -ne "") {
        $params = "$params -X$ExtractLump ";
    }

    $params = $params + "`"$Path`"";
    Invoke-SourceTool -Tool "vbspinfo" -Parameters $params;
}