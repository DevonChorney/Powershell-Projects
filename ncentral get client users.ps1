$CustomerLookUp = Get-NCCustomerList | where-object { $_.parentid -eq '50' } | Select-Object customerid, parentid, customername
$NCRoles = foreach ($Customer in $CustomerLookUp) {
    $Roles = Get-NCUserRolelist -CustomerIDs $Customer.customerid | Where-Object { $_.usernames -ne "[]" } 
    if ($roles) {
        foreach ($role in $roles) {
            [PSCustomObject]@{
                rolename     = $role.rolename
                customerid   = $role.customerid
                customername = $customer.customername
                usernames    = $role.usernames
            }
        }
    }
}
$NCRoles | Export-Csv "c:\temp\ncentral.csv" -NoTypeInformation -Encoding UTF8
