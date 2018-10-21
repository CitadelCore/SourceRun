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

    foreach ($Param in $ParamTable.Keys) {
        $parval = $ParamTable[$Param];
        if ($parval -is [bool]) {
            if ($parval -eq $True) {
                $ParamString = "$ParamString $Param ";
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
            $ParamString = "$ParamString $Param $parval ";
        }
    }

    return $ParamString;
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
    [string]$Parameters,

    [string]$Branch
)

$workspace = Get-Variable -Name "VWorkspace" -ValueOnly;
if ($workspace -eq "") {
    Write-Error "Tool requires VWorkspace to be set. Please use Set-VWorkspace to set your workspace directory.";
    return 1;
}

$config = Get-JsonFile "$workspace/workspace.json";

$bindir = $config.SourceGame.ContentDir + "\..\bin";
if (!(Test-Path $bindir)) { Write-Error "Branch binary folder not found."; return 1; }

$toolfile = "$bindir\$Tool"
#Write-Output $toolfile;
#if (!(Test-Path $toolfile)) { Write-Error "Tool not found in branch."; return 1; }

$Parameters = $Parameters.Trim();
$arguments = @();

if ($Parameters -ne "") { $arguments = @($Parameters) }

$startInfo = New-Object System.Diagnostics.ProcessStartInfo;
$startInfo.FileName = $toolfile;
$startInfo.UseShellExecute = $false;
$startInfo.CreateNoWindow = $true;
$startInfo.WorkingDirectory = $workspace;

$vars = $startInfo.EnvironmentVariables;
$vars["VProject"] = $config.SourceGame.ContentDir;
if ($config.PerforceEnabled) {
    $vars["P4PORT"] = $config.PerforceServer;
    $vars["P4USER"] = $config.PerforceUser;
    $vars["P4CLIENT"] = $config.PerforceClient;
    $vars["P4CHARSET"] = $config.PerforceCharset;
}

if ($arguments -ne @()) {
    if ($Verbose) {
        Write-Host "Passing arguments to tool $Tool. Arguments: $arguments";
    }
    $startInfo.Arguments = $arguments;
}

$proc = New-Object System.Diagnostics.Process;
$proc.StartInfo = $startInfo;
$proc.Start() | Out-Null;
$proc.WaitForExit();

$exitcode = $proc.ExitCode
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