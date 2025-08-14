import discord
import sys
import os
from config import Config

def main():
    # Validate configuration
    try:
        Config.validate()
    except ValueError as e:
        print(f"❌ Error de configuración: {e}")
        sys.exit(1)
    
    # Verify that the channel parameter was passed
    if len(sys.argv) < 2:
        print("Uso: python discord_bot.py <TIPO_CANAL>")
        print("Tipos disponibles: backend, frontend")
        sys.exit(1)
    
    channel_type = sys.argv[1].lower()
    
    # Determine the channel based on type
    if channel_type == "backend":
        CHANNEL_ID = Config.BACKEND_CHANNEL_ID
        message = "🚀 Se actualizó el repositorio del **Backend**"
    elif channel_type == "frontend":
        CHANNEL_ID = Config.FRONTEND_CHANNEL_ID
        message = "🎨 Se actualizó el repositorio del **Frontend**"
    else:
        print(f"❌ Tipo de canal inválido: {channel_type}")
        print("Tipos disponibles: backend, frontend")
        sys.exit(1)
    
    # Configure intents
    intents = discord.Intents.default()
    client = discord.Client(intents=intents)
    
    @client.event
    async def on_ready():
        print(f"✅ Bot conectado como: {client.user}")
        canal = client.get_channel(CHANNEL_ID)
        
        if canal is None:
            print(f"❌ No se pudo encontrar el canal con ID {CHANNEL_ID}")
        else:
            try:
                await canal.send(message)
                print(f"📤 Mensaje enviado correctamente al canal {channel_type}")
            except Exception as e:
                print(f"⚠️ Error al enviar mensaje: {e}")
        
        await client.close()
        print("🔌 Bot desconectado")
    
    # Run the bot
    client.run(Config.DISCORD_TOKEN)

if __name__ == "__main__":
    main()