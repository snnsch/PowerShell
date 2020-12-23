# NOTES:
    # Delegate access => specific user accesses AND needs AZ delegate permissions
    # THIS: App access => app details (via AZ app) AND needs AZ app permissions

# AZURE: "Übersicht" > "Anwendungs-ID (Client)" // Application ID (which is the Client ID)
$clientID = 'xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)

# AZURE: "Zertifikate und Geheimnisse > Geheime Clientschlüssel > Wert"
$clientSecret = 'xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)

$TenantName = 'xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)
 
$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
} 

# Authentication request
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

Write-Host("AUTHENTICATION SUCCESSFULL")

# AUTH END

# WORKS: Get all groups BUT define group permissions in Azure first
<# $apiUrl = 'https://graph.microsoft.com/v1.0/Groups/'
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $apiUrl -Method Get
$Groups = ($Data | select-object Value).Value 
$Groups | Format-Table DisplayName, Description -AutoSize
#>

# GET specific user
$user = 'xx' # e.g. your Admin user
$getUserURI = 'https://graph.microsoft.com/v1.0/users/'+$user
$userData = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $getUserURI -Method GET
Write-Host("GetUserData",$userData)

# GET Teams user is a member of
$getUserJoinedTeamsURI = 'https://graph.microsoft.com/v1.0/users/'+$userData.id+'/joinedTeams'
$userJoinedTeamsData = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $getUserJoinedTeamsURI -Method Get

# Retrieve the UD of the first of the user's joined Teams
$teamId = $userJoinedTeamsData.value[0].id
$teamDisplayName = $userJoinedTeamsData.value[0].displayName

# GET channels of that team
$ChannelsOfTeamURI = 'https://graph.microsoft.com/v1.0/teams/'+$teamId+'/channels'
$ChannelsOfTeamsDATA = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $ChannelsOfTeamURI -Method GET

# Retrieve the ID of the first channel in that Team
$channelId = $ChannelsOfTeamsDATA.value[0].id
$channelName = $ChannelsOfTeamsDATA.value[0].displayName

# id = messages; MESSAGES: Pick and choose message type and replace variable in POST msg call

$helloWorld = '{
    "body": {
      "content": "Hello World"
    }
}'

$adaptiveCard = 
'{
    "body": {
         "contentType": "html",
         "content": "<attachment id=\"74d20c7f34aa4a7fb74e2b30004247c5\"></attachment>"
     },
    "attachments":[
       {
		  "id": "74d20c7f34aa4a7fb74e2b30004247c5",
          "contentType": "application/vnd.microsoft.card.adaptive",
          "contentUrl":null,
          "content": "{\"$schema\":\"http://adaptivecards.io/schemas/adaptive-card.json\",\"type\":\"AdaptiveCard\",\"version\":\"1.2\",\"body\":[{\"type\": \"TextBlock\",\"color\": \"good\",\"text\": \"This is text by Anna\",\"weight\": \"bolder\",\"wrap\": true}]}"
       }
    ]
}'

$htmlAndMoreMsg =
'{
    "subject": null,
    "body": {
        "contentType": "html",
        "content": "<attachment id=\"74d20c7f34aa4a7fb74e2b30004247c5\"></attachment>"
    },
    "attachments": [
        {
            "id": "74d20c7f34aa4a7fb74e2b30004247c5",
            "contentType": "application/vnd.microsoft.card.thumbnail",
            "contentUrl": null,
            "content": "{\r\n  \"title\": \"This is an example of posting a card\",\r\n  \"subtitle\": \"<h3>This is the subtitle</h3>\",\r\n  \"text\": \"Here is some body text. <br>\\r\\nAnd a <a href=\\\"http://microsoft.com/\\\">hyperlink</a>. <br>\\r\\nAnd below that is some buttons:\",\r\n  \"buttons\": [\r\n    {\r\n      \"type\": \"messageBack\",\r\n      \"title\": \"Login to FakeBot\",\r\n      \"text\": \"login\",\r\n      \"displayText\": \"login\",\r\n      \"value\": \"login\"\r\n    }\r\n  ]\r\n}",
            "name": null,
            "thumbnailUrl": null
        }
    ]
}'

Write-Host("Teamid:",$teamId,"Teamname",$teamDisplayName,"Channelid:",$channelId,"Channelname:",$channelName)

# POST Teams channel message, choose from "id = messages"
$TeamsChannelMsgURI = 'https://graph.microsoft.com/v1.0/teams/'+$teamId+'/channels/'+$channelId+'/messages'
$TeamsChannelMsgURI
Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"; 'content-type' = "application/json"} -Uri $TeamsChannelMsgURI -Method POST -Body $helloWorld
