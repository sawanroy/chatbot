@echo off
:: Change to the directory of the batch script
cd /d %~dp0

:: Check if the venv folder exists
if exist venv (
    echo Virtual environment already exists.
) else (
    echo Creating virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo Error creating virtual environment.
        exit /b %errorlevel%
    )
)

echo Activating virtual environment...
call venv\Scripts\activate
if %errorlevel% neq 0 (
    echo Error activating virtual environment.
    exit /b %errorlevel%
)

:: Set PYTHONPATH to include virtual environment site-packages
set PYTHONPATH=%CD%\venv\Lib\site-packages;%PYTHONPATH%

:: Check if requirements.txt exists
if exist requirements.txt (
    echo requirements.txt file exists.
) else (
    echo requirements.txt file does not exist.
    exit /b 1
)

:: Check if the packages have already been installed
if exist .packages_installed (
    echo Required packages are already installed.
) else (
    echo Installing required packages...
    :: Start a new command shell that will run pip install and keep track of its progress
    start /wait cmd /c "pip install -r requirements.txt"
    if %errorlevel% neq 0 (
        echo Error installing packages.
        exit /b %errorlevel%
    )
    :: Create a flag file to indicate that packages have been installed
    echo Packages installed > .packages_installed
)

:: Check if the .env file exists
if exist .env (
    echo .env file exists.
) else (
    echo .env file does not exist. PLEASE CREATE THE .env FILE TO STORE GEMINI_API_KEY=your_key
    exit /b 1
)

echo Checking Gemini API key validity...
:: Run the Python script to check the API key
python check_api_key.py
if %errorlevel% neq 0 (
    echo Error checking API key.
    exit /b %errorlevel%
)

echo Starting application...
start "" python gradio_ui.py
if %errorlevel% neq 0 (
    echo Error starting application.
    exit /b %errorlevel%
)

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
