@echo off
setlocal

set "USERNAME=guacadmin"

:: 1. Check if user already exists
net user %USERNAME% >nul 2>&1
if %errorlevel% == 0 (
    echo User '%USERNAME%' already exists. Skipping creation.
) else (
    :: Try to create user with no password
    net user %USERNAME% /add
    if %errorlevel% neq 0 (
        echo Failed to create user '%USERNAME%'. Make sure you are running this script as Administrator.
        goto :end
    )
    echo User '%USERNAME%' created successfully.
)

:: 2. Disable all firewall profiles
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off

:: 3. Enable Remote Desktop
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

:: 3b. Enable Remote Desktop in Firewall (if ever turned back on)
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
