#Run this script in an elevated CMD prompt
#This does not include firewall rules

# Backup admin account
net user admin2
net localgroup Administrators admin2 /add


#rename + disable administrator account
wmic useraccount where “name=’Administrator’” rename Admin
net user Admin /active:no


#Enable full auditing
auditpol /set /category:* /success:enable /failure:enable


#backup + delete scheduled tasks
#TODO


#Disable RDP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v fLogonDisabled /t REG_DWORD /d 1 /f


#Disable Admin Shares (psexec)
reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\ /v AutoShareWks /t REG_DWORD /d 0 /f


#SMBv1 Disable 
reg add HKLM\SYSTEM\CurrentControlSet\Control\Services\LanmanServer\Parameters /v SMB1 /t REG_DWORD /d 1 /f


#stop winrm service
net stop winrm


#restart SMB server for changes
net stop server
net start server


#Temp Folder Permissioning (might break installers)
icacls C:\Windows\Temp /inheritance:r /deny "Everyone:(OI)(CI)(F)"


#Hashing
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v NoLMHash /t REG_DWORD /d 1 /f
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v LMCompatibilityLevel /t REG_DWORD /d 5 /f


#Anon Login
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymous /t REG_DWORD /d 1 /f


#Disable Keys
reg add HKCU\Control Panel\Accessibility\StickyKeys /v Flags /t REG_SZ /d 506 /f
reg add HKCU\Control Panel\Accessibility\ToggleKeys /v Flags /t REG_SZ /d 58 /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v ShowTabletKeyboard /v REG_DWORD /d 0 /f


# Enable LSASS Memory Protection
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RunAsPPL /t REG_DWORD /d 1 /f


# Turn off Test Mode (in case they set the flag)
bcdedit /set testsigning off


#full restart
restart /r /t 0
