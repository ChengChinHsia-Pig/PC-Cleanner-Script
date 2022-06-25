@echo off
title "Pc Cleaner|電腦優化工具"
color 02
mode con: cols=160 lines=78
:start
echo 本程式運行需要管理權限
echo 若您沒有開啟管理員權限，本程式將自動開啟
echo 優化途中會彈出的第一個視窗，會自己關閉
echo 優化途中會彈出的第二個視窗，請選擇你要刪除的地方
pause
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在獲取管理員權限...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit/B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
cls
:program
echo 正在優化您的電腦，請稍候......
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
DEL /S /F /Q "%systemroot%\Temp\*.*"
DEL /S /F /Q "%AllUsersProfile%\「開始」功能表\程式集\Windows Messenger.lnk"
RD /S /Q %windir%\temp & md %windir%\temp
RD /S /Q "%userprofile%\Local Settings\Temp"
MD "%userprofile%\Local Settings\Temp"
RD /S /Q "%systemdrive%\Program Files\Temp"
MD "%systemdrive%\Program Files\Temp"
RD /S /Q "%systemdrive%\d"
cleanmgr
net user aspnet /delete
ipconfig/flushdns
ipconfig /release
ipconfig /renew
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set supplemental (Alternative command for Windows 7 users is at the end)
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global chimney=disabled
netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes
wmic computersystem where name=”%computername%” set AutomaticManagedPagefile=False
wmic product get name
cleanmgr.exe /sageset:number
sfc /scannow
DISM / Online / Cleanup-Image / CheckHealth
DISM / Online / Cleanup-Image / ScanHealth
DISM.exe /Online /Cleanup-image /Restorehealth
echo 優化完成！
pause
