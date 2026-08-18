import json
from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text
from datetime import datetime
from typing import List

from app.config import settings
from app.database import get_db, init_db, Item
from app.redis_client import get_redis_client, check_redis_health
from app.schemas import ItemCreate, ItemResponse, HealthResponse

app = FastAPI(
    title=settings.APP_NAME,
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

@app.on_event("startup")
def on_startup():
    print("Initializing Application & Database connection...")
    init_db()

@app.get("/", tags=["Root"])
def read_root():
    return {
        "service": settings.APP_NAME,
        "status": "online",
        "environment": settings.ENVIRONMENT,
        "message": "Welcome to Microservices Containerization Demo"
    }

@app.get("/health", response_model=HealthResponse, tags=["Health"])
def health_check(db: Session = Depends(get_db)):
    # Check PostgreSQL
    db_status = "healthy"
    try:
        db.execute(text("SELECT 1"))
    except Exception as e:
        db_status = f"unhealthy: {str(e)}"

    # Check Redis
    redis_ok = check_redis_health()
    redis_status = "healthy" if redis_ok else "unhealthy"

    overall_status = "healthy" if (db_status == "healthy" and redis_ok) else "degraded"

    return {
        "status": overall_status,
        "database": db_status,
        "redis": redis_status,
        "timestamp": datetime.utcnow()
    }

@app.get("/items", response_model=List[ItemResponse], tags=["Items"])
def get_items(db: Session = Depends(get_db)):
    redis = get_redis_client()
    cache_key = "items_list"

    # Try cache first
    try:
        cached_data = redis.get(cache_key)
        if cached_data:
            data = json.loads(cached_data)
            # Parse datetime strings back to datetime objects
            for item in data:
                item["created_at"] = datetime.fromisoformat(item["created_at"])
            return data
    except Exception as e:
        print(f"Redis read error: {e}")

    # Query DB
    items = db.query(Item).all()
    
    # Store in Redis (10s TTL)
    try:
        serializable_items = [
            {
                "id": item.id,
                "title": item.title,
                "description": item.description,
                "created_at": item.created_at.isoformat()
            }
            for item in items
        ]
        redis.setex(cache_key, 10, json.dumps(serializable_items))
    except Exception as e:
        print(f"Redis write error: {e}")

    return items

@app.post("/items", response_model=ItemResponse, status_code=status.HTTP_201_CREATED, tags=["Items"])
def create_item(item_in: ItemCreate, db: Session = Depends(get_db)):
    db_item = Item(title=item_in.title, description=item_in.description)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)

    # Invalidate cache
    try:
        redis = get_redis_client()
        redis.delete("items_list")
    except Exception as e:
        print(f"Redis delete error: {e}")

    return db_item
