######### Secrets #########
$ApplicationId = 'ApplicationID'
$ApplicationSecret = 'ApplicationSecret'  | ConvertTo-SecureString -Force -AsPlainText
$RefreshToken = 'RefreshToken'
######### Secrets #########
### PartnerCenter and MSOnline Powershell modules are required


#Set days until expiration
$days = 30

write-host "Creating credentials and tokens." -ForegroundColor Green

$credential = New-Object System.Management.Automation.PSCredential($ApplicationId, $ApplicationSecret)
$aadGraphToken = New-PartnerAccessToken -ApplicationId $ApplicationId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.windows.net/.default' -ServicePrincipal
$graphToken = New-PartnerAccessToken -ApplicationId $ApplicationId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal

write-host "Connecting to Office365 to get all tenants." -ForegroundColor Green
Connect-MsolService -AdGraphAccessToken $aadGraphToken.AccessToken -MsGraphAccessToken $graphToken.AccessToken
$customers = Get-MsolPartnerContract -All
 
$Applications = foreach($customer in $Customers) {

    $CustGraphToken = New-PartnerAccessToken -ApplicationId $ApplicationId -Credential $credential -RefreshToken $refreshToken -Scopes "https://graph.microsoft.com/.default" -ServicePrincipal -Tenant $Customer.TenantId
    $headers = @{ "Authorization" = "Bearer $($CustGraphToken.accesstoken)" }
    write-host "Looking for changed applications for $($customer.DefaultDomainName)" -ForegroundColor Green
    $ApplicationsURI = "https://graph.microsoft.com/beta/applications"
    $AllApps = (Invoke-RestMethod -Uri $ApplicationsURI -Headers $Headers -Method Get -ContentType "application/json").value
    $Apps = $AllApps | Select-Object appid, displayname, passwordcredentials | Where-Object passwordCredentials -ne $null
$Expirations = @()
foreach ($app in $apps){
 $endDate = $app.passwordCredentials.endDateTime | Select-Object -first 1
 $TimeConvert = [datetime]::Parse($endDate)
 $Math = ($TimeConvert) - $Now
 
 if($Math -lt $Days){
 $Expirations += $customer.DefaultDomainName
 $Expirations += $App}

 }
 }
    

if($Expirations -ne $null){
write-host "One of the application proxies is not active. See results"}
$Expirations

