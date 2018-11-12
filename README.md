# SourceRun

SourceRun is a powerful scripting engine for automating Source Engine tasks with PowerShell.
Allows Source SDK tools to be invoked with PowerShell cmdlets. Automatically parses tool output where possible.

## Examples

### Compiling a VMF

```powershell
$vmf = "E:\path\to\my\mapsrc\mymap.vmf";

$bsp = (New-BSP -Path $vmf).Output;
Update-BspVisibility -Path $bsp;
Update-BspLighting -Path $bsp -Both -StaticPropPolys -StaticPropLighting;
```