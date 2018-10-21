<#
.SYNOPSIS
Converts between different encoding types of DMX files.

.DESCRIPTION
Converts DMX files between encodings. For example, KeyValues2 to binary.

.PARAMETER Path
Path to the input DMX file to be converted.
.PARAMETER DestinationPath
Path to the output converted DMX file. If this is not specified, the input file is overwritten.

.PARAMETER DestinationEncoding
Destination DMX encoding. Must be one of the following:
KeyValues
KeyValues2
KeyValues2-Flat
Binary
ActBusy
Vmt
Vmf
.PARAMETER DestinationFormat
Destination DMX format. Must be one of the following:
Dmx
MovieObjects
Sfm
SfmSession
SfmTrackGroup
Pcf
Preset
FacialAnimation
Model

#>
function Convert-DmxFile {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [string]$DestinationPath,

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
    }

    Invoke-SourceTool -Tool "dmxconvert" -Parameters $params | Out-Null;
}