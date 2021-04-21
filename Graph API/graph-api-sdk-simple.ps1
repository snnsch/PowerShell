Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

Write-Host ""

Get-MgUserJoinedTeam -UserId "abb7da13-25a2-42d0-b2dc-b54967bfa962"

# Zeig her, was du über Graph API im vorigen Artikel gemacht hast => Graph API get request mit Filter verwenden, Syntax ähnlich zu Explorer, 
# $user = Get-MgUser -Filter "surname eq 'Vance'"
# $user.DisplayName