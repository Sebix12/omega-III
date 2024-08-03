@echo OFF
::vars
SETLOCAL ENABLEDELAYEDEXPANSION
set defloc=%~dp0
set domain=http://backup.xdev.lol
set downdomain=%domain%/omega-iii/omega-iii

::start settings

if "%1" == "clean-install" goto :reclone
if "%1" == "update-kernel" goto :update_kernel
if "%1" == "update-kernel-hash" goto :update_kernel_hash
if "%1" == "use-custom-kernel" goto :use_custom_kernel

if exist "%defloc%kernel.bat" call "%defloc%kernel.bat" setup



:aftercustomkernel
:aftercleaninstall
::checkup
if not exist "%defloc%lib" goto :checkup_getlib
:checkup_afterlib
if exist "%defloc%lib" goto :checkup_scanlib
:checkup_afterscanlib
if not exist "%defloc%kernel.bat" goto :checkup_getkernel
:checkup_afterkernel


goto :checkup_after



::checkup assets
:checkup_scanlib
cd /d "%defloc%lib"
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
set currdownasset=robocopy.exe
if not exist "%currdownasset%" echo %currdownasset% missing downloading
if not exist "%currdownasset%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"


cd ..
goto :checkup_afterscanlib


:checkup_getlib
echo lib (library) not detected, they are essential tools for functioning, downloading...
mkdir lib
echo created folder "lib"
cd /d "%defloc%lib"
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
set currdownasset=robocopy.exe
powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%currdownasset%', '%currdownasset%')"
echo downloaded "%currdownasset%"
cd /d "%defloc%"
goto :checkup_afterlib

:checkup_getkernel
echo kernel not found, downloading using curl...
"%defloc%lib\curl.exe" %downdomain%/kernel.bat --output "%defloc%kernel.bat"
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



if not exist "%defloc%kernelhash.sha512" (
    echo kernelhash.sha512 not found, downloading...
    "%defloc%lib\curl.exe" %downdomain%/kernelhash.sha512 --output "%defloc%kernelhash.sha512"
)

set count=0
for /f "tokens=1* delims=:" %%A in ('""%defloc%lib\certutil.exe" -hashfile %defloc%kernel.bat SHA512"') do (
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
"%defloc%lib\curl.exe" %downdomain%/kernel.bat --output "%defloc%kernel.bat"
goto :terminal




::omega code ---
goto :ext











:reclone
echo removing assest:
echo library
del "%defloc%lib" /q
rmdir lib
echo kernel
del "%defloc%kernel.bat"
echo removed all current assets
echo help
del help.db

echo restarting
goto :aftercleaninstall


:update_kernel
echo updating kernel
echo removing last kernel
if exist "%defloc%kernel.bat" del /Q "%defloc%kernel.bat"
echo installing latest kernel
if exist "%defloc%kernelhash.sha512" del /Q kernelhash.sha512
if exist "%defloc%lib\curl.exe" %defloc%lib\curl.exe %downdomain%/kernel.bat --output "%defloc%kernel.bat"
if exist "%defloc%kernel.bat" echo kernel successfully installed.
if not exist "%defloc%kernel.bat" echo kernel failed to install.
goto :ext

:update_kernel_hash
if exist "%defloc%kernelhash.sha512" del /Q "%defloc%kernelhash.sha512"
"%defloc%lib\certutil.exe" -hashfile "%defloc%kernel.bat" SHA512 > kernelhash.sha512
echo Updated kernel hash at %time% new hash:
"%defloc%lib\certutil.exe" -hashfile "%defloc%kernel.bat" SHA512
goto :ext

:use_custom_kernel
:: set defloc=C:\Users\Sebixteam\Desktop\omega\

if exist "%defloc%kernel.bat" echo deleting old kernel

if exist "%defloc%kernel.bat" del /Q "%defloc%kernel.bat"

copy /V /Y "F:\omega-III\kernel.bat" "%defloc%kernel.bat"

if exist "%defloc%kernel.bat" echo successfully copied %2 to %defloc%

if exist "%defloc%kernelhash.sha512" del /Q "%defloc%kernelhash.sha512"

"%defloc%lib\certutil.exe" -hashfile "%defloc%kernel.bat" SHA512 > kernelhash.sha512

call "%defloc%kernel.bat" setup
goto :aftercustomkernel








:ext

