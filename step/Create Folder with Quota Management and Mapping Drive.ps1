#Install-WindowsFeature -Name fs-resource-manager -IncludeManagementTools
#import FileServerResourceManager
#create folder 
New-Item C:\personal -Type Directory -Force 
#create personal folder for each user 
[String[]]$adgps = "Trainees","EndgameTrainer" 
Foreach($adgp in $adgps){ 
    Get-ADGroupMember -Identity $adgp  | ForEach-Object { 
     #create folder 
     $fileNm = "C:\personal\" + $_.SamAccountName 
     New-Item $fileNm  -Type Directory -Force 
      #file premission setting 
     $acl = Get-Acl $fileNm 
     $acl.SetAccessRuleProtection($True, $False) 
     #set ace for trainee 
     $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( 
     $_.SamAccountName, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" ) 
     $acl.SetAccessRule($ace) 
       
      #set ace for admins group  
     $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( 
     "Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" ) 
     $acl.SetAccessRule($ace) 
     Set-Acl $fileNm -AclObject $acl 
     #mapping drive F: 
      $dir = "\\CentralServer\personal\" + $_.SamAccountName 
     Set-ADUser -Identity $_ -homedirectory $dir -homedrive F: 
          #set quota to the Drive 
     $threshold = New-FsrmQuotaThreshold -Percentage 75 -Action $Action #6GB warning threshold 
     $dir2 = "C:\personal\" + $_.SamAccountName 
     New-FsrmQuota -Path $dir2 -Description "limit usage to 8 GB" -Size 8GB -Threshold $threshold  
    } 
} 
#share folder 
New-SmbShare -Name personal -Path C:\personal -FullAccess "Authenticated Users"