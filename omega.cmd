@echo OFF
::vars
SETLOCAL ENABLEDELAYEDEXPANSION
set defloc=%~dp0
set domain=http://backup.xdev.lol
set downdomain=%domain%/omega-iii/omega-iii

::start settings

if "%1" == "clean-install" goto :reclone
if "%1" == "update-kernel" goto :update_kernel

:aftersubcommands

::checkup
if not exist "lib" goto :checkup_getlib
:checkup_afterlib
if exist "lib" goto :checkup_scanlib
:checkup_afterscanlib
if not exist "kernel.bat" goto :checkup_getkernel
:checkup_afterkernel


goto :checkup_after



::checkup assets
:checkup_scanlib
cd /d %defloc%lib
set currdownasset=certutil.exe
if not exist "%currdownasset%" echo %currdownasset% missing downloading
if not exist "%currdownasset%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
set currdownasset=cipher.exe
if not exist "%currdownasset%" echo %currdownasset% missing downloading
if not exist "%currdownasset%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
set currdownasset=curl.exe
if not exist "%currdownasset%" echo %currdownasset% missing downloading
if not exist "%currdownasset%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
set currdownasset=tar.exe
if not exist "%currdownasset%" echo %currdownasset% missing downloading
if not exist "%currdownasset%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
cd ..
goto :checkup_afterscanlib


:checkup_getlib
echo lib (library) not detected, they are essential tools for functioning, downloading...
mkdir lib
echo created folder "lib"
cd /d %defloc%lib
set currdownasset=certutil.exe
powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
echo downloaded "%currdownasset%"
set currdownasset=cipher.exe
powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
echo downloaded "%currdownasset%"
set currdownasset=curl.exe
powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
echo downloaded "%currdownasset%"
set currdownasset=tar.exe
powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
echo downloaded "%currdownasset%"
cd /d %defloc%
goto :checkup_afterlib

:checkup_getkernel
echo kernel not found, downloading using curl...
%defloc%lib\curl.exe %downdomain%/kernel.bat --output %defloc%kernel.bat
goto :checkup_afterkernel
::end

:checkup_after
::omega code ---

:terminal
set terminal=
set /p terminal=">"
goto :execcommand

:execcommand
if not defined terminal goto :terminal
if "%terminal%" == "exit" goto :ext
if "%terminal%" == "help" goto :help
if "%terminal%" == "clear" cls && goto :terminal

if not exist "%defloc%kernelhash.sha512" (
    echo kernelhash.sha512 not found, downloading...
    %defloc%lib\curl.exe %downdomain%/kernelhash.sha512 --output %defloc%kernelhash.sha512
)

set count=0
for /f "tokens=1* delims=:" %%A in ('"%defloc%lib\certutil.exe -hashfile %defloc%kernel.bat SHA512"') do (
    set /a count+=1
    if !count! EQU 2 (
        set "kernelhash=%%A %%B"
    )
)
set "kernelhash=%kernelhash:~0,-1%"

set count=0
for /f "tokens=*" %%A in (%defloc%kernelhash.sha512) do (
    set /a count+=1
    if !count! EQU 2 (
        set "setkernelhash=%%A"
    )
)

if "%kernelhash%" == "%setkernelhash%" (
    if exist "%defloc%kernel.bat" (
        call "%defloc%kernel.bat" %terminal%
    ) else (
        goto :kernelerror
    )
) else (
    echo kernel checksum mismatch
    echo kernelhash: "%kernelhash%"
    echo setkernelhash: "%setkernelhash%"
    goto :kernelerror
)

goto :terminal

:kernelerror
echo critical kernel error, maybe deleted? reinstalling.
%defloc%lib\curl.exe %downdomain%/kernel.bat --output %defloc%kernel.bat
goto :terminal

:help
if exist "%defloc%help.db" goto :givehelp
if not exist "%defloc%help.db" goto :gethelp

:gethelp
echo help.db not found installing
%defloc%lib\curl.exe %downdomain%/help.db --output %defloc%help.db

:givehelp
type help.db
echo.
goto :terminal


::omega code ---
goto :ext











:reclone
echo removing assest:
echo library
del %defloc%lib /q
rmdir lib
echo kernel
del kernel.bat
echo removed all current assets
echo help
del help.db

echo restarting
goto :aftersubcommands


:update_kernel
echo updating kernel
echo removing last kernel
del %defloc%kernel.bat
echo installing latest kernel
if exist "%defloc%lib\curl.exe" %defloc%lib\curl.exe %downdomain%/kernel.bat --output %defloc%kernel.bat
if exist %defloc%kernel.bat echo kernel successfully installed.
if not exist %defloc%kernel.bat echo kernel failed to install.
goto :aftersubcommands











:ext

