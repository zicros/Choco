$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = 'https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.41/KeePass-2.41.zip/download'
  checksum      = 'b080c795976b2b9ecd24ae8c312a71d73dad9c11ad0def7c426ce1bce362efc8'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
