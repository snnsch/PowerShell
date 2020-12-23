# NOTES:
    # THIS: Delegate access => specific user accesses AND needs AZ delegate permissions
    # App access => app details (via AZ app) AND needs AZ app permissions

# TODO:
    # Continue work on messages => more interactive (e.g. user pick and trigger action?)
    # Make choice of user / team / channel more flexible (e.g. Read-Host)
    # Authentication request (and others) => try/catch

################## AUTH START

# AZURE: "Übersicht" > "Anwendungs-ID (Client)" // Application ID (which is the Client ID)
$clientID = 'xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)

# AZURE: "Zertifikate und Geheimnisse > Geheime Clientschlüssel > Wert"
$clientSecret = 'xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)

$TenantName = "xx" # "GraphAPI-DelegateUser-PS1" (Password Safe)

# TODO: TRY THIS USER AGAIN after 24h refresh in AzureAD
#$Username='xx' # "GraphAPI-DelegateUser-PS1" (Password Safe)
#$Password='xx' # PW

$username='xx' # enter e.g. Admin user name
$password='xx' # PW

$ReqTokenBody = @{
    Grant_Type    = "Password"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
    Username      = $username
    Password      = $password
} 

# Authentication request
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

Write-Host("AUTHENTICATION SUCCESSFULL")

################## AUTH END

# GET specific user
$UserURI = 'https://graph.microsoft.com/v1.0/users/'+$username
$getUserData = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $UserURI -Method GET
Write-Host("GetUserData",$getUserData)

# GET Teams user is a member of
$UserJoinedTeamsURI = 'https://graph.microsoft.com/v1.0/users/'+$getUserData.id+'/joinedTeams'
$getUserJoinedTeamsData = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $UserJoinedTeamsURI -Method GET

Write-Host("Teams of User", $getUserJoinedTeamsData)

# Retrieve the UD of the first of the user's joined Teams
$teamId = $getUserJoinedTeamsData.value[0].id
$teamDisplayName = $getUserJoinedTeamsData.value[0].displayName

# GET channels of that team
$ChannelsOfTeamURI = 'https://graph.microsoft.com/v1.0/teams/'+$teamId+'/channels'
$getChannelsOfTeamsData = Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $ChannelsOfTeamURI -Method GET

# Retrieve the ID of the first channel in that Team
$channelId = $getChannelsOfTeamsData.value[0].id
$channelName = $getChannelsOfTeamsData.value[0].displayName

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
