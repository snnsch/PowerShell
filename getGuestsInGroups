function getGuestsInGroups() {
    $groupswithguests = @{}
    $groupcounter = 0
    foreach ($group in Get-AzureADGroup) {
        $groupcounter += 1
        Write-Host "$groupcounter *********************************"

        # Gruppen ID und Namen holen & anzeigen
        $groupid = $group.ObjectId
        $groupname = $group.DisplayName
        Write-Host "GROUP-ID: $groupid"
        Write-Host "GRUPPENNAME: $groupname"

        # Group members von Gruppen mit Gaesten holen und anzeigen, sonst members total zählen und anzeigen
        $getallmems = Get-AzureADGroupMember -ObjectId $groupid
        $countmems = $getallmems.count
        $getguests = $getallmems | Where-Object {$_.UserType -eq "Guest"}
        Write-Host "Anzahl Members (GESAMT) in der Gruppe: $countmems"
        Write-Host ""
        if ($getguests -eq $null) {
            Write-Host ">> KEINE Gaeste in '$groupname'"
        }
        else {
            Write-Host "Details zu guest(s) in der Gruppe:" 
            $getguests
            $groupswithguests.add($groupname,$groupid)
        }
        Write-Host "************************************"
        Write-Host ""
    }
    #ToDo: Auch Anzahl der Gäste ausgeben und IDs?
    #ToDo: Format output of hashtable => there is a value "name" which is identical to "key" and doesn't need to be there
    Write-Host ">>> Namen der Gruppen MIT Gaesten:"
    $groupswithguests
}

getGuestsInGroups
