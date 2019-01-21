$CRED = Get-Credential
$SESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $CRED -Authentication Basic -AllowRedirection 
Import-PSSession $SESSION -AllowClobber
Connect-MsolService -Credential $CRED
Set-OrganizationConfig -FocusedInboxOn $False
Write-Host Focused Inbox is now disabled