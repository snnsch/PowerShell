# Link to Teams Sharepoint site
$adminURL = <YOUR URL>
# Teams connectors - webhook URI
$connectorUri = <YOUR WEBHOOK URI>

#Connect-PnPOnline -Url $adminURL -UseWebLogin
Connect-PnPOnline –Url $adminURL –Credentials (Get-Credential)

# replace with dynamic content
$content = @('Anna Weninger','Other Person1','Other Person2','Elliott Schmietz')

# temp variable to build json for Teams 
$usertextstring = ''

foreach ($user in $content) {
    $usertextstring += $user
    $usertextstring += "</br>"
}

# put together valid json + add color
$body = '{"text":"' + $usertextstring + '", "color": "good"}'
$body

$adaptiveCard = '{
    "type":"message",
    "attachments":[
       {
          "contentType":"application/vnd.microsoft.card.adaptive",
          "contentUrl":null,
          "content":{
             "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
             "type":"AdaptiveCard",
             "version":"1.2",
             "body":[
                 {
                 "type": "TextBlock",
                 "color": "warning",
                 "text": "'+$usertextstring+'",
                 "weight": "bolder",
                 "wrap": true
                 }
             ]
          }
       }
    ]
 }'

# send json to Teams via webhook
Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body $adaptiveCard -ContentType 'application/json'

#ToDo: </br> is only recognized for basic API, not adaptive card => replace by adaptive card </br> equivalent
