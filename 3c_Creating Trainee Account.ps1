clear
cd C:\CSV # File Path 
$csv = Import-Csv "StudentList2021.csv" # Import Students' Account File 
$pwRegex = '^(?=.*\d)(?=.*[\W_])[\w\W]{8,}$' 

$phoneRegex = '^[0-9]{8}' 
# create log files 
New-Item -ItemType 'File' -Force -Path 'log\InvalidPassword.txt' 
New-Item -ItemType 'File' -Force -Path 'log\InvalidPhone.txt' 
# create group 
New-ADGroup -Name "Trainees" -GroupScope Global -DisplayName "Trainees" -Path "CN=Users,DC=EndGameA05,DC=com" 
foreach($item in $csv) # Read data from Intake20.csv 
{ 
    if(!($item.Password -Match $pwRegex)){ 
        Add-Content -Path 'log\InvalidPassword.txt' -Value $item.LoginID 
        $isCorrect = $False 
    } 
 
    if(!($item.Telephone -Match $phoneRegex)){ 
        $item.Telephone = $item.Telephone -Replace '[\W]', '' -Replace '852','' -Replace '(852)','' 
        Add-Content -Path 'log\InvalidPhone.txt' -Value $item.LoginID 
        $isCorrect = $False 
    } 
    if($item.Password -Match $pwRegex -And $item.Telephone -Match $phoneRegex){ 
        $isCorrect = $True 
    } 

    $desc = "Online Trainee - " + $item.LoginID     # create account 
    $password =  $item.Password | ConvertTo-SecureString -AsPlainText -Force 
    New-ADUser -SamAccountName $item.LoginID -Name $item.FullName -GivenName $item.FirstName  -Surname $item.LastName -Path "CN=Users,DC=EndGameA05,DC=com"-Enabled $isCorrect  -AccountPassword $Password -ChangePasswordAtLogon $False -Description $desc -MobilePhone $item.Telephone -PasswordNeverExpires $True 
      
    # add user to group 
    Add-ADGroupMember -Identity "Trainees" -Members $item.LoginID }
