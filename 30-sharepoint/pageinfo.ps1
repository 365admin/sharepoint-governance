<#---
title: Page Info
input: pageinfo.request.json
output: pageinfo.response.json
api: post
tag: pageinfo
---

#>



$siteUrl = Get-Content (join-path $env:WORKDIR "pageinfo.request.json") | ConvertFrom-Json

$result = join-path $env:WORKDIR "pageinfo.response.json"
$siteUrl = $url.ToLower().Split("/sitepages/")

Connect-PnPOnline -Url $siteUrl[0]  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

$pageName = $siteUrl[1]
if ($null -eq $pageName) {
    $pageName = (Get-PnPHomePage).ToLower().Replace("sitepages/", "")
}

$listName = "Site Pages"
$items = get-pnplistitem -List $listName -Query "<View Scope='RecursiveAll'><Query><Where><Eq><FieldRef Name='FileLeafRef'/><Value Type='Text'>$pageName</Value></Eq></Where></Query></View>"
$versions = @()
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

$Owners = Get-PnPGroup -AssociatedOwnerGroup 
| Get-PnPGroupMember 
| Where-Object { $_.IsSiteAdmin -ne $true }  
| Select-Object Title, UserPrincipalName, Email
| Sort-Object Title

$siteInfo = @{
    page       = $pageName
    siteowners = $Owners 
    versions   = $versions

}
# | ConvertTo-Json  | Out-File -FilePath $result -Encoding utf8NoBOM
$siteInfo  | ConvertTo-Json  | Out-File -FilePath $result -Encoding utf8NoBOM
