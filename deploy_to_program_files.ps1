Stop-Process -Name Helianz -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
$source = "D:\Project\Dental\Helianz\Output\Helianz\*"
$dest = "C:\Program Files (x86)\Helianz\"
Write-Host "Copying from $source to $dest..."
Copy-Item -Path $source -Destination $dest -Recurse -Force
Write-Host "Copy completed successfully."
