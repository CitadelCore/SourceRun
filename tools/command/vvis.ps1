<#
.SYNOPSIS
Embeds visibility data into a BSP.

.DESCRIPTION
Takes compiled BSP maps and embeds visibility data into them. Tests which visleaves can see each other, and which cannot.

.PARAMETER Path
Path to the BSP to be used.
.PARAMETER NumThreads
Control the number of threads Update-BspVisibility uses (defaults to the # of processors on your machine).
.PARAMETER Fast
Only do first quick pass on vis calculations.
.PARAMETER RadiusOverride
Force a vis radius, regardless of whether an env_fog_controller specifies one.
.PARAMETER Trace
Writes a linefile that traces the vis from one cluster to another for debugging map vis.
.PARAMETER NoSort
Don't sort portals (sorting is an optimization).
.PARAMETER TmpIn
Make portals come from \tmp\<mapname>.
.PARAMETER TmpOut
Make portals come from \tmp\<mapname>.
.PARAMETER LowPriority
Run as an idle-priority process.
.PARAMETER FullMinidumps
Write large minidumps on crash.
.PARAMETER Mpi
Use VMPI to distribute computations.
.PARAMETER MpiPassword
Use a password to choose a specific set of VMPI workers.
.PARAMETER Xbox360
Generate Xbox360 version of vsp.
#>

function Update-BspVisibility {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("bsp");
        })]
        [string]$Path,

        # Common options
        [string]$NumThreads,
        [switch]$Fast,
        [string]$RadiusOverride,
        [string[]]$Trace,
        [switch]$NoSort,
        [switch]$TmpIn,
        [switch]$TmpOut,
        [switch]$LowPriority,
        [switch]$FullMinidumps,
        [switch]$Xbox360,
        [switch]$Mpi,
        [securestring]$MpiPassword
    )

    $NoVConfig = $True;

    $params = Resolve-ParamList @{
        "-threads" = $NumThreads;
        "-fast" = $Fast.IsPresent;
        "-verbose" = $Verbose.IsPresent;
        "-radius_override" = $RadiusOverride;
        "-trace" = $Trace;
        "-nosort" = $NoSort.IsPresent;
        "-tmpin" = $TmpIn.IsPresent;
        "-tmpout" = $TmpOut.IsPresent;
        "-low" = $LowPriority.IsPresent;
        "-FullMinidumps" = $FullMinidumps.IsPresent;
        "-x360" = $Xbox360.IsPresent;
        "-mpi" = $Mpi.IsPresent;
        "-mpi_pw" = $MpiPassword;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "vvis.exe" -Parameters $params;
}