$keepass_dl_url = 'https://keepass.info/download.html'
$keepass_dl_page = Invoke-WebRequest -Uri $keepass_dl_url -UseBasicParsing

$keepass_file_regex = 'https://sourceforge.net/projects/keepass/files/KeePass%20\d+.x/(?<version>\d+\.\d+(\.\d+){0,1})/KeePass-\d+\.\d+(\.\d+){0,1}.zip'

$version = $matches.version

# KeePass has 2 versions, a 2.x and a 1.x. The first match will always be the 2.x one.
$keepass_dl_link = $keepass_dl_page.links | Where-Object -Property href -Match $keepass_file_regex | Select-Object -First 1
$dl_uri = [System.Uri]$keepass_dl_link.href

$updateParams = Get-UpdateParams($dl_uri)
$updateParams['version'] = $version

return $updateParams
