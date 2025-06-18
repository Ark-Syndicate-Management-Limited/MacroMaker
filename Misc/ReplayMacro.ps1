 Add-Type -AssemblyName System.Windows.Forms
$code = @"

[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);
[DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);

"@
Add-Type -MemberDefinition $code -Name User32 -Namespace Win; 

 #50 51 48 53
 function Send-LeftClick {
     #$a = Test-Connection -TargetName localhost -Count 2
     [Win.User32]::mouse_event(0x0002,0,0,0,0)
     [Win.User32]::mouse_event(0x0004,0,0,0,0); 
 }
 
 
 function Send-RightClick {
    
    
     [Win.User32]::mouse_event(0x0008,0,0,0,0)
     [Win.User32]::mouse_event(0x0010,0,0,0,0); 
 }
 
function Decode-KeyPress {
    param(
        [byte]$keyCode
    )
    return [char]$KeyCode
}
 
function Test-AltKey {
    $key = 16

      [bool]([Win.User32]::GetAsyncKeyState($key) -eq -32767)
}
 function Start-MacroReplay
 {
    param(
        [string]$macroRecordingPath
    )

    #[Win.User32]::mouse_event(0x0002,
    $enc = [system.Text.Encoding]::UTF8
    $Last_pos_X = 0
    $Last_pos_Y = 0
    
    foreach($line in Get-Content -Path $macroRecordingPath) {
        
        #read and split recorded macro
        $Line_parts = $line.Split(" 69 69 69  ")
        $Mouse_pos_X  = [System.Windows.Forms.Cursor]::Position.X = $Line_parts[0]
        $Mouse_pos_Y = [System.Windows.Forms.Cursor]::Position.Y = $Line_parts[1]

        
        
        $Mouse_click_Left = $Line_parts[2] # Left Mouse Button detection
        $Mouse_click_Right = $Line_parts[3] # Right Mouse Button detection
        $Keyboard_KeyPressedCode = $Line_parts[4] #this contains the key pressed to replicate 
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($Mouse_pos_X,$Mouse_pos_Y) #set mouse pos(x,y)
        
        if($Keyboard_KeyPressedCode)
        {
            [char]$key = Decode-KeyPress($Keyboard_KeyPressedCode)
            Write-Host $key
        }

        #exit if shift pressed 
        $pressed = Test-AltKey
        if ($pressed) { break }
       
       # if left mouse click has been recorded, replay the click 
        if($Mouse_click_Left -eq '-32768')
        {
           Start-Sleep -Milliseconds 200
           Send-LeftClick($Mouse_pos_X,$Mouse_pos_Y)
           Write-Output "Left Click"
        }
        # if right mouse click has been recorded, replay the click 
        elseif ($Mouse_click_Right -eq '-32768') {
            Start-Sleep -Milliseconds 200
            Send-RightClick($Mouse_pos_X,$Mouse_pos_Y)
            Write-Output "Right Click"
        }
       
        # update previous pos(x,y)
      $Last_pos_X = [System.Windows.Forms.Cursor]::Position.X 
      $Last_pos_Y = [System.Windows.Forms.Cursor]::Position.Y
    }
    
    
 }



$path = $args[0]

 #$path = "MarkNDRProcessed.psm"
 Start-MacroReplay($path)