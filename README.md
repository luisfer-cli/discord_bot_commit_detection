# Discord Bot - Notificador de Commits de GitHub

Este bot de Discord automatiza el envío de notificaciones cuando se detectan nuevos commits en repositorios de GitHub especificados.

## Características

- Monitoreo continuo de múltiples repositorios de GitHub
- Notificaciones automáticas en canales específicos de Discord
- Configuración flexible mediante variables de entorno
- Soporte para múltiples ramas y repositorios

## Requisitos Previos

- Python 3.7 o superior
- GitHub CLI (`gh`)
- Bot de Discord configurado
- Acceso a los repositorios que deseas monitorear

## Instalación

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd autocommit-detection
```

### 2. Crear entorno virtual

```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar GitHub CLI

```bash
gh auth login
```

### 5. Configurar variables de entorno

Copia el archivo de ejemplo y configura tus valores:

```bash
cp .env.example .env
```

Edita el archivo `.env` con tus datos:

```bash
# Bot de Discord
DISCORD_TOKEN=tu_token_de_discord_aqui
BACKEND_CHANNEL_ID=tu_id_del_canal_backend
FRONTEND_CHANNEL_ID=tu_id_del_canal_frontend

# Repositorios a monitorear
BACKEND_OWNER=VicthorVF21
BACKEND_REPO=ClickAppBackNet
BACKEND_BRANCH=main

FRONTEND_OWNER=VicthorVF21
FRONTEND_REPO=ClickAppReact
FRONTEND_BRANCH=main

# Intervalo de verificación (segundos)
CHECK_INTERVAL=10
```

## Configuración del Bot de Discord

### 1. Crear una aplicación en Discord

1. Ve a [Discord Developer Portal](https://discord.com/developers/applications)
2. Haz clic en "New Application"
3. Dale un nombre a tu aplicación

### 2. Crear el bot

1. Ve a la sección "Bot" en el panel lateral
2. Haz clic en "Add Bot"
3. Copia el token del bot (será tu `DISCORD_TOKEN`)

### 3. Configurar permisos

En la sección "Bot", habilita:

- Send Messages
- Read Message History

### 4. Obtener IDs de canales

1. Habilita el modo desarrollador en Discord (Configuración de usuario > Avanzado > Modo desarrollador)
2. Haz clic derecho en el canal donde quieres recibir notificaciones
3. Selecciona "Copiar ID"

## Uso

### Ejecutar el monitoreo

```bash
# Activar entorno virtual
source venv/bin/activate

# Ejecutar el script de monitoreo
./monitor.sh
```

### Ejecutar en segundo plano

```bash
nohup ./monitor.sh > monitor.log 2>&1 &
```

### Detener el monitoreo

```bash
# Encuentra el proceso
ps aux | grep monitor.sh

# Terminar el proceso
kill <PID>
```

## Estructura del Proyecto

```
autocommit-detection/
├── README.md              # Esta guía
├── requirements.txt       # Dependencias de Python
├── .env.example          # Plantilla de configuración
├── .gitignore            # Archivos a ignorar por Git
├── discord_bot.py        # Bot de Discord refactorizado
├── monitor.sh            # Script principal de monitoreo
└── config.py             # Configuración centralizada
```

## Personalización

### Modificar mensajes de notificación

Edita el archivo `discord_bot.py` en la función que envía mensajes para personalizar el contenido.

### Agregar más repositorios

1. Agrega las nuevas variables en `.env`
2. Modifica `monitor.sh` para incluir la lógica del nuevo repositorio
3. Configura el canal de Discord correspondiente

### Cambiar intervalo de verificación

Modifica la variable `CHECK_INTERVAL` en el archivo `.env`.

## Troubleshooting

### El bot no se conecta

1. Verifica que el token de Discord sea correcto
2. Asegúrate de que el bot tenga permisos en el servidor
3. Revisa que el bot esté invitado al servidor de Discord

### No se detectan commits

1. Verifica que GitHub CLI esté autenticado: `gh auth status`
2. Confirma que tengas acceso a los repositorios especificados
3. Revisa los logs del script para errores

### Problemas de permisos

```bash
chmod +x monitor.sh
```

