#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "==================================================="
echo "  🎬 AI Video Assistant Launcher (macOS/Linux)"
echo "==================================================="
echo

# Check for python3
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] python3 could not be found. Please install Python 3.10+."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "[INFO] Creating virtual environment '.venv'..."
    python3 -m venv .venv
    echo "[SUCCESS] Virtual environment created."
    echo
fi

# Activate virtual environment
echo "[INFO] Activating virtual environment..."
source .venv/bin/activate

# Install / update dependencies
echo "[INFO] Installing/updating dependencies..."
python3 -m pip install --upgrade pip
pip install -r requirements.txt
echo "[SUCCESS] Dependencies installed successfully."
echo

# Create template .env if it is missing
if [ ! -f ".env" ]; then
    echo "[WARNING] .env file not found. Creating template..."
    cat <<EOT > .env
MISTRAL_API_KEY=""
SARVAM_API_KEY=""
SARVAM_STT_MODEL="saaras:v3"
FFMPEG_PATH=""
EOT
    echo "[INFO] Created template .env. Please fill in your API keys."
fi

# Start the Streamlit application
echo "[INFO] Starting Streamlit UI..."
streamlit run app.py
