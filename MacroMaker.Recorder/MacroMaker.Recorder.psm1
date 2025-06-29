import-module -Name 'MacroMaker.Keyboard'
import-module -Name 'MacroMaker.Mouse'

function Start-MacroRecording
{
    param
    (
        [String]$MacroRecordingName
    )
    
    $MacroRecordingFile = New-Item -Path $MacroRecordingName -ItemType "File" -Force
    Write-Host $MacroRecordingFile

    do{

        $mousePos_X = Get-MousePosX
        $mousePos_Y = Get-MousePosY
        $mouseLeftState = Get-MouseLeftState
        $mouseRightState = Get-MouseRightState
        $keyboardKeyPressed = Get-KeyPressed
        if($keyboardKeyPressed -eq 220 )
        {
            break;
        }
        
        $MacroLogLine = Add-Content -Path $MacroRecordingFile -Value "{$mousePos_X|$mousePos_Y|$mouseLeftState|$mouseRightState|$keyboardKeyPressed}"
        
    }
    while($true)

    return $MacroRecordingFile

}



function Stop-MacroRecording 
{
    return 0
}

Export-ModuleMember -Function "Start-MacroRecording" -Cmdlet "Start-MacroRecording"
Export-ModuleMember -Function "Stop-MacroRecording" -Cmdlet "Stop-MacroRecording"
