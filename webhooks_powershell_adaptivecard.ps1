# Link to Teams Sharepoint site
$adminURL = <YOUR URL>
# Teams connectors - webhook URI
$connectorUri = <YOUR WEBHOOK URI>

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



