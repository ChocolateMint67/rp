:: verificam daca andrei ruleaza acest script :)

if %username% EQU WDAGUtilityAccount (     
    goto debugmode
) else (
    goto quietmode
)
pause
:: wdagutilityaccount va fi userul care va avea acces la debug (evident ca poate fi inlocuit oricand)

:quietmode
:: nu trebuie sa vezi asta :)
echo off
cls

:start
:: cerem permisiuni de admin
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Asteptam permisiunile de admin...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: creem un user
:filestart
set /p UserCr=Ce nume doresti sa aiba noul user? 
net user %UserCr% /add >Nul
if %ERRORLEVEL% EQU 0 (     
    echo Userul %UserCr% a fost creeat
) else (
    powershell write-host -back DarkRed Eroare! & echo Comanda a esuat [userul deja exista probabil]
)
echo.

:: dezactivam cmd pentru user
takeown /f %windir%\system32\cmd.exe >nul
icacls %windir%\system32\cmd.exe /deny %UserCr%:RX /Q >nul
if %errorlevel%==0 powershell write-host -back Green Succes! & echo CMD a fost blocat pentru %UserCr%
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo CMD nu a putut fi blocat pentru %UserCr%
echo.

:: dezactivam powershell pentru user
takeown /f %windir%\system32\WindowsPowerShell\v1.0\powershell.exe >nul
icacls %windir%\system32\WindowsPowerShell\v1.0\powershell.exe /deny %UserCr%:RX /Q >nul
if %errorlevel%==0 powershell write-host -back Green Succes! & echo Powershell a fost blocat pentru %UserCr%
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo Powershell nu a putut fi blocat pentru %UserCr%
echo.

:: instalam winget pentru instalarea mai rapida a programelor
cd %temp%
powershell Invoke-WebRequest https://git.io/J9shP -O %temp%\winget_downloader.ps1
if '%errorlevel%' NEQ '0' (
    goto faildownload
) else ( goto successs )

:successs
echo Verificam daca este instalat winget...
powershell Invoke-WebRequest https://git.io/J9GiO -O %temp%\winget_checker.ps1
powershell -noprofile -executionpolicy bypass -file "winget_checker.ps1"

:: instalam chrome, adobe reader si windows terminal (va fi blocat pentru user ulterior)
:: alte aplicatii pot fi gasite pe https://winget.run

winget install -e --id Adobe.Acrobat.Reader.64-bit -h -s winget
echo.
if %errorlevel%==0 powershell write-host -back Green Succes! & echo Adobe Acrobat Reader a fost instalat cu succes.
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo Am intampinat o eroare in timpul instalari! Te rog sa reincerci instalarea programului.
echo.
winget install -e --id Google.Chrome -h -s winget
if %errorlevel%==0 powershell write-host -back Green Succes! & echo Google Chrome a fost instalat cu succes.
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo Am intampinat o eroare in timpul instalari! Te rog sa reincerci instalarea programului.
echo.
winget install -e --id Microsoft.WindowsTerminal -v 1.11.3471.0 -h -s winget
if %errorlevel%==0 powershell write-host -back Green Succes! & echo Terminal a fost instalat cu succes.
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo Am intampinat o eroare in timpul instalari! Te rog sa reincerci instalarea programului.
echo.

:: dezactivam terminal
takeown /f "%ProgramFiles%\WindowsApps\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\wt.exe" >nul
takeown /f "%ProgramFiles%\WindowsApps\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\windowsterminal.exe" >nul
icacls "%ProgramFiles%\WindowsApps\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\wt.exe" /deny %UserCr%:RX /Q >nul
icacls "%ProgramFiles%\WindowsApps\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\windowsterminal.exe" /deny %UserCr%:RX /Q >nul
if %errorlevel%==0 powershell write-host -back Green Succes! & echo Terminal a fost blocat cu succes pentru %UserCr%
if %errorlevel%==1 powershell write-host -back DarkRed Eroare! & echo Terminal nu a putut fi blocat pentru %UserCr%
echo.
pause


:: verificam daca maria ruleaza acest script :)
if %username% EQU Maria (     
    pause
) else (
    exit
)
pause

:faildownload
echo.
echo Imi pare rau, dar se pare ca download-ul fisierului a esuat! Programul a fost terminat
echo.
pause

:debugmode
set /P c=Doresti sa ai modul debug oprit sau pornit [oprit/pornit]?
if /I "%c%" EQU "oprit" goto :quietmode
if /I "%c%" EQU "pornit" goto :start
goto :debugmode