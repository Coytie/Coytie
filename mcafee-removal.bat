@echo off

if "%~1" neq "" goto :%~1

"c:\Program Files\McAfee\Agent\x86\frminst.exe" /forceuninstall /silent
wmic product where "Name like '%%McAfee%%'" call uninstall /nointeractive
"C:\Program Files\McAfee\Endpoint Security\Threat Prevention\RepairCache\SetupTP.exe" /x /removeespsynchronously
msiexec /x {FF94B30D-A51E-4D68-A353-0667C5655D2E} /qn /l "C:\Windows\Temp\McAfeeLogs\McAfee_Common_Uninstall.log"
"C:\ProgramData\Package Cache\{2038ad28-e6e3-4d10-805f-425811198918}\dxlsetup-ma.exe" /norestart /quiet /uninstall
echo McAfee is now uninstalled. 

call :PowerShell
call :markReboot WDEnable
goto :eof

:PowerShell
powershell -command "Get-WindowsFeature *defender* | Add-WindowsFeature *defender*"
echo Defender Installed.

:WDEnable
"C:\Program Files\Windows Defender\platform\4.18.1909.6-0\mpcmdrun.exe" -wdenable
echo Drive mounted successfully.
goto :eof

:markReboot
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /t REG_SZ /d "\"%~dpf0\" %~1" /v  RestartMyScript /f 
shutdown /r /t 00
