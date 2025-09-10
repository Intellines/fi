import asyncpg
from config import config
from contextlib import asynccontextmanager


@asynccontextmanager
async def db_manager():
    connection: asyncpg.Connection = await asyncpg.connect(config.DATABASE_URL)
    try:
        yield connection
    finally:
        if connection:
            await connection.close()


async def get_session():
    async with db_manager() as connection:
        yield connection
