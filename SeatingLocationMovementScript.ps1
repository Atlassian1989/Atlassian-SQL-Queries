Import-Module LithnetRMA;

Get-Credential | Set-ResourceManagementClient -BaseAddress http://CAZ-VMW-MIM-10.gogo.local:5725;


$file = import-csv -Path C:\SeatingMovement.csv
$file.Count


foreach ($row in $file) 
{

    
    $obj = Get-Resource -ObjectType Person -AttributeValuePairs @{AccountName = $row.'AccountName'; Domain="gogo"}
    
    Write-Host "Working on Account" + $obj.AccountName

    $obj.SeatingLocation = $row.'New Seat'
    Save-Resource $obj

    Write-Host "Updated Seating Location for: " $obj.AccountName "to" $row.'New Seat' 
        
     
     

}



