@echo off
echo installutil.exe HelianzServer.exe
echo.
pushd "%~dp0"
installutil.exe HelianzServer.exe
popd
echo.
pause
