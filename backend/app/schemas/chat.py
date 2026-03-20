from typing import Optional, List, Any
from datetime import datetime
from pydantic import BaseModel


class ChatMessageBase(BaseModel):
    role: str
    content: str


class ChatMessageResponse(ChatMessageBase):
    id: str
    session_id: str
    sources: List[Any] = []
    tokens_used: Optional[str] = None
    model: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class ChatSessionCreate(BaseModel):
    title: Optional[str] = "New Chat"
    agent_type: Optional[str] = "general"


class ChatSessionResponse(BaseModel):
    id: str
    title: str
    user_id: str
    agent_type: str
    created_at: datetime
    updated_at: datetime
    messages: List[ChatMessageResponse] = []

    class Config:
        from_attributes = True


class DocumentQueryRequest(BaseModel):
    query: str
    document_id: Optional[str] = None
    session_id: Optional[str] = None


class ChatQueryResponse(BaseModel):
    query: str
    answer: str
    sources: List[Any] = []
    session_id: Optional[str] = None
    tokens_used: Optional[int] = None
