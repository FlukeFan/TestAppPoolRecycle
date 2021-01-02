
# Clean up first
Remove-Item App -Recurse -ErrorAction Ignore

dotnet new web -o App
