from typing import ClassVar
from pydantic_settings import SettingsConfigDict, BaseSettings


class Config(BaseSettings):
    VERSION: str = "0.0.1"
    ENV: str
    HOST: str
    X_API_KEY: str
    DATABASE_URL: str

    LOGFIRE_TOKEN: str

    model_config: ClassVar[SettingsConfigDict] = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


config: Config = Config()  # type: ignore
