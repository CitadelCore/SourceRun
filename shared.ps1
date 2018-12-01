function Format-MultiText {
    param(
        [string[]]$Extensions
    )

    if ($Extensions.Count -lt 2) {
        $exts = $Extensions[0]
    } else {
        for ($i = 0; $i -le $Extensions.Count - 1; $i++) {
            if ($i -eq $Extensions.Count - 1) {
                $exts = $exts + "and " + $Extensions[$i];
            } else {
                $exts = $exts + $Extensions[$i] + ", ";
            }
        }
    }

    return $exts;
}
function New-ExtensionPattern {
    param(
        [string[]]$Extensions
    )

    $first = $True
    if (($Extensions -ne "") -and ($Extensions.Length -gt 0)) {
        $extstr = "("
        foreach ($ext in $Extensions) {
            $subst = "\.$ext"; 
            if (!($first)) { $subst = "|$subst"; }

            $extstr = $extstr + $subst;
            $first = $False;
        }

        $extstr = $extstr + ")"
    }

    return $extstr;
}

function Test-FolderValidation {
    param(
        [string]$Path
    )

    if (!($Path | Test-Path)) {
        throw "File or folder does not exist."
    }

    if (!($Path | Test-Path -PathType Container)) {
        throw "The Path argument must be a folder. File paths are not allowed"
    }

    return $True
}

function Test-FileValidation {
    param(
        [string]$Path,
        [string[]]$Extensions
    )

    if (!($Path | Test-Path)) {
        throw "File or folder does not exist."
    }

    if (!($Path | Test-Path -PathType Leaf)) {
        throw "The Path argument must be a file. Folder paths are not allowed"
    }

    $ExtPattern = New-ExtensionPattern $Extensions;

    if (!($ExtPattern -eq "") -and ($Path -notmatch $ExtPattern))
    {
        $exts = Format-MultiText $Extensions;
        
        throw "The file specified is not of the correct type. Only files of type(s) $exts are allowed."
    }

    return $True;
}

function Resolve-ParamList {
    param(
        [hashtable]$ParamTable,
        [string]$ParamString
    )

    $plist = @();
    foreach ($Param in $ParamTable.Keys) {
        $parval = $ParamTable[$Param];
        if ($parval -is [bool]) {
            if ($parval -eq $True) {
                $plist += $Param;
            }
        } else {
            # ensure object is not null
            if (($null -eq $parval) -or ($parval -eq "")) {
                continue;
            }

            # ensure object is not an empty array
            if (($parval -is [array]) -and (([array]$parval).Length -lt 1)) {
                continue;
            }
            
            # set unpack array
            $ofs = ' ';
            $unpacked = "$parval"
            $plist += $Param;
            $plist += $unpacked;
        }
    }

    return ,$plist;
}

function Get-JsonFile {
    Param(
            [string]$Path
        )
    
        $json = (Get-Content "$Path") -Join "`n" | ConvertFrom-Json;
        return $json;
}

function Invoke-SourceTool {
    Param(
    [Parameter(Mandatory=$True)]
    [string]$Tool,
    [string[]]$Parameters,

    [string]$Branch
)

if ((Test-Path variable:global:VWorkspace) -eq $False) {
    Write-Error "Tool requires VWorkspace to be set. Please use Set-VWorkspace to set your workspace directory.";
    return;
}

$workspace = Get-Variable -Name "VWorkspace" -Scope Global -ValueOnly;
$config = Get-JsonFile "$workspace/workspace.json";

$bindir = $config.SourceGame.ContentDir + "\..\bin";
if ($config.SourceGame.IsSource2) {
    $bindir = $bindir + "\win64";
}

if (!(Test-Path $bindir)) { Write-Error "Branch binary folder not found."; return; }

if ((Test-Path variable:global:VToolOverride) -eq $True) {
    Write-Warning -Message "Tool binary directory is being overriden by VToolOverride.";
    $bindir = Get-Variable -Name "VToolOverride" -Scope Global -ValueOnly;
}

$toolFile = "$bindir\$Tool"
#if (!(Test-Path $toolfile)) { Write-Error "Tool not found in SDK branch bin directory."; return; }

$env:VProject = $config.SourceGame.ContentDir;
if ($config.PerforceEnabled) {
    $env:P4PORT = $config.PerforceServer;
    $env:P4USER = $config.PerforceUser;
    $env:P4CLIENT = $config.PerforceClient;
    $env:P4CHARSET = $config.PerforceCharset;
}

# Execute the tool
# Push-Location -Path $workspace;
& $toolFile $Parameters;
# Pop-Location;

# Reset environment variables
$env:VProject = $null;
$env:P4PORT = $null;
$env:P4USER = $null;
$env:P4CLIENT = $null;
$env:P4CHARSET = $null;

$exitcode = $LASTEXITCODE;
if ($exitcode -ne 0) {
    if ($exitcode -eq 1) {
        Write-Error "Utility encountered an error." -RecommendedAction "Check the utility output for more information, and ensure all parameters are correct."
    } elseif ($exitcode -eq -1073741819) {
        Write-Error -Message "Utility returned a fatal execution error." -RecommendedAction "Ensure you are using compatible tools for your Source SDK version."
    } else {
        Write-Error "Utility returned an unknown error code: $exitcode." -RecommendedAction "Check the utility output for more information."
    }
}
}