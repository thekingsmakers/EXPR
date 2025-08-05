@echo off
setlocal

:: Set username and password
set "USERNAME=guacadmin"
set "USERPASS=guacadmin"

:: 1. Create user 'guacadmin' with password 'guacadmin'
net user %USERNAME% %USERPASS% /add
if %errorlevel% neq 0 (
    echo Failed to create user '%USERNAME%'.
    goto :end
)

:: 2. Disable all firewall profiles (Domain, Private, Public)
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off

:: 3. Enable Remote Desktop (RDP)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

:: Enable RDP in Windows Firewall (optional but recommended if firewall is turned back on later)
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

:: 4. Add 'guacadmin' to the Remote Desktop Users group
net localgroup "Remote Desktop Users" %USERNAME% /add
if %errorlevel% neq 0 (
    echo Failed to add '%USERNAME%' to Remote Desktop Users group.
    goto :end
)

echo All tasks completed successfully.

:end
pause
