$adminURL ="https://m365x425026-admin.sharepoint.com"
$connectorUri = 'https://outlook.office.com/webhook/8aba3d8f-7014-469e-96be-a3a8bcc25ef6@544bc022-09a1-4846-ab3c-d329dad23be2/IncomingWebhook/8b717eb61b50439da88446b123d05786/3422ada9-b5a0-4ef0-958d-a02ee3f9c0b9'

#Connect-PnPOnline -Url $adminURL -UseWebLogin
Connect-PnPOnline –Url $adminURL –Credentials (Get-Credential)

# replace with dynamic content
$content = @('Anna Weninger','René Fritsch','Babsi Weninger','Elliott Schmietz')

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