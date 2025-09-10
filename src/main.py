import time
from fastapi import APIRouter, FastAPI, Request
from fastapi.responses import RedirectResponse
from config import config
from logger import logger

import uvicorn

app = FastAPI(title="fi", version=config.VERSION)

app_router = APIRouter(prefix="/api/v1")


@app_router.get("/", include_in_schema=False)
async def main() -> RedirectResponse:
    return RedirectResponse("/api/v1/health")


@app_router.get("/health", include_in_schema=False)
async def health(request: Request):
    return {
        "service": f"[{config.ENV}] fi v{config.VERSION}",
        "client_ip": request.client.host if request.client else None,
        "server_timestamp": int(time.time()),
        "server_datetime": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),
    }


app.include_router(app_router)


if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, host=config.HOST, reload=True)
