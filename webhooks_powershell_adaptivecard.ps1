# Link to Teams Sharepoint site
$adminURL ="https://m365x425026-admin.sharepoint.com"
# Teams connectors - webhook URI
$connectorUri = 'https://outlook.office.com/webhook/8aba3d8f-7014-469e-96be-a3a8bcc25ef6@544bc022-09a1-4846-ab3c-d329dad23be2/IncomingWebhook/8b717eb61b50439da88446b123d05786/3422ada9-b5a0-4ef0-958d-a02ee3f9c0b9'

# Install-Module SharePointPnPPowerShellOnline
Connect-PnPOnline –Url $adminURL –Credentials (Get-Credential)
# IF mfa USE: Connect-PnPOnline -Url https://yoursite.sharepoint.com -UseWebLogin

# body of the adaptive card; use more elements for e.g. type "TextBlock" (e.g. color, fontType, ...) from https://adaptivecards.io/explorer/TextBlock.html
$body = '{
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
                 "color": "good",
                 "text": "This is text by Anna",
                 "weight": "bolder",
                 "wrap": true
                 }
             ]
          }
       }
    ]
 }'

#Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body $body -ContentType 'application/vnd.microsoft.card.adaptive'
Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body $body -ContentType 'application/json'



