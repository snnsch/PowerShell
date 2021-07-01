# TODO CSP BLOG (3 more articles?)
# (6) Graph API PowerShell SDK - Teil 6: dem Post eine @mention-Erwähnung mitzugeben
# (7) Graph API PowerShell SDK - Teil 7: die Farbauswahl im Post auf eine zufällig gewählte Farbe zu setzen
# (8) Graph API PowerShell SDK - Teil 8: die Team- und Kanalauswahl ebenfalls zu "randomizen" 

# Snippets aus fertigem Code für die letzten 3 Blog-Artikel, das "fertige" aus den letzten Artikeln ganz weit unten:


################# (8) Random team and channel

# Get random team (genau anschauen)
function Get-Random-Team-ID {
    $all_joined_teams = Get-MgUserJoinedTeam -UserId $user.id
    $first_random_team = $all_joined_teams | Select-object -Property id -First 1
    Write-Output "Random Team ID: $($first_random_team.id)"
    return $first_random_team.id
}

# call function, sadly returns weird array where content is only in [1] so need to access that
$teamid_array = Get-Random-Team-ID
$teamid = $teamid_array[1]
Write-Output "Chosen Team ID: $teamid"

# Get random channel (schaut simpler aus, braucht function nicht wirklich!!! model the same)

$all_channels = Get-MgTeamChannel -TeamId $teamid
$first_random_channel = $all_channels | Select-object -Property id -First 1
Write-Output("Channel-ID: $($first_random_channel.id)")
$channelid = $first_random_channel.id

#######################################################
# DAS WAR ZULETZT IN TEIL 5 IM CSP CC BLOG (8 Jun)


# Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

# (1) Get specific user and id
$ENTER_USER = 'anna-admin@M365x425026.onmicrosoft.com'
$user_id = (Get-MgUser -Filter "mail eq '$ENTER_USER'").id
#$user_id

# (2) Get Team to post in
$team_id = (Get-MgUserJoinedTeam -UserId $user.id | Select-object -Property DisplayName, Id | Where-Object DisplayName -eq "aweninger-outlook").id
#$team_id

# (3) Get "General" channel ID for this team
$channel_id = (Get-MgTeamChannel -TeamId $team_id -Filter "DisplayName eq 'General'").id
#$channel_id

# (4) Post in Teams
New-MgTeamChannelMessage -ChannelId $channel_id -TeamId $team_id `
    -Body @{ `
        ContentType = 'html'; `
        Content = '<h1 style="background-color:pink"> WELL DONE, YOU! </h1> </br> Successfully posted in Teams!' `
    } `
