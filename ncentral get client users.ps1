$CustomerLookUp = Get-NCCustomerList | where-object { $_.parentid -eq '50' } | Select-Object customerid, parentid, customername
$NCRoles = foreach ($Customer in $CustomerLookUp) {
    $Roles = Get-NCUserRolelist -CustomerIDs $Customer.customerid | Where-Object { $_.usernames -ne "[]" } 
    if ($null -eq $roles){
    [PSCustomObject]@{
        rolename     = $_.rolename
        customerid   = $_.customerid
        customername = $customer.customername
        usernames    = $_.usernames
    }
}
}
$NCRoles | Export-Csv "c:\temp\ncentral.csv" -NoTypeInformation -Encoding UTF8
