# PRECONDITIONS
### Install-Module MSOnline 
### Connect-MsolService

# MAIN

#1st VARIABLE = is mfa enabled or not (get mfa status)
$mfa = @{
    label = "MFA-Status"; 
    expression={
        if ($_.StrongAuthenticationRequirements.State -eq $null) {
            "MFA-Disabled" 
        } 
        else { 
            $_.StrongAuthenticationRequirements.State 
        }
    }
}

#2nd VARIABLE = get MFA details => main phone number

$mfa_details_phone = @{
    label = "MFA-phone";
    expression = {
        if ($_.StrongAuthenticationUserDetails.PhoneNumber -eq $null) {
            "no phone mfa"
        }
        else {
            $_.StrongAuthenticationUserDetails.PhoneNumber
        }
    }
}

#3rd VARIABLE = get MFA details = email address

$mfa_details_mail = @{
    label = "MFA-mail";
    expression = {
        if ($_.StrongAuthenticationUserDetails.Email -eq $null) {
            "no email mfa"
        }
        else {
            $_.StrongAuthenticationUserDetails.Email
        }
    }
}

#4th VARIABLE = MFA method

$mfamethod = @{
    label="MFA-Method";
    expression = {
        if ($_.StrongAuthenticationMethods.MethodType -eq $null) {
            "no MFA method"
        }
        else {
            ($_.StrongAuthenticationMethods.MethodType)
        }
    }
}

# Execute the entire query with all variables and export to CSV
# CSV export file nomenclature: <tenant-displayname>_"MFA-Export"_yyyyMMdd_HHmmss.csv

Get-MsolUser -all | select UserPrincipalName, $mfamethod, $mfa_details_phone, $mfa_details_mail | Export-Csv "Tenant-$((Get-AzureADTenantDetail).DisplayName)_MFA-Export_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv"
