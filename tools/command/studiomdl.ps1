<#
.SYNOPSIS
Compiles models from intermediate formats to .mdl files.

.DESCRIPTION
Compiles models from intermediate formats exported from modeling packagess to the binary .mdl format that is read by the Source engine.

.PARAMETER Path
Path to the QC file to compile the model from.
.PARAMETER Fast
Skips processing DX7, DX8, X360, and software VTX variants (use .dx90.vtx only). This speeds up compiling.
.PARAMETER Quiet
Suppresses some console output, such as spewing the searchpaths.
.PARAMETER NoWarnings
Disables warnings.
.PARAMETER MaxWarnings
Prints no more than the specified number of warnings.

.PARAMETER DefineBones
Dumps bones defined outside of .smd sources.
.PARAMETER OverrideDefineBones
Equivalent to specifying $unlockdefinebones in QC.
.PARAMETER PrintBones
Writes extra bone info to the console.
.PARAMETER PrintGraph
Dumps xnode data for each node.
.PARAMETER PrintKeyframeData
Prints engine-ready keyframe data for each animation.

.PARAMETER Preview
Skips splitting quads into tris. This changes the rendering flags for the model, most likely resulting in slower performance or buggier rendering in-engine.
.PARAMETER FullCollide
Skips truncation for really big collision meshes (Ep1 only; OB uses $maxconvexpieces).
.PARAMETER StripLods
Ignores all $lod commands.
.PARAMETER MinLod
Throws away data from LODs above the given one (see $minlod).
.PARAMETER DumpMdlReport
Report performance info for an already-compiled model. A QC file is not needed when using this command.
.PARAMETER DumpAsCSV
Report performance info, per LOD, as a comma-delimited spreadsheet. Must be used with -DumpMdlReport.

.PARAMETER DumpGlview
Dumps various glview files (10 per LOD per VTX file).
.PARAMETER DumpHitboxes
Dumps model hitboxes to console.
.PARAMETER DumpMaterials
Dumps names of used materials to the console.
.PARAMETER SkipMaterials
Replaces all materials with the default pink check pattern.
.PARAMETER PrintBadNormals
Tags bad normals.
.PARAMETER PrintBoneReport
Prints info on which bones are being retained and which bones are being collapsed.
.PARAMETER PrintPhysicsErrors
Tests the model collision for any physics errors. Skips whatever argument is provided after it.
.PARAMETER IgnoreWarnings
Ignores warnings.

.PARAMETER Verify
Compiles the model, but dosen't actually write the results to disk.
.PARAMETER AutoSmoothFaces
Auto-smooth faces equal to or below specified angle. Will override normal data for all meshes.
.PARAMETER FlipAllTriangles
Flip all triangles. Does not work in Orangebox and later builds of Studiomdl. You can achieve the same behavior with $body, however.
.PARAMETER GenerateVsi
Generates a VSI file from a QC or MDL.
.PARAMETER GenerateMakefile
Generates a simple makefile for later compiling. It also parses the QC for any errors, and runs in -quiet mode.
.PARAMETER StripModel
Strips down a model, removing its LOD info.
.PARAMETER StripVhv
Strips down hardware verts (VHV) of their LOD info.
.PARAMETER ContentPath
Adds the provided path as a content search path.

#>
function Invoke-ModelCompile {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({
            return Test-FileValidation -Path $_ -Extensions @("qc");
        })]
        [string]$Path,

        # Common options
        [switch]$Fast,
        [switch]$Quiet,
        [switch]$NoWarnings,
        [string]$MaxWarnings,

        # Animation
        [switch]$DefineBones,
        [switch]$OverrideDefineBones,
        [switch]$PrintBones,
        [switch]$PrintGraph,
        [switch]$PrintKeyframeData,

        # Performance
        [switch]$Preview,
        [switch]$FullCollide,
        [switch]$StripLods,
        [string]$MinLod,
        [string]$DumpMdlReport,
        [string]$DumpAsCSV,

        # Debug options
        [switch]$DumpGlview,
        [switch]$DumpHitboxes,
        [switch]$DumpMaterials,
        [switch]$SkipMaterials,
        [switch]$PrintBadNormals,
        [switch]$PrintBoneReport,
        [switch]$PrintPhysicsErrors,
        [switch]$IgnoreWarnings,

        # Other
        [switch]$Verify,
        [string]$AutoSmoothFaces,
        [switch]$FlipAllTriangles,
        [string]$GenerateVsi,
        [switch]$GenerateMakefile,
        [string]$StripModel,
        [string]$StripVhv,
        [string]$ContentPath
    )

    $params = Resolve-ParamList @{
        # Common options
        "-fastbuild" = $Fast.IsPresent;
        "-quiet" = $Quiet.IsPresent;
        "-nowarnings" = $NoWarnings.IsPresent;
        "-maxwarnings" = $MaxWarnings;
        
        # Animation
        "-definebones" = $DefineBones.IsPresent;
        "-overridedefinebones" = $OverrideDefineBones.IsPresent;
        "-printbones" = $PrintBones.IsPresent;
        "-printgraph" = $PrintGraph.IsPresent;
        "-checklengths" = $PrintKeyframeData.IsPresent;

        # Performance
        "-preview" = $Preview.IsPresent;
        "-fullcollide" = $FullCollide.IsPresent;
        "-noprune" = $StripLods.IsPresent;
        "-striplods" = $MinLod.IsPresent;
        "-mdlreport" = $DumpMdlReport;
        "-mdlreportspreadsheet" = $DumpAsCSV.IsPresent;

        # Debug options
        "-d" = $DumpGlview.IsPresent;
        "-h" = $DumpHitboxes.IsPresent;
        "-dumpmaterials" = $DumpMaterials.IsPresent;
        "-t" = $SkipMaterials.IsPresent;
        "-parsecompletion" = $true;
        "-n" = $PrintBadNormals.IsPresent;
        "-collapsereport" = $PrintBoneReport.IsPresent;
        "-ihvtest" = $PrintPhysicsErrors.IsPresent;
        "-i" = $IgnoreWarnings.IsPresent;

        # Other
        "-verify" = $Verify.IsPresent;
        "-a" = $AutoSmoothFaces;
        "-f" = $FlipAllTriangles.IsPresent;
        "-vsi" = $GenerateVsi;
        "-makefile" = $GenerateMakefile.IsPresent;
        "-stripmodel" = $StripModel;
        "-stripvhv" = $StripVhv;
        "-tempcontent" = $ContentPath;
    }

    $params = $params + $Path;
    Invoke-SourceTool -Tool "studiomdl" -Parameters $params;
}