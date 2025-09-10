from config import config
from logger import logger
from fastapi import Header, HTTPException, status


def validate_api_key(api_key=Header(alias="X-Api-Key")):
    if api_key != config.X_API_KEY:
        logger.warning(f"Unauthorized call [X-Api-Key] - {api_key[:10]}...")
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid X-Api-Key")
