import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "FastAPI Microservice"
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "production")
    
    # PostgreSQL Configuration
    POSTGRES_USER: str = os.getenv("POSTGRES_USER", "postgres")
    POSTGRES_PASSWORD: str = os.getenv("POSTGRES_PASSWORD", "postgres_password")
    POSTGRES_DB: str = os.getenv("POSTGRES_DB", "microservices_db")
    POSTGRES_HOST: str = os.getenv("POSTGRES_HOST", "postgres-db")
    POSTGRES_PORT: int = int(os.getenv("POSTGRES_PORT", 5432))
    
    # Redis Configuration
    REDIS_HOST: str = os.getenv("REDIS_HOST", "redis-cache")
    REDIS_PORT: int = int(os.getenv("REDIS_PORT", 6379))
    REDIS_PASSWORD: str = os.getenv("REDIS_PASSWORD", "")

    @property
    def DATABASE_URL(self) -> str:
        return f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"

settings = Settings()
