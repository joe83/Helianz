@echo off
echo installutil.exe /u HelianzServer.exe
echo.
pushd "%~dp0"
installutil.exe /u HelianzServer.exe
popd
echo.
pause
