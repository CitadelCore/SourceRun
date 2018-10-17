function Compress-VPK {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vmt", "vtf", "mdl", "phy", "vtx", "vvd", "pcf", "vcd");
        })]
        [string]$AddFile,

        [ValidateScript({
            return Test-FolderValidation -Path $_;
        })]
        [string]$FromFolder,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("txt");
        })]
        [string]$FromResponseFile,

        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("kv", "dmx");
        })]
        [string]$FromKeyValuesFile,
        [switch]$MultiChunk
    )

}

function Expand-VPK {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vpk");
        })]
        [string]$Path,
        [string]$Files
    )
}

function Get-VPK {
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("vpk");
        })]
        [string]$Path
    )


}