# Requires 7
### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com
### Version: 2020-08-03 Initial release

$VerbosePreference = 'continue'




# Read the INI file for the base configuration
$iniConfig = Get-ConfigInfo
Write-Output "Available config sections"
foreach ($key in $iniConfig.Keys) {
  Write-Output "    $key"
}

# Now build the Authorization header using the appropriate API Key from the config
$headers = @{
    "Authorization" = "Token " + $iniConfig.AMS.api_key
}

# Get a hash table of all current DDI related API URLs
# This example doesn't use any custom values
[hashtable]$h = Get-DDIUrls
[hashtable]$t1 = Get-DDIUrls -iniConfig $iniConfig #-iniSection "Sample"
#[hashtable]$t2 = Get-DDIUrls -iniConfig $iniConfig -iniSection "Sample" -cspBaseUrl "http://custom.csp.infoblox.com"


# Change these as necessary
$dhcpServers = $h.ipamUrl + "/dhcp/server”

# Get the object(s)
$serverList = Invoke-RestMethod -Method ‘Get’ -Uri $dhcpServers -Headers $headers

# Loop through the objects and display the name
for ($i=0; $i -lt $serverList.results.Length; $i++) {
    "#$i " + $serverList.results[$i].name
}

# Choose which section values we want to build the Url hashtable
[hashtable]$h1 = Get-DDIUrls $iniConfig.Sample.url $iniConfig.Sample.api_version
$url = $h1.ipamUrl
$url

Write-Output $iniConfig.Sample


# Get us back to the test directory
#Set-Location $testDir