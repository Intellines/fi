from pypika import Table
from config import config

schema_versions = Table(name="schema_versions", schema=config.DEFAULT_SCHEMA)
currencies = Table(name="currencies", schema=config.DEFAULT_SCHEMA)
users = Table(name="users", schema=config.DEFAULT_SCHEMA)
accounts = Table(name="accounts", schema=config.DEFAULT_SCHEMA)
assets = Table(name="assets", schema=config.DEFAULT_SCHEMA)
categories = Table(name="categories", schema=config.DEFAULT_SCHEMA)
transactions = Table(name="transactions", schema=config.DEFAULT_SCHEMA)
settings = Table(name="settings", schema=config.DEFAULT_SCHEMA)
