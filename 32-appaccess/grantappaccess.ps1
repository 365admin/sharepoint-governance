<#---
title: Grant App Access
connection: sharepoint
api: post
tag: appaccess
output: applicationgrant.json
---#>

param (
    $siteUrl = "https://christianiabpos.sharepoint.com/sites/NordicTerminalEstateManagementNetsGroup",
    $role = "read",
    $appId = "b47e1ffb-e856-4759-9117-d1a1b0504b50"

)

function FindSiteIdByUrl($token, $siteUrl) {
    $Xheaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Xheaders.Add("Content-Type", "application/json")
    $Xheaders.Add("Prefer", "apiversion=2.1") ## Not compatibel when reading items from SharePointed fields 
    $Xheaders.Add("Authorization", "Bearer $token" )

    $url = 'https://graph.microsoft.com/v1.0/sites/?$top=1'
    $topItems = Invoke-RestMethod $url -Method 'GET' -Headers $Xheaders 
    if ($topItems.Length -eq 0) {
        Write-Warning "Cannot read sites from Office Graph - sure permissions are right?"
        exit
    }
    $siteUrl = $siteUrl.replace("sharepoint.com/", "sharepoint.com:/")
    $siteUrl = $siteUrl.replace("https://", "")

    $Zheaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Zheaders.Add("Content-Type", "application/json")
    $Zheaders.Add("Authorization", "Bearer $token" )
    

    $url = 'https://graph.microsoft.com/v1.0/sites/' + $siteUrl 

    $site = Invoke-RestMethod $url -Method 'GET' -Headers $Zheaders 
   

    return  $site.id
}
function GraphAPI($token, $method, $url, $body) {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $token" )
    
    
    $errorCount = $error.Count
    $result = Invoke-RestMethod ($url) -Method $method -Headers $headers -Body $body
    if ($errorCount -ne $error.Count) {
        Write-Error $url
    }

    return $result

}
<#
.description
Read from Graph and follow @odata.nextLink
.changes
v1.03 Removed -Body from Invoke-RestMethod
#>
function GraphAPIAll($token, $method, $url) {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $token" )
    
    $errorCount = $error.Count
    $result = Invoke-RestMethod ($url) -Method $method -Headers $headers 
    if ($errorCount -ne $error.Count) {
        Write-Error $url
    }


    $data = $result.value
    $counter = 0
    while ($result.'@odata.nextLink') {
        Write-Progress -Activity "Reading from GraphAPIAll $path" -Status "$counter Items Read" 

        if ($hexatown.verbose) {
            write-output "GraphAPIAll $($result.'@odata.nextLink')"
        }
        $result = Invoke-RestMethod ($result.'@odata.nextLink') -Method 'GET' -Headers $headers 
        $data += $result.value
        $counter += $result.value.Count
        
    }

    return $data

}




if ($null -eq $env:WORKDIR ) {
    $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
    New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir


#$site | Set-Clipboard
#write-host $site
$env:GRAPH_ACCESSTOKEN = Get-PnPAccessToken
$siteId = FindSiteIdByUrl $env:GRAPH_ACCESSTOKEN $siteUrl

$body = @"
{
  "roles": ["$role"],
  "grantedToIdentities": [{
    "application": {
      "id": "$appId",
      "displayName": "Foo App"
    }
  }]
}
"@

$result = GraphAPI $env:GRAPH_ACCESSTOKEN "POST" "https://graph.microsoft.com/beta/sites/$siteId" $body



$output = @{
    siteUrl = $siteUrl
    role    = $role
    appid   = $appId
    result  = $result
}
$output  | ConvertTo-Json -Depth 10 | Out-File -FilePath (join-path $workdir "applicationgrant.json") -Encoding utf8NoBOM
