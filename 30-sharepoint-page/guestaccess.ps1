<#---
title: Guest Access
output: pageiguestaccessnfo.response.json
connection: sharepoint
api: post
tag: guestaccess
status: draft
---

## Step 1: Connect to the site in context
#>


param (
    $siteUrl = "https://christianiabpos.sharepoint.com/sites/1000136-hub"
)
    

$result = join-path $env:WORKDIR "guestaccess.response.json"

koksmat trace log 'Connecting to SharePoint...'
Connect-PnPOnline -Url $siteUrl  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"



koksmat trace log "Querying site users ..."
$Web = Get-PnPWeb
  
#Get All users who have permission to the subsite 
$siteInfo = Get-PnPUser -WithRightsAssigned # -Web $Web

koksmat trace log "Reading Guest item list ..."

$users = $siteInfo  | select  UserPrincipalName, Title, Email, IsShareByEmailGuestUser | Where-Object { $_.IsShareByEmailGuestUser -eq $true } #| ConvertTo-Json  | Out-File -FilePath $result -Encoding utf8NoBOM

$listItems = Get-PnPListItem -List "Guests" 

$sharePointItems = @{

}

$currentUsers = @{

}
foreach ($listItem in $listItems) {

  
    $sharePointItems.Add($listItem.FieldValues.Title, @{
            id     = $listItem.FieldValues.ID
            values = $listItem.FieldValues
        })
    
}


foreach ($user in $users) {
  
    $currentUsers.Add($user.Email, $user)
}

foreach ($user in $users) {
    if ($sharePointItems.ContainsKey($user.Email)) {
        continue
    }
    koksmat trace log "Adding $($user.Email) ..."
    Add-PnPListItem -List "Guests" -Values @{
        "Title" = $user.Email
        "UPN"   = $user.UserPrincipalName
        #"AccountEnabled" = $user.AccountEnabled 
        #"UserState"      = $user.UserState
        #"UserType"       = $user.UserType
       
    
    } 
}

#TODO: Add a check to see if the user is already in the list - We will keep users for historical reasons
koksmat trace log "Done"

