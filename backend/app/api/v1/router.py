"""API v1 Router"""
from fastapi import APIRouter

from app.api.v1.endpoints import chat, agents, auth, documents

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(chat.router, prefix="/chat", tags=["chat"])
api_router.include_router(agents.router, prefix="/agents", tags=["agents"])
api_router.include_router(documents.router, prefix="/documents", tags=["documents"])
