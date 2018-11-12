<#
.SYNOPSIS
Copies Source 2 resources.

.DESCRIPTION
Copies Source 2 resources from a source directory to a destination directory.
.PARAMETER Path
Source filename or folder + wildcard.
.PARAMETER Destination
Destination filename or folder.

.PARAMETER Shallow
Don't recurse for wildcards.
.PARAMETER ErrorLog
Write a log of any errors to the specified file.
.PARAMETER FullLog
Write a full log to the specified file.
.PARAMETER SkipSubString
Skip files whose full path contains this substring. (Can be repeated.)
#>

function Copy-Source2Resource {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [string]$Destination,

        [switch]$Shallow,
        [string]$ErrorLog,
        [string]$FullLog,
        [string]$SkipSubString
    )

    $params = Resolve-ParamList @{
        "-shallow" = $Shallow.IsPresent;
        "-errlog" = $ErrorLog;
        "-fulllog" = $FullLog;
        "-skip" = $SkipSubString;
    }

    $params = "$Path $Destination $params";

    Invoke-SourceTool -Tool "resourcecopy.exe" -Parameters $params;
}