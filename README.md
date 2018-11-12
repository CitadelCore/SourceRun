# SourceRun

SourceRun is a powerful scripting engine for automating Source Engine tasks with PowerShell.
Allows Source SDK tools to be invoked with PowerShell cmdlets. Automatically parses tool output where possible.

## Examples

### Setting VWorkspace

VWorkspace must be set every time you open a new PowerShell runspace. A workspace definition consists of a specially formatted .json file, which includes information about the Source game used to run tools, its primary content directory, and version control configuration for Perforce and Git. If VWorkspace is not set and you attempt to run a tool, it will fail with an error.

To set your VWorkspace, type this command:

```powershell
Set-VWorkspace -Path "E:\SourceSDK\path\to\my\workspace"
```

There is currently no function integrated to create workspaces. You can either create and modify a workspace in Chaos Launcher, or use the template below and modify it with your own path information.
Here is an example of a workspace definition, workspace.json.

```json
{
    "Name":"Test Workspace",
    "Identifier":"b23fd964-a8df-4949-877f-1084fe5f1f9e",
    "Folder":"C:\\Program Files (x86)\\Steam\\steamapps\\common\\SteamVR\\tools\\steamvr_environments\\game\\steamtours_addons\\testaddon",
    "SourceGame":{
        "AppId":"250820",
        "AppExecutable":"steamtours.exe",
        "ProductName":"SteamVR",
        "ContentDir":"c:\\program files (x86)\\steam\\steamapps\\common\\SteamVR\\tools\\steamvr_environments\\game\\steamtours",
        "IsSource2":true
        },
    "LaunchParameters":null,
    "PerforceEnabled":false,
}
```

### Compiling a VMF

Ensure you set your VWorkspace before running these commands!

```powershell
$vmf = "E:\path\to\my\mapsrc\mymap.vmf";

$bsp = (New-BSP -Path $vmf).Output;
Update-BspVisibility -Path $bsp;
Update-BspLighting -Path $bsp -Both -StaticPropPolys -StaticPropLighting;
```