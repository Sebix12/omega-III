::@echo OFF
setlocal EnableDelayedExpansion
set kernelver=1.0
set defloc=%~dp0
set domain=http://backup.xdev.lol
set downdomain=%domain%/omega-iii/omega-iii
set assets=certutil.exe cipher.exe curl.exe tar.exe 

::oh no
if "%1" == "checkup" goto :checkup
if "%1" == "fs" goto :fs
if "%1" == "pl" goto :pl
if "%1" == "help" goto :help
if "%1" == "kernel" goto :kernel
if "%1" == "clear" cls && goto :ext
if "%1" == "dir" dir /b && goto :ext
if "%1" == "ls" dir /b && goto :ext
if "%1" == "tree" tree && goto :ext
if "%1" == "setup" goto :onecall

echo command not found
goto :ext



:pl
if exist %defloc%db cd /d %defloc%db
if "%2" == "list" goto :pl_list
if "%2" == "run" goto :pl_run
if "%2" == "remove" goto :pl_remove
if "%2" == "get" goto :pl_getpl
echo not supported yet...
goto :ext

:pl_list
cd /d "%defloc%db"
dir /b /x *.db
cd /d "%defloc%"
goto :ext

:pl_run
if not exist "%defloc%db\%3.db" goto :runnotexist 
"%defloc%lib\certutil.exe" -decode "%defloc%db\%3.db" "%defloc%db\%3.bat" >> NUL
call "%defloc%db\%3.bat"
del /q "%defloc%db\%3.bat"
goto :ext

:runnotexist
echo %3 does not exist try "pl list"
goto :ext

:pl_remove
if exist "%defloc%db\%3.bat" del /q "%defloc%db\%3.bat" && echo removed %3.bat
if exist "%defloc%db\%3.db" del /q "%defloc%db\%3.db" && echo removed %3.db
goto :ext

:pl_getpl
if exist "%defloc%db\%3.db" echo %3 is already downloaded
if exist "%defloc%db\%3.db" goto :ext
echo downloading "%3" %downdomain%/plugin-repo/%3.db
"%defloc%lib\curl.exe" %downdomain%/plugin-repo/%3.db --output "%defloc%db\%3.db"
if exist "%defloc%db\%3.db" echo download succeeded
if not exist "%defloc%db\%3.db" echo download failed
goto :ext


:fs
if "%2" == "rm" goto :fs_rm
if "%2" == "mkdir" goto :fs_mkdir
if "%2" == "rmdir" goto :fs_rmdir
if "%2" == "run" goto :fs_run
echo not yet supported...
goto :ext
::------

:fs_rm
if exist "%3" del "%3"
echo deleted file: %3
goto :ext
::------
:fs_mkdir
if not exist "%3" mkdir "%3"
echo created folder %3
goto :ext
::------
:fs_rmdir
rmdir "%3"
echo deleted %3
goto :ext
::------
:fs_run
if not exist "%3" echo %3 does not exist.
if not exist "%3" goto :ext
if exist "%3" echo %3 found, running it...
call "%3" %4
goto :ext
::------
goto :ext


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



:help
if exist "%defloc%help.db" goto :givehelp
if not exist "%defloc%help.db" goto :gethelp

:gethelp
echo help.db not found installing
"%defloc%lib\curl.exe" %downdomain%/help.db --output "%defloc%help.db"

:givehelp
type help.db
echo.
goto :ext

:kernel
if "%2" == "version" echo kernel version: %kernelver% && goto :ext
if "%2" == "debug" goto :KBS
if "%2" == "hash" type "%defloc%kernelhash.sha512" && goto :ext

echo command not supported yet...
goto :ext

:onecall
echo Kernel launch succeeded
goto :ext

:KBS
ECHO %3
goto :ext


goto :ext

:ext
cd /d %defloc%