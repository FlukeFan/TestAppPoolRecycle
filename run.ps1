
# Clean up
Remove-Website -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-WebAppPool -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-Item RecycleApp -Recurse -ErrorAction Ignore

# build a default app
dotnet new web -o RecycleApp
dotnet publish RecycleApp

# create a website where the pool has disabled overlapping rotation
$appPool = New-WebAppPool -Name TestAppPoolRecycle
$appPool.recycling.disallowOverlappingRotation = "true"
$appPool | Set-Item
New-Website -Name TestAppPoolRecycle -ApplicationPool TestAppPoolRecycle -Port 8089 -PhysicalPath "$(Get-Location)\RecycleApp\bin\Debug\netcoreapp3.1\publish"
