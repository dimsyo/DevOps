import time
from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from app.config import settings

engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(100), nullable=False)
    description = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

def init_db(max_retries: int = 5, retry_interval: int = 2):
    """Wait for DB readiness and create tables"""
    for attempt in range(1, max_retries + 1):
        try:
            Base.metadata.create_all(bind=engine)
            print("Successfully initialized PostgreSQL database tables.")
            return True
        except Exception as e:
            print(f"[{attempt}/{max_retries}] Database connection failed: {e}. Retrying in {retry_interval}s...")
            time.sleep(retry_interval)
    print("Could not connect to PostgreSQL database after retries.")
    return False

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
