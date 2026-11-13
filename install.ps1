$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$url = "https://github.com/aashishraj03/syncsetu-releases/releases/latest/download/SyncSetu-windows.zip"
$dir = Join-Path $env:LOCALAPPDATA "SyncSetu"
$zip = Join-Path $env:TEMP "SyncSetu-windows.zip"

Write-Host "Installing SyncSetu..."

# Close a running copy so files can be replaced
Get-Process SyncSetu -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

if (Test-Path $dir) { Remove-Item $dir -Recurse -Force }
Expand-Archive -Path $zip -DestinationPath $dir -Force
Remove-Item $zip -Force
Get-ChildItem $dir -Recurse | Unblock-File

# Start Menu shortcut
$exe = Join-Path $dir "SyncSetu.exe"
$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("Programs")) "SyncSetu.lnk"))
$lnk.TargetPath = $exe
$lnk.WorkingDirectory = $dir
$lnk.Save()

Start-Process $exe
Write-Host "SyncSetu is installed and running. Look for it in the system tray (bottom right)."
