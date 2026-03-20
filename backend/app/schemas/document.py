from typing import Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel


class DocumentBase(BaseModel):
    filename: str


class DocumentResponse(BaseModel):
    id: str
    filename: str
    original_filename: str
    content_type: Optional[str] = None
    size: Optional[int] = None
    status: str
    chunk_count: int
    owner_id: str
    created_at: datetime

    class Config:
        from_attributes = True


class DocumentListResponse(BaseModel):
    documents: list[DocumentResponse]
    total: int


class DocumentQueryRequest(BaseModel):
    query: str
    top_k: int = 5
    document_ids: Optional[list[str]] = None


class DocumentQueryResponse(BaseModel):
    query: str
    results: list[Dict[str, Any]]
    total: int
