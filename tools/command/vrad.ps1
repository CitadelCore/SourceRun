<#
.SYNOPSIS
Embeds lighting data into a BSP.

.DESCRIPTION
Generates lightmaps, ambient amples and per-object/per-vertex lighting for prop_static and detail prop entities.

.PARAMETER Path
Path to the BSP to be used.
.PARAMETER Bounce
Set max number of bounces (default: 100).
.PARAMETER Ldr
Calculates lighting for Low Dynamic Range only.
.PARAMETER Hdr
Calculates lighting for High Dynamic Range only.
.PARAMETER Both
Calculates lighting for both HDR and LDR.
.PARAMETER Fast
Quick and dirty lighting.
.Parameter FastAmbient
Per-leaf ambient sampling is lower quality to save compute time.
.PARAMETER Final
Writes .gl files in the current directory that can be viewed with the glview tool.
.PARAMETER FiniteFallOff
Get rid of all detail geometry. The geometry left over is what affects visibility.
.PARAMETER ExtraSky
Get rid of water brushes.
.PARAMETER LowPriority
Run as an idle-priority process.
.PARAMETER Mpi
Use VMPI to distribute computations.
.PARAMETER RedError
Shows luxel sample errors in red.
.PARAMETER InsertSearchPath
To do: What is this?

