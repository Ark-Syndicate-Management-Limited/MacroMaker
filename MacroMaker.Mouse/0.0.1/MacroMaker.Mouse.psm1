Add-Type -AssemblyName System.Windows.Forms


function Get-MousePos
{
    $posX = [System.Windows.Forms.Cursor]::Position.X
    $posY = [System.Windows.Forms.Cursor]::Position.Y
    return "{" + $posX + ":"+ $posY + "}"
}