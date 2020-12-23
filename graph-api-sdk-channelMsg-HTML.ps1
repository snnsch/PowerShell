# NOTES: 
    # Uses PowerShell SDK "MgGraph" for Graph API calls and request handling; 
    # Very cool but not production-ready yet => follow updates in documentation, e.g.: https://github.com/microsoftgraph/msgraph-sdk-powershell/tree/dev/samples

# (1) Set permissions for following actions => this would normally need to be done in Azure => VERY CONVENIENT (check needed permissions in Graph Explorer)
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

# (2) Get specific user and id
$user = Get-MgUser -Filter "DisplayName eq '<DISPLAY_NAME>'"
#Write-Output("Teamuser ID:",$user.id)
Write-Output("Displayname:",$user.DisplayName)

# (3) Get Team to post in
$team = Get-MgUserJoinedTeam -UserId $user.id -Filter "DisplayName eq '<TEAM_DISPLAY_NAME>'"
#Write-Output("Team-ID:",$team.id)

# (4) Get channel to post in
$channel = Get-MgTeamChannel -TeamId $team.id -Filter "DisplayName eq '<CHANNEL_DISPLAY_NAME>'"
#Write-Output("Channel-ID:",$channel.id)

# (5) Create user mention item for channel mentioning
$UserToMention  = @{
    Id = $User.Id;
    DisplayName = $User.DisplayName;
    #UserIdentityType = "aadUser"; #optional
}

# Compose BASIC Teams channel message
# New-MgTeamChannelMessage -TeamId $team.id -ChannelId $channel.id -Body @{ Content="Hello World"}

# Compose ADVANCED message - HTML with style + mention Teams message (surround with '') => #TODO: DOES NOT show in "activity"

New-MgTeamChannelMessage -ChannelId $channel.id -TeamId $team.Id `
    -Body @{ `
        ContentType = 'html'; `
        Encoding = 'UTF8'; ` #TODO: added this manually to fix UTF8 encoding, doesn't work, umlauts and this 🤣 won't display properly
        Content = 'Hello there! <h1 style="background-color:powderblue;"> Hell yeah, well done <at id="1">'+ $user.DisplayName +'</at> !!! </h1>' `
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