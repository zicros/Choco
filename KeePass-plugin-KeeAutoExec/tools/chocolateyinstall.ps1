$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = 'https://keepass.info/extensions/v2/keeautoexec/KeeAutoExec-2.3.zip'
  checksum      = 'f088de5757997d0f9792b4c8ff974fa7de5948bc4027e32dce680c7405e4032c'
  checksumType  = 'sha256'
}

$chocoLibPath = Split-Path $ENV:ChocolateyPackageFolder
$keepassPath = Join-Path (Join-Path $chocoLibPath 'keepass') 'tools'

if (!(Test-Path $keepassPath))
{
    Write-Error "Unable to find KeePass install at $keepassPath"
}

$packageArgs.unzipLocation = Join-Path $keepassPath 'Plugins'

Install-ChocolateyZipPackage @packageArgs
