<#
.SYNOPSIS
Compiles all types of Source 2 resources.

.DESCRIPTION
Compiles large numbers of Source 2 resources using a definition file.
.PARAMETER ResourceFile
Path to the Source DMX file list, or resource project file list. Wildcards are accepted.
.PARAMETER ResourceFileList
Specify a text file containing a list of files to be processed as inputs.
.PARAMETER Recurse
If wildcards are specified, recursively searches subdirectories

.PARAMETER Force
Force-compile all encountered resources
.PARAMETER ForceShallow
Force compile top-level resources, but only compile children and sisters as needed
.PARAMETER ForceShallow2
Force compile all top-level resources and their children, but sisters as needed
.PARAMETER Xbox360
Compile resources for Xbox 360
.PARAMETER NoVPK
Generate loose files for the map resource and its children instead of generating a VPK
.PARAMETER IncrementalVpk
Incrementally generate VPK, files already in VPK are left intact unless overwritten
#>

function Invoke-Source2ResourceCompile {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$ResourceFile,
        [string]$ResourceFileList,
        [switch]$Recurse,

        [switch]$Force,
        [switch]$ForceShallow,
        [switch]$ForceShallow2,
        [switch]$Xbox360,
        [switch]$NoVPK,
        [switch]$IncrementalVpk
    )

    $params = Resolve-ParamList @{
        "-i" = $Path;
        "-filelist" = $ResourceFileList;
        "-r" = $Recurse.IsPresent;
        "-v" = $Verbose;
        "-f" = $Force.IsPresent;
        "-fshallow" = $ForceShallow.IsPresent;
        "-fshallow2" = $ForceShallow2.IsPresent;
        "-360" = $Xbox360.IsPresent;
        "-novpk" = $NoVPK.IsPresent;
        "-vpkincr" = $IncrementalVpk.IsPresent;
    }

    Invoke-SourceTool -Tool "resourcecompiler.exe" -Parameters $params;
}