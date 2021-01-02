
# Clean up
Remove-Website -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-Item App -Recurse -ErrorAction Ignore

dotnet new web -o App
dotnet publish App
