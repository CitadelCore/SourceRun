<#
.SYNOPSIS
Embeds visibility data into a BSP.

.DESCRIPTION
Takes compiled BSP maps and embeds visibility data into them. Tests which visleaves can see each other, and which cannot.

.PARAMETER Path
Path to the BSP to be used.
.PARAMETER Fast
Only do first quick pass on vis calculations.
.PARAMETER Mpi
Use VMPI to distribute computations.
.PARAMETER LowPriority
Run as an idle-priority process.

.PARAMETER RadiusOverride
Force a vis radius, regardless of whether an env_fog_controller specifies one.
.PARAMETER MpiPassword
Use a password to choose a specific set of VMPI workers.
.PARAMETER NumThreads
Control the number of threads Update-BspVisibility uses (defaults to the # of processors on your machine).
.PARAMETER NoSort
Don't sort portals (sorting is an optimization).
.PARAMETER TmpIn
Make portals come from \tmp\<mapname>.
.PARAMETER TmpOut
Make portals come from \tmp\<mapname>.
.PARAMETER Trace
Writes a linefile that traces the vis from one cluster to another for debugging map vis.
.PARAMETER FullMinidumps
Write large minidumps on crash.
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
        [switch]$Fast,
        [switch]$Mpi,
        [switch]$LowPriority,

        # Other options
        [string]$RadiusOverride,
        [securestring]$MpiPassword,
        [string]$NumThreads,
        [switch]$NoSort,
        [switch]$TmpIn,
        [switch]$TmpOut,
        [string[]]$Trace,
        [switch]$FullMinidumps,
        [switch]$Xbox360
    )

    $NoVConfig = $True;

    $params = Resolve-ParamList @{
        "-v" = $Verbose.IsPresent;
        "-fast" = $Fast.IsPresent;
        "-mpi" = $Mpi.IsPresent;
        "-low" = $LowPriority.IsPresent;

        "-novconfig" = $NoVConfig;
        "-radius_override" = $RadiusOverride;
        "-mpi_pw" = $MpiPassword;
        "-threads" = $NumThreads;
        "-nosort" = $NoSort.IsPresent;
        "-tmpin" = $TmpIn.IsPresent;
        "-tmpout" = $TmpOut.IsPresent;
        "-trace" = $Trace;
        "-FullMinidumps" = $FullMinidumps.IsPresent;
        "-x360" = $Xbox360.IsPresent;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "vvis" -Parameters $params;
}