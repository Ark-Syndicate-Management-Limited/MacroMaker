Add-Type -AssemblyName System.Windows.Forms

$user32Imports = @"
[DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
"@
Add-Type -MemberDefinition $user32Imports -Name User32 -Namespace Win; 

function Get-MousePosX
{
    return [System.Windows.Forms.Cursor]::Position.X
}

function Get-MousePosY
{
    return [System.Windows.Forms.Cursor]::Position.Y
}

function Get-MouseLeftState()
{
    
    return [Win.User32]::GetAsyncKeyState(0x1) ? "LCLICK" : "NONE"
}


function Get-MouseRightState()
{
    return [Win.User32]::GetAsyncKeyState(0x2) ? "RCLICK" : "NONE"
}




Export-ModuleMember -Function Get-MousePosX -Cmdlet "Get-MousePosX"
Export-ModuleMember -Function Get-MousePosY -Cmdlet "Get-MousePosY"
Export-ModuleMember -Function Get-MouseLeftState -Cmdlet "Get-MouseLeftState"
Export-ModuleMember -Function Get-MouseRightState -Cmdlet "Get-MouseRightState"
