#JOIN ALL COMPUTERS AS A STRING 
[string]$studentCom = (Get-ADComputer -Filter 'Name -like "LAB*-S*"' -Property Name).Name -join "," 
Write-Output $studentCom 
#ADD LogonWorkstations TO ALL TRAINEES 
Get-ADGroupMember -Identity Trainees | %{Set-ADUser $_ -LogonWorkstations $studentCom} 