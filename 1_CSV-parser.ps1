# TODO:
# 1) Teste mit neuen frischen Files und Usern
# 2) WAS PASSIERT WENN: Email Key ändert sich aber Kunde bleibt gleich // Alten Email Key aus GRUPPE entfernen und neuen Key
# => einfach beim Test ob alte Email im neuen File NICHT drinnen ist => Kundenname merken und checken, ob der KUNDENNAME noch im neuen File drin ist

function Import_Old_CSV {
    $old_file = Import-CSV ./users_old.csv
    return $old_file
}
function Import_New_CSV {
    $new_file = Import-CSV ./users_new.csv
    return $new_file
}

function Count_CSVLines_Diff ($new, $old) {
    $new_csv_lines = $new.count
    $old_csv_lines = $old.count
    If ($new_csv_lines -eq $old_csv_lines) {
        Write-Output ("Die Files haben dieselbe Länge`n")
    }
    Else {
        Write-Output "Anzahl Zeilen altes CSV: $old_csv_lines"
        Write-Output "Anzahl Zeilen neues CSV: $new_csv_lines`n"
    }
}

function Check_NewMailsAdded ($input_old_csv, $input_new_csv) {

    $line_count = 0
    $ansprech_object_array = @()

    # for each line of the NEW CSV check if each mail address in file exists in OLD CSV
    foreach ($line in $input_new_csv) {
        if ($input_new_csv[$line_count].email -in $input_old_csv.email) {

        }
        else {
            # Create new object if new Ansprechpartner is found
            $new_ansprech_obj = [PSCustomObject]@{
                firstname = ''
                lastname = ''
                company = ''
                email = ''
                CSPneu_checkdate = ''

            }
            Write-Output ">>>> Achtung, neuer Ansprechpartner: $($input_new_csv[$line_count].email)"

            # Fill object for new Ansprechpartner with matching property from CSV
            $new_ansprech_obj.firstname = $input_new_csv[$line_count].firstName
            $new_ansprech_obj.lastname = $input_new_csv[$line_count].lastName
            $new_ansprech_obj.company = $input_new_csv[$line_count].company
            $new_ansprech_obj.email = $input_new_csv[$line_count].email
            #$new_ansprech_obj.CSPneu_checkdate = $new_csv[$line_count].createdOn
            # FORMAT DATE!!
            
            $formated_date = ($input_new_csv[$line_count].createdOn).Substring(0,10)
            $new_ansprech_obj.CSPneu_checkdate = $formated_date
            
            # Add Ansprechpartner object to array of objects
            $ansprech_object_array += $new_ansprech_obj
        }
        $line_count += 1
    }
    Write-Output "`n*** (1) Folgende NEUE Ansprechpartner gefunden:"
    return $ansprech_object_array
}
function Check_CustomerGone ($input_old_csv, $input_new_csv) {

    $line_count = 0
    $customerGone_object_array = @()

    # for each line of the OLD CSV check if email is anywhere in new CSV file
    foreach ($line in $input_old_csv) {
        if ($input_old_csv[$line_count].email -in $input_new_csv.email) {

        }
        else {
            # Create new object if customer is gone
            $gone_customer_obj = [PSCustomObject]@{
                firstname = ''
                lastname = ''
                company = ''
                email = ''
            }
            Write-Output ">>>> Achtung, Kunde aus CSP ausgetreten: $($input_old_csv[$line_count].email)"

            # Fill object for gone Ansprechpartner with matching property from OLD CSV
            $gone_customer_obj.firstname = $input_old_csv[$line_count].firstName
            $gone_customer_obj.lastname = $input_old_csv[$line_count].lastName
            $gone_customer_obj.company = $input_old_csv[$line_count].company
            $gone_customer_obj.email = $input_old_csv[$line_count].email

            # Add gone customer object to array of objects
            $customerGone_object_array += $gone_customer_obj
        }
        $line_count += 1
    }
    Write-Output "`n*********************"
    Write-Output "`n*** (2) Folgende KundInnen sind KEINE CSP-KundInnen mehr:`n"
    return $customerGone_object_array
}

function Check_CSV_properties {

    Write-Output ">>>>> Checking OLD and NEW CSV for (1) new customers and (2) customers that are gone`n"
    $old_csv = Import_Old_CSV
    $new_csv = Import_New_CSV

    # Methoden in PS werden ohne Klammer und ohne Komma aufgerufen :D

    # Alle neue Kunden, die zu CSP Community Club hinzugefügt werden müssen
    $new_mailaddresses = Check_NewMailsAdded $old_csv $new_csv

    # Alle Kunden, die nun aus dem CSP Community Club entfernt werden müssen
    $gone_mailaddresses = Check_CustomerGone $old_csv $new_csv

    $new_mailaddresses
    $gone_mailaddresses

}

#################### MAIN

Check_CSV_properties
