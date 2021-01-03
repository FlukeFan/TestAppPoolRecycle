
# Clean up
Remove-Website -Name TestAppPoolRecycle -ErrorAction Ignore
Remove-Item RecycleApp -Recurse -ErrorAction Ignore

dotnet new web -o RecycleApp
dotnet publish RecycleApp
