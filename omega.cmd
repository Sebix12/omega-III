@echo OFF
if "%1" == "clean-install" goto :reclone

::vars
set defloc=%~dp0
set domain=http://backup.xdev.lol
set downdomain=%domain%/omega-iii/omega-iii

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
if exist "curr"
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


:reclone



:ext

