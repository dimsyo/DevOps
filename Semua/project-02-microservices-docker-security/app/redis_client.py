import redis
from app.config import settings

def get_redis_client():
    kwargs = {
        "host": settings.REDIS_HOST,
        "port": settings.REDIS_PORT,
        "decode_responses": True,
        "socket_timeout": 3
    }
    if settings.REDIS_PASSWORD:
        kwargs["password"] = settings.REDIS_PASSWORD
        
    return redis.Redis(**kwargs)

def check_redis_health() -> bool:
    try:
        r = get_redis_client()
        return r.ping()
    except Exception as e:
        print(f"Redis health check failed: {e}")
        return False
