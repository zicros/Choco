$ErrorActionPreference = 'Stop';
$rootLocation = Get-Item "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

# Load helpers
. (Join-Path $rootLocation tools.ps1)

# Get all the update.ps1 scripts found in child paths of the root directory
$updateScripts = Get-ChildItem -Path $rootLocation -File -Recurse -Filter update.ps1

foreach ($updateScript in $updateScripts)
{
    # Ignore scripts in current directory
    $projectPath = $updateScript.Directory.FullName
    if ($projectPath -ne $rootLocation.FullName)
    {
        Write-Host "Updating $projectPath"
        $updateParams = Invoke-Expression $updateScript.FullName

        $filesScriptPath = Join-Path $projectPath 'tools\files.ps1'
        Write-Host "Updating $filesScriptPath"
        '$fileUrl = "{0}"' -f $updateParams.file | Out-File -Encoding utf8 $filesScriptPath
        '$fileChecksum = "{0}"' -f $updateParams.checksum | Out-File -Encoding utf8 $filesScriptPath -Append
        '$fileChecksumType = "{0}"' -f $updateParams.checksumType | Out-File -Encoding utf8 $filesScriptPath -Append

        # There's only one nuspec
        $nuspec = Get-ChildItem $projectPath -Filter *.nuspec
        Write-Host "Updating $($nuspec.FullName)"
        [Xml]$nuspecXml = Get-Content $nuspec.FullName
        $nuspecXml.package.metadata.version = $updateParams.version
        $nuspecXml.Save($nuspec.FullName)
    }
}


