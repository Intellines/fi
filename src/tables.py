from pypika import Table, Schema
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
