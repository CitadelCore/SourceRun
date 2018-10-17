function Invoke-CaptionCompile {
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [switch]$Log
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "captioncompiler" -Parameters $params | Out-Null;
}