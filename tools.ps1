function Get-Hash($uri)
{
    Write-Host "Download link: $($uri.AbsoluteUri)"

    # Sourceforge specifc
    $dl_page = Invoke-WebRequest $uri.AbsoluteUri

    $direct_link_regex = '<meta http-equiv="refresh".*use_mirror=(?<mirror>[^"]*)"'
    $dl_page.content.split([Environment]::NewLine) | Where-Object -FilterScript { $_ -Match $direct_link_regex } | Out-Null

    # Create the mirror link
    $project = $uri.Segments[2].TrimEnd('/')
    $file = ($uri.Segments[4..($uri.segments.Length - 2)] -Join '').TrimEnd('/')

    $abs_dl_path = '{0}://{1}.dl.sourceforge.net/project/{2}/{3}' -f $uri.Scheme,$matches.mirror,$project,$file

    Write-Host Downloading file from $abs_dl_path
    $temp_dl_path = Join-Path $ENV:TEMP $uri.Segments[-2].TrimEnd('/')
    Invoke-WebRequest $abs_dl_path -OutFile $temp_dl_path

    # Get the hash
    Write-Host Computing hash...
    $hash = Get-FileHash -Path $temp_dl_path -Algorithm SHA256

    Remove-Item $temp_dl_path

    return $hash
}

function Get-UpdateParams($uri)
{
    $hash = Get-Hash($uri)

    return @{
        file = $uri.AbsoluteUri
        checksum = $hash.Hash
        checksumType = 'sha256'
    }
}

