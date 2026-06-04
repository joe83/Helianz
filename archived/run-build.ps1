$msbuild = "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe"
& $msbuild "D:\Project\PakRevi\opendental\Helia\Helianz.sln" /t:Build /p:Configuration=Debug /v:minimal /nologo 2>&1 | Out-File "D:\Project\PakRevi\opendental\Helia\build3.log"
Write-Host "Build exit: $LASTEXITCODE"
