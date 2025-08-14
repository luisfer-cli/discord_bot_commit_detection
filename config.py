import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


class Config:
    # Discord
    DISCORD_TOKEN = os.getenv('DISCORD_TOKEN')
    BACKEND_CHANNEL_ID = int(os.getenv('BACKEND_CHANNEL_ID', 0))
    FRONTEND_CHANNEL_ID = int(os.getenv('FRONTEND_CHANNEL_ID', 0))

    # Repositories
    BACKEND_OWNER = os.getenv('BACKEND_OWNER')
    BACKEND_REPO = os.getenv('BACKEND_REPO')
    BACKEND_BRANCH = os.getenv('BACKEND_BRANCH', 'main')

    FRONTEND_OWNER = os.getenv('FRONTEND_OWNER')
    FRONTEND_REPO = os.getenv('FRONTEND_REPO')
    FRONTEND_BRANCH = os.getenv('FRONTEND_BRANCH', 'main')

    # Configuration
    CHECK_INTERVAL = int(os.getenv('CHECK_INTERVAL', 10))
    VENV_PATH = os.getenv('VENV_PATH', './venv')

    @classmethod
    def validate(cls):
        required_vars = [
            'DISCORD_TOKEN',
            'BACKEND_CHANNEL_ID',
            'FRONTEND_CHANNEL_ID',
            'BACKEND_OWNER',
            'BACKEND_REPO',
            'FRONTEND_OWNER',
            'FRONTEND_REPO'
        ]

        missing_vars = []
        for var in required_vars:
            if not getattr(cls, var):
                missing_vars.append(var)

        if missing_vars:
            raise ValueError(f"Missing environment variables: {
                             ', '.join(missing_vars)}")

        return True
