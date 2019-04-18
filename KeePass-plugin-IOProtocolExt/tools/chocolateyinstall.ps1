$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = 'https://keepass.info/extensions/v2/ioprotocolext/IOProtocolExt-1.16.zip'
  checksum      = '54e63e56508db21c9f2e2f529721bfbbdad9ccbb5eebf0bb1129ab70070d64ee'
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
