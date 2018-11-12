function Compress-VPK {
    param(
        [Parameter(ParameterSetName='addFile', Mandatory=$True)]
        [Parameter(ParameterSetName='addResponseFile', Mandatory=$True)]
        [Parameter(ParameterSetName='addKeyValuesFile', Mandatory=$True)]
        [string]$Path,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vmt", "vtf", "mdl", "phy", "vtx", "vvd", "pcf", "vcd");
        })]
        [Parameter(ParameterSetName='addFile')]
        [string]$AddFile,

        [ValidateScript({
            return Test-FolderValidation -Path $_;
        })]
        [Parameter(ParameterSetName='addFolder', Mandatory=$True)]
        [string]$FromFolder,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("txt");
        })]
        [Parameter(ParameterSetName='addResponseFile', Mandatory=$True)]
        [string]$FromResponseFile,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("kv", "dmx");
        })]
        [Parameter(ParameterSetName='addKeyValuesFile', Mandatory=$True)]
        [string]$FromKeyValuesFile,
        
        [switch]$MultiChunk,
        [string]$ChunkSize,
        [string]$ChunkAlign,
        [switch]$SteamPipe,

        [string]$PublicKey,
        [string]$PrivateKey
    )

    if ($AddFile -ne "") {
        $params = @("a", $Path, $AddFile);
    }

    if ($FromFolder -ne "") {
        $params = @($Path);
    }

    if ($FromResponseFile -ne "") {
        $params = @("a", $Path, "@$FromResponseFile");
    }

    if ($FromKeyValuesFile -ne "") {
        $params = @("k", $Path, "@$FromKeyValuesFile");
    }

    # We have to do it this way because of the -k and -K conflict
    $plist = New-Object System.Collections.Hashtable;
    $plist['-v'] = $Verbose;
    $plist['-c'] = $ChunkSize;
    $plist['-a'] = $ChunkAlign;
    $plist['-k'] = $PublicKey;
    $plist['-K'] = $PrivateKey;
    $plist['-M'] = $MultiChunk.IsPresent;
    $plist['-P'] = $SteamPipe.IsPresent;

    $params2 = Resolve-ParamList $plist;
    $params = $params2 + $params;
    Invoke-SourceTool -Tool "vpk.exe" -Parameters $params -Verbose $Verbose;
}

function Expand-VPK {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vpk");
        })]
        [string]$Path,
        [string]$File
    )

    $params2 = Resolve-ParamList @{
        "-v" = $Verbose
    }

    $params = $params2 + @("x", $Path, $File);
    Invoke-SourceTool -Tool "vpk.exe" -Parameters $params;
}

function Get-VPK {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vpk");
        })]
        [string]$Path,

        [Parameter(ParameterSetName='checkHash', Mandatory=$True)]
        [switch]$CheckHash,

        [Parameter(ParameterSetName='checkSignature', Mandatory=$True)]
        [switch]$CheckSignature,
        [Parameter(ParameterSetName='checkSignature', Mandatory=$True)]
        [string]$PublicKey,

        [Parameter(ParameterSetName='dumpSignature', Mandatory=$True)]
        [switch]$DumpSignature,

        [Parameter(ParameterSetName='listFiles', Mandatory=$True)]
        [switch]$ListFiles
    )

    $params2 = Resolve-ParamList @{
        "-v" = $Verbose;
        "-k" = $PublicKey;
    }

    if ($CheckHash.IsPresent) {
        $params = $params2 + @("checkhash", $Path);
    }
    if ($CheckSignature.IsPresent) {
        $params = $params2 + @("checksig", $Path);
    }
    if ($DumpSignature.IsPresent) {
        $params = $params2 + @("dumpsig", $Path);
    }
    if ($ListFiles.IsPresent) {
        $params = $params2 + @("l", $Path);
    }
    
    Invoke-SourceTool -Tool "vpk.exe" -Parameters $params;
}

function New-VPKKeypair {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$KeyName
    )
    
    $params2 = Resolve-ParamList @{
        "-v" = $Verbose
    }

    $params = $params2 + @("generate_keypair", $KeyName);
    Invoke-SourceTool -Tool "vpk.exe" -Parameters $params;
}