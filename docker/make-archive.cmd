@echo off
setlocal

set OUT=%TEMP%\opendental-server.tar.gz
set SRC=D:\Project\PakRevi\opendental\OpenDentalNew

echo Creating archive from %SRC%
echo Output: %OUT%

"C:\Program Files\Git\usr\bin\tar.exe" -czf "%OUT%" ^
  --exclude=./.git ^
  --exclude=./**/bin ^
  --exclude=./**/obj ^
  --exclude=./Output ^
  --exclude=./OpenDental ^
  --exclude=./OpenDentalGraph ^
  --exclude=./OpenDentalWpf ^
  --exclude=./WpfControlsOD ^
  --exclude=./SparksToothChart ^
  --exclude=./Direct2dWrapper ^
  --exclude=./UnitTests ^
  --exclude=./UnitTestsCore ^
  --exclude=./OpenDentBusiness.Tests ^
  --exclude=./DatabaseIntegrityCheck ^
  --exclude=./xCrudGenerator ^
  --exclude=./QueryExecutor ^
  --exclude=./SlowQueryLogTool ^
  --exclude=./RdlDesign ^
  --exclude=./RdlEngine ^
  --exclude=./RdlViewer ^
  --exclude=./ODR ^
  --exclude=./ServiceManager ^
  --exclude=./MobileWeb ^
  --exclude=./WebCamOD ^
  --exclude=./PluginExample ^
  --exclude=./CentralManager ^
  --exclude=./CodeBaseStandard ^
  --exclude=./DataClassesOld ^
  --exclude=./packaging ^
  --exclude=./packages ^
  -C "%SRC%" .

if %ERRORLEVEL% EQU 0 (
  echo SUCCESS
  dir "%OUT%"
) else (
  echo FAILED with exit code %ERRORLEVEL%
)
endlocal
