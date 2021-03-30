# Connect-MsolService

$licenses = Get-MsolAccountSku
$counter = 0
$services_in_licenses = $null

Write-Output("*** YOUR LICENSES: *** `n") 

foreach ($item in $licenses) {
    $account_sku_id = "$($licenses.AccountSkuId[$counter])" #name der license
    $account_sku_id
    $services_in_licenses += ((Get-MsolAccountSku | Where-Object {$_.AccountSkuId -eq $account_sku_id}).ServiceStatus)
    $counter += 1
}

Write-Output("`n*** What is included in my licenses?: *** `n")
Write-Output("NUMBER OF SERVICES: $($services_in_licenses.Count)")
$services_in_licenses | Sort-Object @{e={$_.Serviceplan.ServiceName}} # sort nested properties of object for each item of the class