@echo off
REM Laravel + Tailwind CSS Development Server Starter
REM This script will install npm dependencies and start the dev server

cd /d "%~dp0"

echo.
echo ========================================
echo Laravel + Tailwind CSS Dev Server
echo ========================================
echo.

REM Check if node is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed!
    echo.
    echo Please install Node.js from https://nodejs.org/
    echo After installation, run this script again.
    pause
    exit /b 1
)

echo Node.js version:
node --version

echo.
echo npm version:
npm --version

REM Check if node_modules exists
if not exist "node_modules" (
    echo.
    echo Installing npm dependencies... (first time only)
    echo This may take 1-5 minutes...
    echo.
    call npm install
    if errorlevel 1 (
        echo ERROR: npm install failed!
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo Starting Vite development server...
echo ========================================
echo.
echo The app will be available at:
echo  - http://localhost:5173 (Vite dev server)
echo  - http://localhost (PHP via XAMPP)
echo.
echo Press Ctrl+C to stop the server
echo.

call npm run dev

pause
