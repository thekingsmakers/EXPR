@echo off
setlocal

:: Set username
set "USERNAME=guacadmin"

:: 1. Create user 'guacadmin' with no password
net user %USERNAME% /add
if %errorlevel% neq 0 (
    echo Failed to create user '%USERNAME%'.
    goto :end
)

:: 2. Disable all firewall profiles
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off

:: 3. Enable Remote Desktop
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

:: Enable RDP rule in firewall (if firewall ever re-enabled)
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

:: 4. Add user to Remote Desktop Users group
net localgroup "Remote Desktop Users" %USERNAME% /add
if %errorlevel% neq 0 (
    echo Failed to add '%USERNAME%' to Remote Desktop Users group.
    goto :end
)

echo All tasks completed successfully.

:end
pause
