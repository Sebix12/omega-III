@echo OFF
setlocal EnableDelayedExpansion

set defloc=%~dp0
set domain=http://backup.xdev.lol
set downdomain=%domain%/omega-iii/omega-iii
set assets=certutil.exe cipher.exe curl.exe tar.exe

set kernelver=1.0

if "%1" == "checkup" goto :checkup

:checkup
echo :----------------------------:
if exist "%defloc%omega.cmd" echo omega found
if exist "%defloc%kernel.bat" echo kernel found : kernel seems to be fine, running on version: %kernelver%
if exist "%defloc%help.db" echo help db found
if exist "%defloc%db" echo DataBase Folder found

if not exist "%defloc%omega.cmd" echo omega not found
if not exist "%defloc%kernel.bat" echo kernel not found
if not exist "%defloc%help.db" echo help db not found
if not exist "%defloc%db" echo DataBase Folder not found

if not exist "%defloc%omega.cmd" (
    echo installing omega
    if exist "%defloc%lib\curl.exe" (
        "%defloc%lib\curl.exe" "%downdomain%/omega.cmd" --output "%defloc%omega.cmd"
    ) else (
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/omega.cmd', '%defloc%omega.cmd')"
    )
)

if not exist "%defloc%kernel.bat" (
    echo installing kernel
    if exist "%defloc%lib\curl.exe" (
        "%defloc%lib\curl.exe" "%downdomain%/kernel.bat" --output "%defloc%kernel.bat"
    ) else (
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/kernel.bat', '%defloc%kernel.bat')"
    )
)

if not exist "%defloc%help.db" (
    echo installing help db
    if exist "%defloc%lib\curl.exe" (
        "%defloc%lib\curl.exe" "%downdomain%/help.db" --output "%defloc%help.db"
    ) else (
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/help.db', '%defloc%help.db')"
    )
)

if not exist "%defloc%db" (
    echo creating DataBase Folder
    mkdir "%defloc%db"
    echo folder created
)

if not exist "%defloc%lib" (
    echo lib library not detected, they are essential tools for functioning, downloading...
    mkdir "%defloc%lib"
    echo created folder "lib"
)

cd /d "%defloc%lib"

for %%F in (%assets%) do (
    if not exist %%F (
        echo %%F missing, downloading...
        if exist "%defloc%lib\curl.exe" (
            "%defloc%lib\curl.exe" "%downdomain%/lib/%%F" --output "%%F"
        ) else (
            powershell -Command "(New-Object Net.WebClient).DownloadFile('%downdomain%/lib/%%F', '%%F')"
        )
        echo downloaded %%F
    )
)

cd /d "%defloc%"

echo :----------------------------:
goto :ext

:ext