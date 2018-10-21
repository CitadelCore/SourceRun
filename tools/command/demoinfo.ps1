<#
.SYNOPSIS
Samples info from .dem files.

.DESCRIPTION
Returns information from .dem files.

.PARAMETER Path
Path to the .dem file to inspect.
.PARAMETER Log
Logs inspection output to log.txt.

.EXAMPLE
C:\PS> Get-SourceDemo -Path "C:\test\test.dem"

#>
function Get-SourceDemo {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({return Test-FileValidation -Path $_ -Extensions @("dem");})]
        [string]$Path,
        [switch]$Log,
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log.IsPresent;
    }

    $params = "$params $Path"
    Invoke-SourceTool -Tool "demoinfo" -Parameters $params | Out-Null;
}