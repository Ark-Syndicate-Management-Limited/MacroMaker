
Add-Type -TypeDefinition '
    using System;
    using System.IO;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    using System.Windows.Forms;
    namespace MacroMaker 
    {
        public static class Program 
        {
                [DllImport("kernel32.dll")] 
                public static extern IntPtr GetModuleHandle(string lpModuleName);
                [DllImport("user32.dll")] 
                public static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
                [DllImport("user32.dll")] 
                public static extern bool UnhookWindowsHookEx(IntPtr hhk);
                [DllImport("user32.dll")] 
                public static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);
                abstract public static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam);


                public const int WH_KEYBOARD_LL =13;
                public const int WH_KEYDOWN = 0x0100;


                public static HookProc ProcessHook = HookCallBack;
                public static IntPtr HookId = IntPtr.Zero;
                public static int KeyCode = 0;
                
                
                public static int WaitForKey() 
                {
                    HookId = SetHook(ProcessHook);
                    Application.Run();
                    UnhookWindowsHookEx(HookId);
                    return KeyCode;
                }

                public static IntPtr SetHook(HookProc ProcessHook) 
                {
                    IntPtr ModuleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
                    return SetWindowsHookEx(WH_KEYBOARD_LL, ProcessHook, ModuleHandle, 0);
                }
                
                public delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);
                IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) 
                {
                    if(nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) 
                    {
                        keyCode = Marshal.ReadInt32(lParam);
                        Application.Exit();
                    }
                    return CallNextHook(HookId, nCode, wParam, lParam);   
                }    
        } 
            
    }
     
' -ReferencedAssemblies System.Windows.Forms


function Get-KeyPressed {
    $key = [System.Windows.Forms.Keys][MacroMaker.Program]::WaitForKey()
    Write-Host $key
    return $key
}


Export-ModuleMember -Function "Get-KeyPressed" -Cmdlet "Get-KeyPressed"