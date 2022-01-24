clear
cd C:\CSV # File Path 
$csv = Import-Csv "StudentList2021.csv" # Import Students' Account File 
$pwRegex = '^(?=.*\d)(?=.*[\W_])[\w\W]{8,}$' 

$emailRegex = '^([\w‐\.]+)@((\[[0‐9]{1,3}\.[0‐9]{1,3}\.[0‐9]{1,3}\.)|(([\w‐]+\.)+))([a‐zA‐Z]{2,4}|[0‐9]{1,3})(\]?)$'  
#!!!!something wrong 
$phoneRegex = '^[0‐9]{8}' 
# create log files 
New-Item -ItemType 'File' -Force -Path 'log\InvalidPassword.txt' 
New-Item -ItemType 'File' -Force -Path 'log\InvalidEmail.txt' 
New-Item -ItemType 'File' -Force -Path 'log\InvalidPhone.txt' 
# create group 
New-ADGroup -Name "Trainees" -GroupScope Global -DisplayName "Trainees" -Path "CN=Users,DC=EndGameA05,DC=com" 
foreach($item in $csv) # Read data from Intake20.csv 
{ 
    if(!($item.Password -Match $pwRegex)){ 
        Add-Content -Path 'log\InvalidPassword.txt' -Value $item.LoginID 
        $isCorrect = $False 
    } 
    if(!($item.Email -Match $emailRegex)){ 
        Add-Content -Path 'log\InvalidEmail.txt' -Value $item.LoginID 
        $isCorrect = $False 
    } 
    if(!($item.Telephone -Match $phoneRegex)){ 
        $c = $item.Telephone -Replace '[\W]', '' -Replace '852','' -Replace '85','' 
        Add-Content -Path 'log\InvalidPhone.txt' -Value $item.LoginID 
        $isCorrect = $False 
    } 
    if($item.Password -Match $pwRegex -And $item.Telephone -Match $phoneRegex -And $item.Email -Match $emailRegex){ 
        $isCorrect = $True 
    } 


    $desc = "Online Trainee - " + $item.LoginID     # create account 
    $password =  $item.Password | ConvertTo-SecureString -AsPlainText -Force 
    New-ADUser -SamAccountName $item.LoginID -Name $item.FullName -GivenName $item.FirstName ` -Surname $item.LastName -Path "CN=Users,DC=EndGameA05,DC=com"-Enabled $isCorrect ` -AccountPassword $Password -ChangePasswordAtLogon $False -Description $desc ` -MobilePhone $item.Telephone -PasswordNeverExpires $True -EmailAddress $item.Email 
      
    # add user to group 
    Add-ADGroupMember -Identity "Trainees" -Members $item.LoginID 
    #restrict the user logon computer 
    #[string[]]$adComp = (Get-ADComputer -Filter 'Name -like "LAB*-S*"' -Property Name).Name 
    #foreach($compName in $adComp){ 
    #    Set-ADUser $item.LoginID -LogonWorkstations $compName 
    #} 
} 