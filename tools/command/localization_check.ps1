<#
.SYNOPSIS
Checks voice .wav files for proper localisation.

.DESCRIPTION
Verifies that .wav files has proper localisation.

.PARAMETER Log
Logs output to log.txt.

.PARAMETER BuildNukeScript
Generates nuke.bat, which nukes all unreferenced .vcd files from Perforce.
.PARAMETER GenerateVcdUsage
Generates usage data for .vcd files, based on -makereslists.
.PARAMETER GenerateSoundUsage
Generates a list of unused sounds.txt entries.
.PARAMETER GenerateCaptions
Builds closed caption fixed/fixed2.txt files.
.PARAMETER GenerateSounds
Regenerates missing or mismatched combined .wav files. Specify the language
to check combined language files for existance and duration, otherwise
specify "english" to skip language checks.
.PARAMETER GenerateDialog
Generates dialog script from .vcd files.
.PARAMETER GenerateCsv
Spews a .csv of .wav files in the directory, including sound and closed caption information.
.PARAMETER GeneratePhoneMe
Generates phoneme data for files recursively in the specfied directory.
.PARAMETER ForcePhoneMe
Forces phoneme extraction even if the .wav already has phoneme data.
.PARAMETER ExtractUnicode
Imports unicode wavenames and captions into a new closecaption_test.txt file.
.PARAMETER ExtractEnglish
Pulls raw English out of closecaption.txt, for spell checking.
.PARAMETER ExtractEnglishPath
Given a directory of .wav files, finds the full directory path for them based on English.
.PARAMETER ExtractEnglishDuck
Sets voice duck for sounds in the second directory to the ones in the first directory.
.PARAMETER LoopCheck
Prints a warning if any sound files in the specified directory has loop markers in the .wav.

.EXAMPLE
C:\PS> Invoke-LocalisationCheck -Log -GenerateCsv "npc\metropolice\vo" -GenerateSounds "French"

#>
function Invoke-LocalisationCheck {
    Param(
        [switch]$Log,

        [switch]$BuildNukeScript,

        [switch]$GenerateVcdUsage,
        [switch]$GenerateSoundUsage,
        [switch]$GenerateCaptions,
        [string]$GenerateSounds,
        [switch]$GenerateDialog,
        [string]$GenerateCsv,

        [Parameter(ParameterSetName='generatePhoneMe', Mandatory=$True)]
        [string]$GeneratePhoneMe,
        [Parameter(ParameterSetName='generatePhoneMe')]
        [switch]$ForcePhoneMe,

        [switch]$ExtractUnicode,
        [switch]$CheckUnicode,

        [switch]$ExtractEnglish,
        [string]$ExtractEnglishPath,
        [string]$ExtractEnglishDuck,

        [switch]$LoopCheck
    )

    $params = Resolve-ParamList @{
        "-v" = $Verbose;
        "-l" = $Log.IsPresent;
        "-u" = $GenerateVcdUsage.IsPresent;
        "-b" = $BuildNukeScript.IsPresent;
        "-s" = $GenerateSoundUsage.IsPresent;
        "-c" = $GenerateCaptions.IsPresent;
        "-r" = $GenerateSounds;
        "-x" = $GenerateDialog.IsPresent;
        "-w" = $GenerateCsv;
        "-e" = $GeneratePhoneMe;
        "-f" = $ForcePhoneMe.IsPresent;
        "-i" = $ExtractUnicode.IsPresent;
        "-d" = $CheckUnicode.IsPresent;
        "-p" = $ExtractEnglish.IsPresent;
        "-m" = $ExtractEnglishPath;
        "-a" = $ExtractEnglishDuck;
        "-loop" = $LoopCheck.IsPresent;
    }

    Invoke-SourceTool -Tool "localization_check.exe" -Parameters $params | Out-Null;
}