function Compress-BSP {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [string]$DestinationPath,

        [string]$InnerPath,

        [string]$AddFile,
        [string]$AddList
    )
}

function Expand-BSP {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [string]$DestinationPath
    )
}