<#
.SYNOPSIS
Compiles closed captions for Source games.

.DESCRIPTION
Compiles closed captions from source .txt files to compiled .dat files.

.PARAMETER Path
Path to the source .txt file to compile. Must be in <workspace>\resource\.
.PARAMETER Log
Logs compilation output to log.txt.

#>
function New-CompiledCaption {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("txt");})]
        [string]$Path,
        [switch]$Log
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log;
    }

    $params = "$params $Path"
    Invoke-SourceTool -Tool "captioncompiler" -Parameters $params | Out-Null;
}

<#
.SYNOPSIS
Compiles KeyValues files.

.DESCRIPTION
Compiles files such as VMTs and paint kits to KeyValues files.

.PARAMETER Path
Wilcard path to the source .vmt or .paintkit to compile.
.PARAMETER Log
Logs compilation output to log.txt.

.PARAMETER TestLoadTiming
Performs load timing tests.
.PARAMETER PaintKit
Performs paint kit macro expansion. With this specified, if no output file is specified,
the input file is copied to <input>_bak and <input> is overwritten. Each file specified is
processed seperately without wildcards.
.PARAMETER FixOnly
Compiled files are output to <input>_fix and <input> is kept unchanged. Must be used with -PaintKit.

.EXAMPLE
C:\PS> New-CompiledKvc -Path "C:\test\materials\*.vmt"
.EXAMPLE
C:\PS> New-CompiledKvc -PaintKit -Path "C:\test\americanpastoral_rocketlauncher.paintkit"

#>
function New-CompiledKvc {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("txt");})]
        [string]$Path,
        [switch]$Log,

        [Parameter(ParameterSetName='loadTiming')]
        [switch]$TestLoadTiming,

        [Parameter(ParameterSetName='paintKit', Mandatory=$True)]
        [switch]$PaintKit,
        [Parameter(ParameterSetName='paintKit')]
        [switch]$FixOnly
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log.IsPresent;
        "-p" = $PaintKit.IsPresent;
        "-f" = $FixOnly.IsPresent;
    }

    $params = "$params $Path"
    Invoke-SourceTool -Tool "kvc" -Parameters $params | Out-Null;
}