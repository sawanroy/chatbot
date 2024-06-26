@echo off
cd /d d:\chatbot

echo Creating virtual environment...
call python -m venv venv

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing required packages...
:: Start a new command shell that will run pip install and keep track of its progress
start "" /wait cmd /c "pip install -r requirements.txt"

echo Starting application...
start "" python gradio_ui.py

:: Simple loading bar loop to indicate application is starting
echo.
echo Please wait while the application starts...
set /a counter=0
:loading
set /a counter+=1
if %counter% leq 30 (
    set /p dummy=.
    ping -n 2 localhost >nul
    goto loading
)

echo Application started!
pause
