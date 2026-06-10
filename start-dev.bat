@echo off
REM Set Node.js path
set PATH=C:\Program Files\nodejs;%PATH%

REM Navigate to project directory  
cd /d C:\xampp\htdocs\kok4ins

echo.
echo ========================================
echo Installing npm dependencies...
echo ========================================
call npm install

echo.
echo ========================================
echo Starting Vite development server...
echo ========================================
echo.
call npm run dev

pause
