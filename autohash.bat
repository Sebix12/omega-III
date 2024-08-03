@echo off
set defloc=%~dp0

:A

%defloc%lib\certutil.exe -hashfile %defloc%kernel.bat SHA512 > kernelhash.sha512
echo generated hash %time%
timeout /t 1 /nobreak > nul
goto :A