$CustomerList = Get-Content C:\temp\customer.csv
foreach ($Customer in $CustomerList){
Get-NCCustomerList $Customer | Select-object parentcustomername -ExpandProperty parentcustomername | Out-file C:\temp\ncentral.csv -Append
Write-Host "Scanning $Customer for active users"
$Customer | Out-file C:\temp\ncentral.csv -Append
Get-NCUserRoleList -CustomerID $Customer | select-object -Property rolename, usernames | fl | Out-File c:\temp\ncentral.csv -Append
}