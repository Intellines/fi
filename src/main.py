import time
import logfire
from contextlib import asynccontextmanager
from fastapi import APIRouter, FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from config import config
from logger import logger

import uvicorn

app = FastAPI(title="fi", version=config.VERSION)


# lifespan
@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info(f"Starting Server [{config.ENV}] v{config.VERSION}")
    try:
        yield
    except Exception:
        logger.exception("Failed starting server")
    finally:
        logger.warning(f"Shutting Down Serve [{config.ENV}] v{config.VERSION}")


app.router.lifespan_context = lifespan

# configure CORS policies
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)

# connect Logfire
logfire.instrument_fastapi(app, capture_headers=True)


# routers
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
