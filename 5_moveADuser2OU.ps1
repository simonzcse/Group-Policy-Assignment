clear

Get-ADComputer -Filter 'Name -like "EG-*"' -Property Name | Move-ADObject -TargetPath "OU=EndGameA05_OU,DC=EndGameA05,DC=com"
Get-ADGroupMember -Identity EndGameTrainer | Move-ADObject -TargetPath "OU=EndGameA05_OU,DC=EndGameA05,DC=com"
Get-ADGroupMember -Identity Trainees | Move-ADObject -TargetPath "OU=Trainees,OU=EndGameA05_OU,DC=EndGameA05,DC=com"
