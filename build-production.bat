@echo off
REM Test production build for Vercel
REM This script will build and check for errors

echo.
echo ========================================
echo Building for Production (Vercel)
echo ========================================
echo.

cd /d C:\xampp\htdocs\kok4ins

REM Set Node.js path
set PATH=C:\Program Files\nodejs;%PATH%

REM Run build
call npm run build

echo.
echo ========================================
if %ERRORLEVEL% EQU 0 (
    echo ✅ BUILD SUCCESSFUL!
    echo.
    echo Output directory: public/dist/
    echo.
    echo Ready to deploy to Vercel!
    echo.
    echo Next: Run 'vercel' or upload to Vercel Dashboard
) else (
    echo ❌ BUILD FAILED!
    echo.
    echo Check errors above and fix them.
    echo.
)
echo ========================================

pause
