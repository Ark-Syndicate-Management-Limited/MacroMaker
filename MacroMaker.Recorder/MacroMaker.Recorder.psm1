import-module -Name 'MacroMaker.Keyboard'

function Start-MacroRecording
{
    param
    (
        [String]$MacroRecordingName
    )
    if(Get-KeyPressed -eq '\')
    {
        $MacroRecordingFile = New-Item -Path $MacroRecordingName -ItemType "File" -Force
        Write-Host $MacroRecordingFile

        return $MacroRecordingFile
    }
}



function Stop-MacroRecording 
{
    return 0
}