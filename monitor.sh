#!/bin/bash

# Load configuration from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
else
    echo "❌ Archivo .env no encontrado. Copia .env.example a .env y configúralo."
    exit 1
fi

# Verify required variables
required_vars=("DISCORD_TOKEN" "BACKEND_OWNER" "BACKEND_REPO" "FRONTEND_OWNER" "FRONTEND_REPO")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Variable de entorno $var no está configurada"
        exit 1
    fi
done

# Default values
BACKEND_BRANCH=${BACKEND_BRANCH:-"main"}
FRONTEND_BRANCH=${FRONTEND_BRANCH:-"main"}
CHECK_INTERVAL=${CHECK_INTERVAL:-10}
VENV_PATH=${VENV_PATH:-"./venv"}

echo "🤖 Iniciando monitoreo de repositorios..."
echo "📁 Backend: $BACKEND_OWNER/$BACKEND_REPO (rama: $BACKEND_BRANCH)"
echo "📁 Frontend: $FRONTEND_OWNER/$FRONTEND_REPO (rama: $FRONTEND_BRANCH)"
echo "⏱️ Intervalo de verificación: ${CHECK_INTERVAL}s"
echo ""

# Last known commits (initially empty)
last_commit_back=""
last_commit_front=""

# Function to activate virtual environment and run bot
send_discord_message() {
    local channel_type=$1
    echo "📤 Enviando notificación de $channel_type..."
    
    if [ -d "$VENV_PATH" ]; then
        source "$VENV_PATH/bin/activate"
        python discord_bot.py "$channel_type"
        deactivate
    else
        echo "⚠️ Entorno virtual no encontrado en $VENV_PATH"
        python discord_bot.py "$channel_type"
    fi
}

while true; do
    #### BACKEND ####
    latest_back=$(gh api repos/$BACKEND_OWNER/$BACKEND_REPO/commits?sha=$BACKEND_BRANCH --jq '.[0] | {sha: .sha, date: .commit.author.date, message: .commit.message}' 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        latest_sha_back=$(echo "$latest_back" | jq -r '.sha')
        
        if [[ -z "$last_commit_back" ]]; then
            last_commit_back=$latest_sha_back
            echo "🔄 Inicializado monitoreo del backend (commit: ${latest_sha_back:0:7})"
        fi
        
        if [[ "$latest_sha_back" != "$last_commit_back" ]]; then
            echo "🆕 Nuevo commit detectado en Backend:"
            echo "$latest_back" | jq '.'
            last_commit_back=$latest_sha_back
            send_discord_message "backend"
        fi
    else
        echo "⚠️ Error al obtener commits del backend"
    fi
    
    #### FRONTEND ####
    latest_front=$(gh api repos/$FRONTEND_OWNER/$FRONTEND_REPO/commits?sha=$FRONTEND_BRANCH --jq '.[0] | {sha: .sha, date: .commit.author.date, message: .commit.message}' 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        latest_sha_front=$(echo "$latest_front" | jq -r '.sha')
        
        if [[ -z "$last_commit_front" ]]; then
            last_commit_front=$latest_sha_front
            echo "🔄 Inicializado monitoreo del frontend (commit: ${latest_sha_front:0:7})"
        fi
        
        if [[ "$latest_sha_front" != "$last_commit_front" ]]; then
            echo "🆕 Nuevo commit detectado en Frontend:"
            echo "$latest_front" | jq '.'
            last_commit_front=$latest_sha_front
            send_discord_message "frontend"
        fi
    else
        echo "⚠️ Error al obtener commits del frontend"
    fi
    
    sleep $CHECK_INTERVAL
done