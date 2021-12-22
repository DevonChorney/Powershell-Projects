$CustomerList = Get-NCCustomerList | Select-Object customername,parentid,customerid

foreach ($Customer in $CustomerList){
    if($Customer.parentid -eq 50){
    $TableOutput = @{}
    Get-NCCustomerList $Customer.customerid | Select-object parentcustomername -ExpandProperty parentcustomername -Unique
    $Customername = $Customer.customername
    Write-Host "Scanning '$Customername' for active users"
    "
    $Customername
    "  | Out-file C:\temp\ncentraluseraudit.csv -Append
    $UserRoles = Get-NCUserRoleList -CustomerID $Customer.customerid | select-object -Property rolename, usernames
    foreach ($UserRole in $UserRoles){
        if($UserRole.usernames -ne '[]'){
            Write-Host $UserRole.rolename
            Write-Host $UserRole.usernames
            $Tableoutput.Add($UserRole.rolename,$UserRole.usernames)
    
            
            }else{
            Write-Host "Empty Role"
            
            }}
$Tableoutput | Out-file C:\temp\ncentraluseraudit.csv -Append
}else{
Write-Host "Not a primary site"
}}
