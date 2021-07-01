# Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

# (1) Get specific user and id
$ENTER_USER = 'anna-admin@M365x425026.onmicrosoft.com'
$user_id = (Get-MgUser -Filter "mail eq '$ENTER_USER'").id
#$user_id

# NOTE: not needed any more, replaced by random team
# (2) Get Team to post in
# $team_id = (Get-MgUserJoinedTeam -UserId $user_id | Select-object -Property DisplayName, Id | Where-Object DisplayName -eq "aweninger-outlook").id
#$team_id

# NOTE: not needed any more, replaced by random channel
# (3) Get "General" channel ID for this team
# $channel_id = (Get-MgTeamChannel -TeamId $team_id -Filter "DisplayName eq 'General'").id
#$channel_id

$global_team_id = ''

    # Hole alle Teams, in denen der User Mitglied ist
    $all_joined_teams = Get-MgUserJoinedTeam -UserId $user.id
    # Zähle die Anzahl all dieser Teams
    $number_of_teams = ($all_joined_teams.Count) + 1 # increase by 1 for maximum in random range cmdlet
    # Finde eine Zufallszahl zwischen 0 und der Anzahl der Teams für einen Suchindex
    $random_team_index = Get-Random -Minimum 0 -Maximum $number_of_teams
    # Suche ein Team mit dem Suchindex
    $random_team = $all_joined_teams | Select-object -Index $random_team_index
    # Gib die Team-ID für Debugging-Zwecke aus
    Write-Output "Random Team-ID: $($random_team.id)"
    $global_team_id = $random_team.id

$global_channel_id = ''

    # Hole alle Kanäle des gewählten Zufallsteams
    $all_channels = Get-MgTeamChannel -TeamId $global_team_id
    # Nimm den ersten Channel des Kanals ('General')
    $first_random_channel = $all_channels | Select-object -Property id -First 1
    Write-Output("Random Channel-ID: $($first_random_channel.id)")
    $global_channel_id = $first_random_channel.id

# (4) Post in Teams

$bgcolors = @('#cfcdf7','#cfcdf7','#dedc8c', '#de9c76', '#8b8b94', '#d6b8e6', '#e6b8ce')
$randomcolor = $bgcolors | Get-Random

$UserToMention  = @{
    Id = $User.Id;
    DisplayName = $User.DisplayName;
}

New-MgTeamChannelMessage -ChannelId $global_channel_id -TeamId $global_team_id `
    -Body @{ `
        ContentType = 'html'; `
        Content = '<h1> WELL DONE, YOU! </h1> </br> <p style="padding:10px; font-weight:bold; background-color:'+$randomcolor+'"> Hello <at id="1">'+ $user.DisplayName +'</at> ! </p>' `
    } `
    -Mentions @( `
        @{ `
            id = 1; `
            mentionText = $UserToMention.DisplayName; `
            mentioned = @{ `
                user = $UserToMention `
            } `
        }
    )

