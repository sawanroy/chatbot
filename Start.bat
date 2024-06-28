@echo off
:: Change to the directory of the batch script
cd /d %~dp0

:: Check if the venv folder exists
if exist venv (
    echo Virtual environment already exists.
) else (
    echo Creating virtual environment...
    python -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

:: Set PYTHONPATH to include virtual environment site-packages
set PYTHONPATH=%CD%\venv\Lib\site-packages;%PYTHONPATH%

:: Check if the packages have already been installed
if exist .packages_installed (
    echo Required packages are already installed.
) else (
    echo Installing required packages...
    :: Start a new command shell that will run pip install and keep track of its progress
    start /wait cmd /c "pip install -r requirements.txt"
    :: Create a flag file to indicate that packages have been installed
    echo Packages installed > .packages_installed
)

echo Checking Gemini API key validity...
:: Run the Python script to check the API key
python check_api_key.py

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
    timeout /t 1 >nul
    goto loading
)

echo Application started!
pause
