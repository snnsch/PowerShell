# TODO: Authentifizierung
# TODO: Script automatisch ausführen
# TODO: Gefundene "böse" Gastuser aus System löschen
# TODO: Report in SP-Liste hinterlegen
# TODO: Mehr Catch

# Connect-AzureAD -Verbose
# Get-AzureADUser -All $true -Filter "UserType -eq 'Guest'"

# WICHTIG WICHTIG WICHTIG !!!!!!!!!!!!!!!!!!!!!! DEBUG - nachher wieder aktivieren, das holt alle Gäste und deren UIDs
$current_guests = Get-AzureADUser -Filter "UserType eq 'Guest'"

foreach ($guest in $current_guests) {
    # Get timestamp for last login of each guest user from Azure logs
    $last_login = (Get-AzureADAuditSignInLogs -Top 1 -Filter "userid eq '$($guest.ObjectId)' and status/errorCode eq 0").CreatedDateTime
    # DEBUG: show user name and login date
    Write-Host ("User",$guest.UserPrincipalName,"Last-Login",$last_login)
    $saved_timestamp_dep = (Get-AzureADUser -ObjectId $guest.ObjectId).Department

    # (A) If $last_login empty AND department property empty => means (first time) execution of script more than a month ago, debug set user logon date to today
    If (($last_login -eq $NULL) -And ($saved_timestamp_dep -eq $NULL)) {
        # Set current date in same format as log timestamp for date comparison
        $last_login = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        Set-AzureADUser -ObjectId $guest.ObjectId -Department $last_login
    }

    # (B) If user hasn't logged in for over 1 month => check if previous process has marked last known logon time
    elseif (($last_login -eq $NULL) -And ($saved_timestamp_dep -ne $NULL)) { 
        $last_login = $saved_timestamp_dep 
    }         
    
    # (C) If user has logged in within the last month, take Azure logs login date
    else {
        Set-AzureADUser -ObjectId $guest.ObjectId -Department $last_login
    }

    # Calculate time diff (a) last logon vs (b) right now

    # wait 90 secs until user property changes have been synced
    $sleep_time_secs = 90

    $time_diff = ((get-date $last_login) - (Get-Date))
    # DEBUG
    Write-Host ($time_diff.Days)
    If ($time_diff.Days -lt -365) {
        Write-Host "RAUS, dieser User muss gelöscht werden im nächsten Schritt - $($guest.UserPrincipalName)"
    }
    Else {
        Write-Host ".... ALLES GUT ...."
    }


}