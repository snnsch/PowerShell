# NOTES FOR BLOG ARTICLES:
# a) V1 of this script (retrieve via GitHub) is very useful as a first article, V2 (30 Mar) as second one
# Concept for articles: (a) connecting to GraphAPI via PowerShell SDK, (b) debugging values using Graph Explorer, (c) posting for a fixed user, (d) Team and channel without mention, (5) posting with random team and channel, (6) creating mention, (7) styling output


# NOTES: 
    # Uses PowerShell SDK "MgGraph" for Graph API calls and request handling; 
    # Very cool but not production-ready yet => follow updates in documentation, e.g.: https://github.com/microsoftgraph/msgraph-sdk-powershell/tree/dev/samples

# (1) Set permissions for following actions => this would normally need to be done in Azure => VERY CONVENIENT (check needed permissions in Graph Explorer)
# Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

# (2) Get specific user and id
$ENTER_USER = 'anna-admin@M365x425026.onmicrosoft.com'
$user = Get-MgUser -Filter "mail eq '$ENTER_USER'"
Write-Output("Chosen User ID: $($user.id)")
Write-Output("Displayname: $($user.DisplayName)")

# (3) Get Team to post in
# $team = Get-MgUserJoinedTeam -UserId $user.id -Filter "DisplayName eq 'aweninger-outlook'" ///OLD
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

# (4) Get channel to post in
$all_channels = Get-MgTeamChannel -TeamId $teamid
$first_random_channel = $all_channels | Select-object -Property id -First 1
Write-Output("Channel-ID: $($first_random_channel.id)")
$channelid = $first_random_channel.id

# (5) Create user mention item for channel mentioning
$UserToMention  = @{
    Id = $User.Id;
    DisplayName = $User.DisplayName;
    # UserIdentityType = "aadUser"; #optional
}

# Compose BASIC Teams channel message
# New-MgTeamChannelMessage -TeamId $team.id -ChannelId $channel.id -Body @{ Content="Hello World"}

# Compose ADVANCED message - HTML with style + mention Teams message (surround with '') => #TODO: DOES NOT show in "activity"

# Enter colour name for bg color of message
$bgcolors = @('Aqua','Aquamarine','Chartreuse', 'DeepPink', 'Gold', 'Indigo', 'SlateBlue')
$randomcolor = $bgcolors | Get-Random

New-MgTeamChannelMessage -ChannelId $channelid -TeamId $teamid `
    -Body @{ `
        ContentType = 'html'; `
        Encoding = 'UTF8'; ` #TODO: added this manually to fix UTF8 encoding, doesn't work, umlauts and this 🤣 won't display properly
        Content = '<h1> WELL DONE, YOU! </h1> </br> <p style="padding:10px; font-weight:bold; background-color:'+$randomcolor+'"> Successfully posted in Teams, <at id="1">'+ $user.DisplayName +'</at> ! </p>' `
    } `
    -Mentions @( `
        @{ `
            id = 1; `
            mentionText = $user.DisplayName; `
            mentioned = @{ `
                user = $UserToMention `
            } `
        }
    )