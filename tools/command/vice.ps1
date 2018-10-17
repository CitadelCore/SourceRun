function Invoke-Vice {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,

        [switch]$Quiet,
        [switch]$NoPause,

        [Parameter(Mandatory=$True)]
        [ValidateSet("Encrypt", "Decrypt")]
        [string]$Action,

        [Parameter(Mandatory=$True)]
        [string]$Key,

        [string]$NewExtension
    )

    $params = Resolve-ParamList @{
        "-quiet" = $Quiet.IsPresent;
        "-nopause" = $NoPause.IsPresent;
        "-newext" = $NewExtension;
    }

    switch ($Action) {
        Encrypt {
            $params = "$params -encrypt $Key "
        }

        Decrypt {
            $params = "$params -decrypt $Key "
        }
    }

    $params = "$params$Path";
    Invoke-SourceTool -Tool "vice" -Parameters $params;
}

function Protect-ViceFile {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,

        [switch]$Quiet,
        [switch]$NoPause,

        [Parameter(Mandatory=$True)]
        [string]$Key,

        [string]$NewExtension
    )

    Invoke-Vice -Path $Path -Action Encrypt -Key $Key -NewExtension $NewExtension
}

function Unprotect-ViceFile {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,

        [switch]$Quiet,
        [switch]$NoPause,

        [Parameter(Mandatory=$True)]
        [string]$Key,

        [string]$NewExtension
    )

    Invoke-Vice -Path $Path -Action Decrypt -Key $Key -NewExtension $NewExtension
}