#Install-Module LithnetRMA
#Import-Module LithnetRMA

$obj = New-Resource -ObjectType Person
$obj.AccountName ="MIMTestAccount1"
$obj.Domain ="gogo"
$obj.DisplayName = "MIM Test Account 1"
$obj.Manager = "cinguva"
Save-Resource $obj