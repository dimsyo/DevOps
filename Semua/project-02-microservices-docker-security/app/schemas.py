from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ItemCreate(BaseModel):
    title: str
    description: Optional[str] = None

class ItemResponse(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

class HealthResponse(BaseModel):
    status: str
    database: str
    redis: str
    timestamp: datetime
