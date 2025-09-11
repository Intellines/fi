from pypika import Table, Schema, Query
from config import config

# schemas
default_schema = Schema(name=config.DEFAULT_SCHEMA)

# tables
schema_versions = Table("schema_versions", default_schema)
currencies = Table("currencies", default_schema)
users = Table("users", default_schema)
accounts = Table("accounts", default_schema)
assets = Table("assets", default_schema)
categories = Table("categories", default_schema)
transactions = Table("transactions", default_schema)
settings = Table("settings", default_schema)

if __name__ == "__main__":
    import asyncio
    from db import db_manager

    query: Query = Query.from_(schema_versions).select("*")
    query_str: str = str(query)
    print(query_str)

    async def try_query() -> None:
        async with db_manager() as conn:
            rows = await conn.fetch(query_str)
            print([dict(r) for r in rows])

    asyncio.run(try_query())
