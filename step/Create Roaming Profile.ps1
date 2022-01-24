#CREATE ROMAMING FOLDER 
New-Item C:\Profiles$ -Type Directory 
#NTFS PERMISSION 
$acl = Get-Acl C:\Profiles$ 
$acl.SetAccessRuleProtection($True, $False) 
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( ` 
 "SYSTEM","FullControl","ContainerInherit,ObjectInherit", ` 
 "None","Allow" ) 
$acl.SetAccessRule($ace) 
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( ` 
 "Administrators","FullControl","None","None","Allow" ) 
$acl.AddAccessRule($ace) 
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( ` 
 "CREATOR OWNER","FullControl","ContainerInherit,ObjectInherit","None","Allow" ) 
$acl.AddAccessRule($ace) 
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( ` 
 "Users","ReadData,AppendData","None","None","Allow" ) 
$acl.AddAccessRule($ace) 
Set-Acl -Path C:\Profiles$ -AclObject $acl 
#SHARE FOLDER 
New-SmbShare -Name Profiles$ -Path C:\Profiles$ -FullAccess "Authenticated Users" 
#MODIFY USER PROFILE PATH 
Get-ADGroupMember -Identity "Domain Users" | ForEach-Object { 
 Set-ADUser -Identity $_ -ProfilePath "%LogonServer%\Profiles$\%username%\"` 
} 