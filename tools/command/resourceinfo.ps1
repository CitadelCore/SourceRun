<#
.SYNOPSIS
Gets information for Source 2 resources.

.DESCRIPTION
Retrieves resource data from Source 2 resource files.
.PARAMETER ResourceFile
Resource file or VPK names; can specify more than one file name.
.PARAMETER Recurse
Recursively search directories for files.

.PARAMETER All
Prints the content of each resource block in the file.
.PARAMETER Block
Print the content of a specific block.
Specify the block via its 4CC name - case matters!
(eg. DATA, RERL, REDI, NTRO).
.PARAMETER BlockRaw
Block data is printed as raw bytes (hex dump).


.PARAMETER Find
Finds a resource those resource ID matches the specified one.
.PARAMETER Diff
Compare two files (use -ResourceFile to specify exactly two files)
.PARAMETER ListDependencies
If compile is specified, lists all compile-time dependencies.
If runtime is specified, lists all run-time dependencies.
If neither is specified, both are listed.
.PARAMETER ListModuleDependencies
Lists all resources the specified module (DLL) depends on.
.PARAMETER ListEngineDependencies
Lists all resources the game/engine depends on by collating the results of -module_dep for all DLLs. 
(Respects -Verbose and -Quiet)
.PARAMETER DebugConvert
Converts a resource into a separate file into the
specified format. If no debug format is specified,
a list of supported ones for that file is output.
.PARAMETER MipMaps
Will output all mips of a vtex_c into separate rgba textures
.PARAMETER FullMipMaps
Will output a single rgb image of all mips of a vtex_c showing alpha next to the mip chain

.PARAMETER Quiet
Quiet mode
#>

function Get-Source2Resource {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$ResourceFile,
        [switch]$Recurse,

        [switch]$All,
        [string]$Block,
        [switch]$BlockRaw,

        [switch]$Find,
        [switch]$Diff,
        [string]$ListDependencies,
        [string]$ListModuleDependencies,
        [switch]$ListEngineDependencies,

        [string]$DebugConvert,
        [switch]$MipMaps,
        [switch]$FullMipMaps,

        [switch]$Quiet
    )

    $params = Resolve-ParamList @{
        "-i" = $ResourceFile;
        "-r" = $Recurse.IsPresent;

        "-all" = $All.IsPresent;
        "-b" = $Block;
        "-raw" = $BlockRaw.IsPresent;

        "-f" = $Force.IsPresent;
        "-diff" = $Diff.IsPresent;
        "-dep" = $ListDependencies.IsPresent;
        "-module_dep" = $ListModuleDependencies.IsPresent;
        "-gdep" = $ListEngineDependencies.IsPresent;

        "-debug" = $DebugConvert;
        "-mip" = $MipMaps.IsPresent;
        "-fullmip" = $FullMipMaps.IsPresent;
        
        "-v" = $Verbose;
        "-q" = $Quiet;
    }

    Invoke-SourceTool -Tool "resourceinfo.exe" -Parameters $params;
}