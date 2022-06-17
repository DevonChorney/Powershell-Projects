$HourstoAlert = 4
$Now = Get-date

$Log = Get-Content 'C:\Program Files (x86)\LiongardInc\LiongardAgent\Logs\heartbeat.log' | convertfrom-json | select -last 1 -ExpandProperty timestamp
$LastEntryDate = [Datetime]$Log
$Math = $Now - $LastEntryDate

if($Math.TotalHours -gt $HourstoAlert){
    
    Restart-service -Name 'roaragent.exe'
    $Status = 'Heartbeat Failure. Restarting Agent'
}Else{
    $Status = 'Healthy'
}
