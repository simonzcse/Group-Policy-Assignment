clear-host
$Trainers = @()
$Content = Get-Content C:\CSV\Trainers.txt | Select-Object -Skip 4 
foreach($line in $Content){

    $nline = $line.Split(",") #-replace """",""
    $properties = @{
        'LoginName' = $nline[0]
        'FirstName'  = $nline[1]
        'LastName'   = $nline[2]
        'Email' = $nline[3]
        'Telephone' = $nline[4]
        'HKID' = $nline[5]
        'Password' = $nline[2].ToLower() +"$"+ $nline[5].substring(0, 7).ToUpper() | ConvertTo-SecureString -AsPlainText -Force
    }
    
    $Trainers += New-Object PSObject -Property $properties
    
}

#$Trainers

New-ADGroup -Name "EndgameTrainer" -GroupScope Global -DisplayName "EndgameTrainer" -Path "CN=Users,DC=EndGameA05,DC=com" 

foreach($item in $Trainers){
    $desc = "EndgameTrainer - " + $item.LoginName
    $fullname = $item.FirstName+" "+$item.LastName

    New-ADUser -SamAccountName $item.LoginName -Name $fullname -GivenName $item.FirstName -Surname $item.LastName -Path "CN=Users,DC=EndGameA05,DC=com"-Enabled $True -AccountPassword $item.Password -ChangePasswordAtLogon $False -Description $desc ` -MobilePhone $item.Telephone -PasswordNeverExpires $True -EmailAddress $item.Email
    Add-ADGroupMember -Identity "EndgameTrainer" -Members $item.LoginName
}