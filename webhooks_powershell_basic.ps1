$adminURL ="https://m365x425026-admin.sharepoint.com"
$siteURL ="https://m365x425026.sharepoint.com/sites/aweninger-teams/"
$siteTitle ="aweninger-teams"
$connectorUri = 'https://outlook.office.com/webhook/8aba3d8f-7014-469e-96be-a3a8bcc25ef6@544bc022-09a1-4846-ab3c-d329dad23be2/IncomingWebhook/8b717eb61b50439da88446b123d05786/3422ada9-b5a0-4ef0-958d-a02ee3f9c0b9'

#Connect-PnPOnline -Url $adminURL -UseWebLogin
Connect-PnPOnline –Url $adminURL –Credentials (Get-Credential)

$site = New-PnPSite -Type CommunicationSite -Title $siteTitle -Url $siteURL -ErrorAction SilentlyContinue
$body = '{
    "text":
        "ONE MORE"
    }'

#Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body '{"text":"Hello World!"}' -ContentType 'application/json'
Invoke-RestMethod -Uri $connectorUri -Method 'Post' -Body $body -ContentType 'application/json'
