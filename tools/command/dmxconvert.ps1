<#
.SYNOPSIS
Converts between different encoding types of DMX files.

.DESCRIPTION
Converts DMX files between encodings. For example, KeyValues2 to binary.

.PARAMETER Path
Path to the input DMX file to be converted.
.PARAMETER DestinationPath
Path to the output converted DMX file. If this is not specified, the input file is overwritten.
.PARAMETER Recurse
Does a recursive search in the file if it specifies wildcards.
.PARAMETER AutoCheckout
Automatically checks out the DMX from Perforce.

.PARAMETER DestinationEncoding
Destination DMX encoding. Must be one of the following:
keyvalues
keyvalues2
keyvalues2_flat
keyvalues2_noids
binary
binary_seqids
actbusy
commentary
vmt
vmf (Source 1 only)
mks
tex_source1
.PARAMETER DestinationFormat
Destination DMX format. Must be one of the following:
dmx
movieobjects
sfm
sfm_session
sfm_trackgroup
pcf
preset
facial_animation
model
ved
vmks
mp_preprocess
mp_root
mp_model
mp_anim
mp_physics
mp_hitbox
mp_materialgroup
mp_keyvalues
mp_eyes
mp_bonemask
vtex
world
worldnode
virtualvolumetexture
vmap
vanim
animflags
#>
function Convert-DmxFile {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [string]$DestinationPath,
        [switch]$Recurse,
        [switch]$AutoCheckout,

        [Parameter(Mandatory=$True)]
        [string]$DestinationEncoding,
        [Parameter(Mandatory=$True)]
        [string]$DestinationFormat
    )

    $params = Resolve-ParamList @{
        "-i" = $Path;
        #"-if" = $FormatHint;
        "-o" = $DestinationPath;
        "-oe" = $DestinationEncoding;
        "-of" = $DestinationFormat;
        "-r" = $Recurse.IsPresent;
        "-upconvert" = $AutoCheckout.IsPresent;
    }

    Invoke-SourceTool -Tool "dmxconvert" -Parameters $params | Out-Null;
}