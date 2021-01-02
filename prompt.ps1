
$thisScript = $MyInvocation.MyCommand.Path
$thisScriptFolder = Split-Path -Parent $thisScript
Set-Location $thisScriptFolder

# force admin prompt
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if (!$myWindowsPrincipal.IsInRole($adminRole)) {
    Start-Process powershell -Verb runAs -ArgumentList "-noexit -file ""$thisScript"""
    [System.Environment]::Exit(0)
}

$Host.UI.RawUI.WindowTitle = 'Prompt (Admin)'

echo "run run.ps1"
