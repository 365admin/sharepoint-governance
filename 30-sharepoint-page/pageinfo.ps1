<#---
title: Page Info
description: Get information about a SharePoint page and the site it is located on
output: pageinfo.response.json
connection: sharepoint
api: post
tag: info
---

## Step 1: Connect to the site in context
#>


param (
    $url = "https://christianiabpos.sharepoint.com/sites/nexiintra-home"
)
    

$result = join-path $env:WORKDIR "pageinfo.response.json"

$url = $url.Split("?")[0]
$siteUrl = $url.ToLower().Split("/sitepages/")

koksmat trace log 'Connecting to SharePoint...'
Connect-PnPOnline -Url $siteUrl[0]  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

<#
## Step 2: Find page information from the Site Pages list 
#>

$pageName = $siteUrl[1]
if ($null -eq $pageName) {
    $pageName = (Get-PnPHomePage).ToLower().Replace("sitepages/", "")
}

koksmat trace log "Quering pages..."
$listName = "Site Pages"
$items = get-pnplistitem -List $listName -Query "<View Scope='RecursiveAll'><Query><Where><Eq><FieldRef Name='FileLeafRef'/><Value Type='Text'>$pageName</Value></Eq></Where></Query></View>"
[array]$versions = @()
foreach ($item in $items) {
    # $version = Get-PnPListItemVersion -List $listName -Identity $item.Id | Select-Object -First 3 | Select-Object -Property VersionId, VersionLabel, VersionCreationDate, Editor, Modified, Title, FileLeafRef, FileDirRef, FileRef, Author, AuthorLookupId, EditorLookupId, CheckoutUserId, CheckoutUser, CheckoutUserLookupId, CheckoutDate, CheckinComment, IsCurrentVersion, IsDraftVersion, IsMajorVersion, IsMinorVersion, IsApprovedVersion, IsApproverComments
    $versions += @{
        page           = $item.FieldValues.FileLeafRef
        folder         = $item.FieldValues.
        language = $item.FieldValues._SPTranslationLanguage
        isTranslation  = $item.FieldValues._SPIsTranslation
        lastModified   = $item.FieldValues.Modified
        lastModifiedBy = $item.FieldValues.Editor.Email
    }
}

<#
## Step 3: Get members of the Owners group
#>
koksmat trace log "Getting owners ..."
[array]$Owners = Get-PnPGroup -AssociatedOwnerGroup 
| Get-PnPGroupMember 
| Where-Object { $_.IsSiteAdmin -ne $true }  
| Select-Object Title, UserPrincipalName, Email
| Sort-Object Title

$siteInfo = @{
    page       = $pageName
    siteowners = $Owners 
    versions   = $versions

}

<#
## Step 4: Store the result in a file with a wellknown name
#>
$siteInfo  | ConvertTo-Json  | Out-File -FilePath $result -Encoding utf8NoBOM
koksmat trace log "Done"