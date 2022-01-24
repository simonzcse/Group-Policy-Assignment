$numofStuCompPerLab = 20; 
$numofTeaCompPerLab = 2;
 


  For ($s = $numofStuCompPerLab; $s -gt 0; $s--) { 
    $compName = "EG-A"+$s.ToString('00'); 
    $dns = $compName + '.EndGameA05.com'; 
    New-ADComputer -Name $compName -Path "CN=Computers,DC=EndGameA05,DC=com" -DNSHostName $dns -Enabled $True
  }     

    For ($s = $numofStuCompPerLab; $s -gt 0; $s--) { 
    $compName = "EG-B"+$s.ToString('00'); 
    $dns = $compName + '.EndGameA05.com'; 
    New-ADComputer -Name $compName -Path "CN=Computers,DC=EndGameA05,DC=com" -DNSHostName $dns -Enabled $True 
  }
  
  
  For ($t = $numofTeaCompPerLab; $t -gt 0; $t--) { 
    $compName = "EG-T"+$t.ToString('00'); 
    $dns = $compName + '.EndGameA05.com';
    New-ADComputer -Name $compName -Path "CN=Computers,DC=EndGameA05,DC=com" -DNSHostName $dns -Enabled $True
  }     
   


