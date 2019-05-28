$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. (Join-Path $toolsDir files.ps1)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $fileUrl
  checksum      = $fileChecksum
  checksumType  = $fileChecksumType
}

Install-ChocolateyZipPackage @packageArgs
