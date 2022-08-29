
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

$Host.UI.RawUI.WindowTitle = 'TestAppPoolRecycle (Admin)'

$env:DOTNET_CLI_TELEMETRY_OPTOUT = 'true'
$env:Path = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\;${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Common7\IDE\;${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\;" + $env:Path
$env:Path = 'C:\Program Files\dotnet\;' + $env:Path

function sln  { devenv TestAppPoolRecycle.sln }

echo ""

"sln = $function:sln"
