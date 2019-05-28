$rootLocation = Get-Item "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageStorePath = Join-Path $rootLocation 'Packages'

# Get the package location or create the folder if it doesn't exist.
# Get-Item isn't really necessary, but trying to keep everything to use objects
# rather than strings.
if (Test-Path $packageStorePath)
{
    $packageStoreLocation = Get-Item $packageStorePath
}
else
{
    $packageStoreLocation = New-Item $packageStorePath
}

Write-Host "Packages will be stored in $($packageStoreLocation.FullName)"

# Get all the nuspecs found in child paths of the root directory
$nuspecs = Get-ChildItem -Path $rootLocation -File -Recurse -Filter *.nuspec

foreach ($nuspec in $nuspecs)
{
    # Ignore scripts in current directory
    if ($nuspec.Directory.FullName -ne $rootLocation.FullName)
    {
        Write-Host "Building $($nuspec.FullName)"
        choco pack $nuspec.Fullname --out $packageStoreLocation.FullName
    }
}