.PARAMETER Dump
Write debugging .txt files.
.PARAMETER DumpNormals
Write normals to debug files.
.PARAMETER DumpTrace
Write ray-tracing environment to debug files.
.PARAMETER NumThreads
Control the number of threads vbsp uses (defaults to the # of processors on your machine).
.PARAMETER UseLights
Load a lights file in addition to lights.rad and the level lights file.
.PARAMETER NoExtra
Disable supersampling.
.PARAMETER DebugExtra
Places debugging data in lightmaps to visualize supersampling.
.PARAMETER Smooth
Set the threshold for smoothing groups, in degrees (default 45).
.PARAMETER DirectLightMap
Force direct lighting into different lightmap than radiosity.
.PARAMETER StopOnExit
Wait for a keypress on exit.
.PARAMETER MpiPassword
Use a password to choose a specific set of VMPI workers.
.PARAMETER NoDetailLight
Don't light detail props.
.PARAMETER CentreSamples
Move sample centres.
.PARAMETER LuxelDensity
Rescale all luxels by the specified amount (default: 1.0). The number specified must be less than 1.0 or it will be ignored.
.PARAMETER LogSampleHashTable
Log the sample hash table to samplehash.txt.
.PARAMETER OnlyDetail
Only light detail props and per-leaf lighting.
.PARAMETER MaxDispSampleSize
Set max displacement sample size (default: 512).
.PARAMETER SoftSun
Treat the sun as an area light source of size <n> degrees. Produces soft shadows. Recommended values are between 0 and 5. Default is 0.
.PARAMETER FullMinidumps
Write large minidumps on crash.
.PARAMETER Chop
Smallest number of luxel widths for a bounce patch, used on edges
.PARAMETER MaxChop
Coarsest allowed number of luxel widths for a patch, used in face interiors
.PARAMETER LargeDispSampleRadius
This can be used if there are splotches of bounced light on terrain. The compile will take longer, but it will gather light across a wider area.
.PARAMETER CompressConstant
Compresses lightmaps whose color variation is less than this many units.
.PARAMETER StaticPropSampleScale
Regulates the generated per-vertex prop_static lighting. Don't light detail props. slow: 16 (high quality); default: 4 (normal); fast: 0.25 (low quality).
.PARAMETER StaticPropLighting
Generate backed static prop vertex lighting
.PARAMETER StaticPropPolys
Perform shadow tests of static props at polygon precision
.PARAMETER OnlyStaticProps
Only perform direct static prop lighting (Update-BspLighting debug option)
.PARAMETER StaticPropNormals
When lighting static props, just show their normal vector
.PARAMETER TextureShadows
Allows texture alpha channels to block light - rays intersecting alpha surfaces will sample the texture
.PARAMETER AoScale
Scales the intensity of VRAD's simulated ambient occlusion. 1.0 is default. Example: 1.5 for Dust 2.
.PARAMETER StaticPropBounce
Number of static prop light bounces to simulate. The default is 0. Example: 3 for Dust 2. Props must have bounced lighting enabled.
.PARAMETER NoSkyboxRecurse
Turn off recursion into 3d skybox (skybox shadows on world)
.PARAMETER NoSelfShadowProps
Globally disable self-shadowing on static props
.PARAMETER DumpPropMaps
Dump computed prop lightmaps.

#>
function Update-BspLighting {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("bsp");
        })]
        [string]$Path,

        # Common options
        [switch]$Bounce,
        [switch]$Ldr,
        [switch]$Hdr,
        [switch]$Both,
        [switch]$Fast,
        [switch]$FastAmbient,
        [switch]$Final,
        [switch]$FiniteFallOff,
        [string]$ExtraSky,
        [switch]$LowPriority,
        [switch]$Mpi,
        [switch]$RedError,
        [ValidateScript({
            return Test-FolderValidation -Path $_;
        })]
        [string]$InsertSearchPath,

        # Other options
        [switch]$Dump,
        [switch]$DumpNormals,
        [switch]$DumpTrace,
        [string]$NumThreads,
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("rad");
        })]
        [string]$UseLights,
        [switch]$NoExtra,
        [switch]$DebugExtra,
        [string]$Smooth,
        [switch]$DLightMap,
        [switch]$StopOnExit,
        [securestring]$MpiPassword,
        [switch]$NoDetailLight,
        [switch]$CentreSamples,
        [string]$LuxelDensity,
        [switch]$LogSampleHashTable,
        [switch]$OnlyDetail,
        [string]$MaxDispSampleSize,
        [string]$SoftSun,
        [switch]$FullMinidumps,
        [string]$Chop,
        [string]$MaxChop,
        [switch]$LargeDispSampleRadius,
        [string]$CompressConstant,
        [string]$StaticPropSampleScale,
        [switch]$StaticPropLighting,
        [switch]$StaticPropPolys,
        [switch]$OnlyStaticProps,
        [switch]$StaticPropNormals,
        [switch]$TextureShadows,
        [string]$AoScale,
        [string]$StaticPropBounce,
        [switch]$NoSkyboxRecurse,
        [switch]$NoSelfShadowProps,
        [switch]$DumpPropMaps
    )

    $NoVConfig = $True;

    $params = Resolve-ParamList @{
        "-v" = $Verbose.IsPresent;
        "-ldr" = $Ldr.IsPresent;
        "-hdr" = $Hdr.IsPresent;
        "-both" = $Both.IsPresent;
        "-bounce" = $Bounce;
        "-fast" = $Fast.IsPresent;
        "-fastambient" = $FastAmbient.IsPresent;
        "-final" = $Final.IsPresent;
        "-finitefalloff" = $FiniteFallOff.IsPresent;
        "-extrasky" = $ExtraSky;
        "-low" = $LowPriority.IsPresent;
        "-mpi" = $Mpi.IsPresent;
        "-rederror" = $RedError.IsPresent;
        "-insert_search_path" = $InsertSearchPath;

        "-novconfig" = $NoVConfig;
        "-dump" = $Dump.IsPresent;
        "-dumpnormals" = $DumpNormals.IsPresent;
        "-dumptrace" = $DumpTrace.IsPresent;
        "-threads" = $NumThreads;
        "-lights" = $UseLights;
        "-noextra" = $NoExtra.IsPresent;
        "-debugextra" = $DebugExtra.IsPresent;
        "-smooth" = $Smooth;
        "-dlightmap" = $DLightMap.IsPresent;
        "-stoponexit" = $StopOnExit.IsPresent;
        "-mpi_pw" = $MpiPassword;
        "-nodetaillight" = $NoDetailLight.IsPresent;
        "-centersamples" = $CentreSamples.IsPresent;
        "-luxeldensity" = $LuxelDensity;
        "-loghash" = $LogSampleHashTable.IsPresent;
        "-onlydetail" = $OnlyDetail.IsPresent;
        "-maxdispsamplesize" = $MaxDispSampleSize;
        "-softsun" = $SoftSun;
        "-FullMinidumps" = $FullMinidumps.IsPresent;
        "-chop" = $Chop;
        "-maxchop" = $MaxChop;
        "-LargeDispSampleRadius" = $LargeDispSampleRadius.IsPresent;
        "-compressconstant" = $CompressConstant;
        "-StaticPropSampleScale" = $StaticPropSampleScale;
        "-StaticPropLighting" = $StaticPropLighting.IsPresent;
        "-OnlyStaticProps" = $OnlyStaticProps.IsPresent;
        "-StaticPropNormals" = $StaticPropNormals.IsPresent;
        "-textureshadows" = $TextureShadows.IsPresent;
        "-aoscale" = $AoScale;
        "-staticpropbounce" = $StaticPropBounce;
        "-noskyboxrecurse" = $NoSkyboxRecurse.IsPresent;
        "-nossprops" = $NoSelfShadowProps.IsPresent;
        "-dumppropmaps" = $DumpPropMaps.IsPresent;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "vrad" -Parameters $params;
}