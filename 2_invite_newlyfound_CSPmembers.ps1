################## Invite new guest users, add them to group and update their basic user profile properties

# Enter correct tenant ID here
# Connect-AzureAD -TenantId 544bc022-09a1-4846-ab3c-d329dad23be2

# Group ID for AAD group 1 for Ansprechpartner Admin members
$ad_group_id = '17a2333d-3b16-4e30-98e0-14b260a63bc3'

# Invite each user in Array and add them to group 1

foreach ($object in $ansprech_object_array) {
    # invite user per object in array
    $invitemail = $object.email
    New-AzureADMSInvitation -InvitedUserDisplayName "CSP-CC_$($object.firstname)_$($object.lastname)_$($object.company)" -InvitedUserEmailAddress $invitemail -InviteRedirectURL https://office.com -SendInvitationMessage $true
    # get their Azure AD user ID
    $ansprechuser_ad_id = (Get-AzureADUser -SearchString $object.email).ObjectId
    # add properties to user
    Set-AzureADUser -ObjectId $ansprechuser_ad_id -CompanyName $object.company -Surname $object.lastname -GivenName $object.firstname

    # add them to group 1
    Add-AzureADGroupMember -ObjectId $ad_group_id -RefObjectId $ansprechuser_ad_id

#TODO:
# 1) Pass on array of found user to this script (how to pass on values from different scripts?)
