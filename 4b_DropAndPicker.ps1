#Install-WindowsFeature -Name fs-resource-manager -IncludeManagementTools
#import FileServerResourceManager
#create folder 
New-Item C:\DropAndPick -Type Directory -Force 
#create DropAndPick folder for each user 
[String[]]$adgps = "EndgameTrainer" 
Foreach($adgp in $adgps){ 
    Get-ADGroupMember -Identity $adgp  | ForEach-Object { 
     #create folder 
     $fileNm = "C:\DropAndPick\" + $_.SamAccountName 
     New-Item $fileNm  -Type Directory -Force 
      #file premission setting 
     $acl = Get-Acl $fileNm 
     $acl.SetAccessRuleProtection($True, $False) 
     #set ace for owner 
     $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( 
     $_.SamAccountName, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" ) 
     $acl.SetAccessRule($ace) 
       
      #set ace for Trainees group  
     $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( 
     "Trainees", "Write", "ContainerInherit, ObjectInherit", "None", "Allow" ) 
     $acl.SetAccessRule($ace) 
     Set-Acl $fileNm -AclObject $acl 

		#set quota to the Drive 
     $dir2 = "C:\DropAndPick\" + $_.SamAccountName 
     New-FsrmQuota -Path $dir2 -Description "limit usage to 40 GB" -Size 40GB  
    } 
}
#share folder 
New-SmbShare -Name DropAndPick -Path C:\DropAndPick -FullAccess "Authenticated Users"


New-PSDrive –Name “G”  –PSProvider FileSystem –Root '\\192.168.10.1\DropAndPick' –Persist




