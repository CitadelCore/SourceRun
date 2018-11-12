<#
.SYNOPSIS
Compiles models from intermediate formats to .mdl files.

.DESCRIPTION
Compiles models from intermediate formats exported from modeling packagess to the binary .mdl format that is read by the Source engine.

.PARAMETER Path
Path to the QC file to compile the model from.
.PARAMETER DumpMdlReport
Report performance info for an already-compiled model. A QC file is not needed when using this command.
.PARAMETER DumpAsCSV
Report performance info, per LOD, as a comma-delimited spreadsheet. Must be used with -DumpMdlReport.
.PARAMETER PrintPhysicsErrors
Tests the model collision for any physics errors. Skips whatever argument is provided after it.
.PARAMETER OverrideDefineBones
Equivalent to specifying $unlockdefinebones in QC.
.PARAMETER StripLods
Ignores all $lod commands.
.PARAMETER StripModel
Strips down a model, removing its LOD info.
.PARAMETER StripVhv
Strips down hardware verts (VHV) of their LOD info.
.PARAMETER GenerateVsi
Generates a VSI file from a QC or MDL.
.PARAMETER Quiet
Suppresses some console output, such as spewing the searchpaths.
.PARAMETER FullCollide
Skips truncation for really big collision meshes (Ep1 only; OB uses $maxconvexpieces).
.PARAMETER PrintKeyframeData
Prints engine-ready keyframe data for each animation.
.PARAMETER PrintBones
Writes extra bone info to the console.
.PARAMETER PrintPerf
TODO
.PARAMETER PrintGraph
Dumps xnode data for each node.
.PARAMETER DefineBones
Dumps bones defined outside of .smd sources.
.PARAMETER GenerateMakefile
Generates a simple makefile for later compiling. It also parses the QC for any errors, and runs in -quiet mode.
.PARAMETER Verify
Compiles the model, but dosen't actually write the results to disk.
.PARAMETER MinLod
Throws away data from LODs above the given one (see $minlod).
.PARAMETER Xbox360
Activates byte swapping (big endian) for Xbox 360 compiles.
.PARAMETER NoWarnings
Disables warnings.
.PARAMETER MaxWarnings
Prints no more than the specified number of warnings.
.PARAMETER Preview
Skips splitting quads into tris. This changes the rendering flags for the model, most likely resulting in slower performance or buggier rendering in-engine.
.PARAMETER DumpMaterials
Dumps names of used materials to the console.
.PARAMETER Fast
Skips processing DX7, DX8, X360, and software VTX variants (use .dx90.vtx only). This speeds up compiling.
.PARAMETER SkipMaterials
Replaces all materials with the default pink check pattern.
.PARAMETER PrintReversed
Tags reversed.
.PARAMETER PrintBadNormals
Tags bad normals.
.PARAMETER AutoSmoothFaces
Auto-smooth faces equal to or below specified angle. Will override normal data for all meshes.
.PARAMETER DumpHitboxes
Dumps model hitboxes to console.
.PARAMETER IgnoreWarnings
Ignores warnings.
.PARAMETER DumpGlview
Dumps various glview files (10 per LOD per VTX file).

.PARAMETER PrintBoneReport
Prints info on which bones are being retained and which bones are being collapsed.
.PARAMETER FlipAllTriangles
Flip all triangles. Does not work in Orangebox and later builds of Studiomdl. You can achieve the same behavior with $body, however.
.PARAMETER ContentPath
Adds the provided path as a content search path.

#>
function New-Model {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("qc");
        })]
        [string]$Path,

        [string]$DumpMdlReport,
        [string]$DumpAsCSV,
        [switch]$PrintPhysicsErrors,
        [switch]$OverrideDefineBones,
        [switch]$StripLods,
        [string]$StripModel,
        [string]$StripVhv,
        [string]$GenerateVsi,
        [switch]$Quiet,
        [switch]$FullCollide,
        [switch]$PrintKeyframeData,
        [switch]$PrintBones,
        [switch]$PrintPerf,
        [switch]$PrintGraph,
        [switch]$DefineBones,
        [switch]$GenerateMakefile,
        [switch]$Verify,
        [string]$MinLod,
        [switch]$Xbox360,
        [switch]$NoWarnings,
        [string]$MaxWarnings,
        [switch]$Preview,
        [switch]$DumpMaterials,
        [switch]$Fast,
        [switch]$SkipMaterials,
        [switch]$PrintReversed,
        [switch]$PrintBadNormals,
        [string]$AutoSmoothFaces,
        [switch]$DumpHitboxes,
        [switch]$IgnoreWarnings,
        [switch]$DumpGlview,
        [switch]$PrintBoneReport,
        [switch]$FlipAllTriangles,
        [string]$ContentPath
    )

    $params = Resolve-ParamList @{
        # Common options
        "-mdlreport" = $DumpMdlReport;
        "-mdlreportspreadsheet" = $DumpAsCSV.IsPresent;
        "-ihvtest" = $PrintPhysicsErrors.IsPresent;
        "-overridedefinebones" = $OverrideDefineBones.IsPresent;
        "-striplods" = $StripLods.IsPresent;
        "-stripmodel" = $StripModel;
        "-stripvhv" = $StripVhv;
        "-vsi" = $GenerateVsi;
        "-quiet" = $Quiet.IsPresent;
        "-fullcollide" = $FullCollide.IsPresent;
        "-checklengths" = $PrintKeyframeData.IsPresent;
        "-printbones" = $PrintBones.IsPresent;
        "-perf" = $PrintPerf.IsPresent;
        "-printgraph" = $PrintGraph.IsPresent;
        "-definebones" = $DefineBones.IsPresent;
        "-makefile" = $GenerateMakefile.IsPresent;
        "-verify" = $Verify.IsPresent;
        "-minlod" = $MinLod;
        "-x360" = $Xbox360.IsPresent;
        "-nowarnings" = $NoWarnings.IsPresent;
        "-maxwarnings" = $MaxWarnings;
        "-preview" = $Preview.IsPresent;
        "-dumpmaterials" = $DumpMaterials.IsPresent;
        "-fastbuild" = $Fast.IsPresent;

        "-t" = $SkipMaterials.IsPresent;
        "-r" = $PrintReversed.IsPresent;
        "-n" = $PrintBadNormals.IsPresent;
        "-a" = $AutoSmoothFaces;
        "-h" = $DumpHitboxes.IsPresent;
        "-i" = $IgnoreWarnings.IsPresent;
        "-d" = $DumpGlview.IsPresent;
        "-collapsereport" = $PrintBoneReport.IsPresent;
        "-f" = $FlipAllTriangles.IsPresent;
        "-tempcontent" = $ContentPath;
        "-parsecompletion" = $true;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "studiomdl.exe" -Parameters $params;
}