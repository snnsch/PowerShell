# Link to Teams Sharepoint site
$adminURL = <YOUR URL>
# Teams connectors - webhook URI
$connectorUri = <YOUR WEBHOOK URI>

#Connect-PnPOnline -Url $adminURL -UseWebLogin
Connect-PnPOnline –Url $adminURL –Credentials (Get-Credential)

$site = New-PnPSite -Type CommunicationSite -Title $siteTitle -Url $siteURL -ErrorAction SilentlyContinue
$body = '{
    "text":
        "ONE MORE"
    }'

#Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body '{"text":"Hello World!"}' -ContentType 'application/json'
Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body $body -ContentType 'application/json'
