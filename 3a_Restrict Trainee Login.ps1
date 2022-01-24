clear
#JOIN ALL TRAINEES COMPUTERS AS A STRING 
[string]$studentComA = (Get-ADComputer -Filter 'Name -like "EG-A*"' -Property Name).Name -join ","
[string]$studentComB =  (Get-ADComputer -Filter 'Name -like "EG-B*"' -Property Name).Name -join ","

[string]$studentCom = $studentComA +","+$studentComB

Write-Output $studentCom
 
#ADD LogonWorkstations TO ALL TRAINEES 
Get-ADGroupMember -Identity Trainees | %{Set-ADUser $_ -LogonWorkstations $studentCom} 
