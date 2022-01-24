clear
Get-PSDrive -PSProvider Registry | select -Property Name,Root

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EncryptionContextMenu" -Value ”1”  -PropertyType "DWORD"