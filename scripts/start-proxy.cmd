@echo off
setlocal

set CONFIG_DIR=%USERPROFILE%\.config\antigravity-proxy
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

:: Ensure config has port 8085
if not exist "%CONFIG_DIR%\config.json" (
    echo {"port": 8085, "strategy": "hybrid"} > "%CONFIG_DIR%\config.json"
)

:: Find entry script
set SCRIPT_DIR=%~dp0..
set ENTRY=""
if exist "%SCRIPT_DIR%\src\proxy\index.js" (
    set ENTRY=%SCRIPT_DIR%\src\proxy\index.js
) else if exist "%APPDATA%\npm\node_modules\antigravity-claude-proxy\src\index.js" (
    set ENTRY=%APPDATA%\npm\node_modules\antigravity-claude-proxy\src\index.js
)

if "%ENTRY%"=="" (
    echo [!] Error: Proxy entry file not found.
    exit /b 1
)

echo [*] Launching Antigravity Gemini Proxy service on port 8085...
set PORT=8085
start "" /b node "%ENTRY%" > "%CONFIG_DIR%\server.log" 2>&1
timeout /t 2 /nobreak >nul
echo [OK] Proxy service is running.
