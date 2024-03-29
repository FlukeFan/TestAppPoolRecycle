
$ErrorActionPreference = "SilentlyContinue"

# Clean up
Remove-Website -Name TestAppPoolRecycle
Remove-WebAppPool -Name TestAppPoolRecycle
Remove-Item RecycleApp -Recurse

$ErrorActionPreference = "Stop"

# build a default app
dotnet new web -o RecycleApp
copy web.config RecycleApp
dotnet publish RecycleApp

# create a website where the pool has disabled overlapping rotation
$appPool = New-WebAppPool -Name TestAppPoolRecycle
$appPool.recycling.disallowOverlappingRotation = "true"
$appPool.processModel.shutdownTimeLimit = [TimeSpan]::FromSeconds(13)
$appPool | Set-Item
New-Website -Name TestAppPoolRecycle -ApplicationPool TestAppPoolRecycle -Port 8089 -PhysicalPath "$(Get-Location)\RecycleApp\bin\Debug\net6.0\publish"

# measure startup
$startupTime = Measure-Command -Expression { Invoke-WebRequest -URI http://localhost:8089 -TimeoutSec 120 }
Write-Host "Took $($startupTime.TotalMilliseconds)ms to startup"

For ($i=0; $i -le 10; $i++) {
    # recycle the pool
    Restart-WebAppPool TestAppPoolRecycle

    # without sleep, the site fails with "503.0 - Service Unavailable" - which doesn't seem correct?
    # Start-Sleep -milliseconds 200

    # measure time after recycle
    $startupAfterRecycleTime = Measure-Command -Expression { Invoke-WebRequest -URI http://localhost:8089 -TimeoutSec 120 }
    Write-Host "Took $($startupAfterRecycleTime.TotalMilliseconds)ms to startup after recycle"
}
