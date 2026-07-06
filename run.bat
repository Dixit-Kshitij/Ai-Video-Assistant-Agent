@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   🎬 AI Video Assistant Launcher (Windows)
echo ===================================================
echo.

:: Check for Python
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python was not found in your system PATH.
    echo Please install Python 3.10+ and make sure it is added to your PATH.
    pause
    exit /b 1
)

:: Check if virtual environment exists, if not create it
if not exist .venv (
    echo [INFO] Virtual environment '.venv' not found. Creating it...
    python -m venv .venv
    if !errorlevel! neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo [SUCCESS] Virtual environment created.
    echo.
)

:: Activate the virtual environment
echo [INFO] Activating virtual environment...
call .venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo [ERROR] Failed to activate virtual environment.
    pause
    exit /b 1
)

:: Install / Update dependencies
echo [INFO] Installing/updating dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed successfully.
echo.

:: Prompt for API keys if .env is missing
if not exist .env (
    echo [WARNING] .env file not found.
    echo Creating a default .env file. Please edit it and fill in your API keys!
    (
        echo MISTRAL_API_KEY=""
        echo SARVAM_API_KEY=""
        echo SARVAM_STT_MODEL="saaras:v3"
        echo FFMPEG_PATH=""
    ) > .env
)

:: Run the Streamlit application
echo [INFO] Starting Streamlit UI...
streamlit run app.py

pause
