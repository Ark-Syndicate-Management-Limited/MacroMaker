Add-Type -AssemblyName System.Windows.Forms
$user32 = @"
[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);
[DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
[DllImport("user32.dll")] public static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
[DllImport("user32.dll")] public static extern bool UnhookWindowsHookEx(IntPtr hhk);
[DllImport("user32.dll")] public static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);
"@

$kernel32 = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetModuleHandle(string lpModuleName);
"@
Add-Type -MemberDefinition $user32 -Name User32 -Namespace Win; 
Add-Type -MemberDefinition $kernel32 - Name Kernel32 -Namespace Win;

$enc = [system.Text.Encoding]::UTF8



function Test-AltKey {
    $key = 16

      [bool]([Win.User32]::GetAsyncKeyState($key) -eq "-32768")
}

function Start-MacroRecording
{
  

    $Mouse_pos_X = [System.Windows.Forms.Cursor]::Position.X
    $Mouse_pos_Y = [System.Windows.Forms.Cursor]::Position.Y
    $Mouse_click_Left = [Win.User32]::GetAsyncKeyState(0x1)
    $Mouse_click_Right = [Win.User32]::GetAsyncKeyState(0x2)

    if([Console]::KeyAvailable)
    {
        $key_pressed = [Console]::ReadKey($false)
       
    }
    [byte]$key = $key_pressed.Key   
    Write-Host "Pressed: $key"
    return "$Mouse_pos_X 69 69 69  $Mouse_pos_Y 69 69 69  $Mouse_click_Left 69 69 69  $Mouse_click_Right 69 69 69  $key"
    

    
}




$path = $args[0]


do
{
    $macro = Start-MacroRecording
    $pressed = Test-AltKey
    if ($pressed) { break }
    
    
    $macro | Add-Content -Path $path
    
    
} while ($true)