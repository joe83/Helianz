# rclone — Required for Hybrid Media Sync

This folder must contain `rclone.exe` for the hybrid media sync feature to work.

## Download

1. Go to https://rclone.org/downloads/
2. Download **Windows AMD64** zip (e.g. `rclone-v1.xx.0-windows-amd64.zip`)
3. Extract and copy `rclone.exe` into this folder

The build system will automatically include `rclone.exe` in the installer package.

## Verification

After placing `rclone.exe` here, build the project and verify:
- `Helianz\bin\Debug\rclone\rclone.exe` exists
- In the app: Edit Paths → Hybrid → "Test rclone Connection" should detect it
