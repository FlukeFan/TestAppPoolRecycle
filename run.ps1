
# Clean up
Remove-Website -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-WebAppPool -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-Item RecycleApp -Recurse -ErrorAction Ignore

dotnet new web -o RecycleApp
dotnet publish RecycleApp
$appPool = New-WebAppPool -Name TestAppPoolRecycle
$appPool.recycling.disallowOverlappingRotation = "true"
$appPool | Set-Item
