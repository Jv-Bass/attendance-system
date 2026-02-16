@echo off
echo ====================================
echo Supabase Database Setup
echo ====================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo Error: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)

echo Installing dependencies...
npm install @supabase/supabase-js >nul 2>&1

echo Creating database tables...
node create-tables.js

echo.
echo ====================================
echo Setup complete!
echo ====================================
pause
