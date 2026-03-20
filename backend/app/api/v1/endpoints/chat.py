"""Chat endpoint with multi-turn conversations and Claude integration"""
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from typing import List, Optional, AsyncIterator
import anthropic
import json

from app.core.config import settings
from app.core.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter()


class Message(BaseModel):
    role: str  # "user" or "assistant"
    content: str


class ChatRequest(BaseModel):
    messages: List[Message]
    session_id: Optional[str] = None
    stream: bool = True
    model: str = "claude-opus-4-5"
    max_tokens: int = 4096
    system_prompt: Optional[str] = None


class ChatResponse(BaseModel):
    message: str
    session_id: str
    model: str
    input_tokens: int
    output_tokens: int


async def stream_claude_response(
    client: anthropic.AsyncAnthropic,
    messages: List[dict],
    model: str,
    max_tokens: int,
    system: Optional[str],
) -> AsyncIterator[str]:
    """Stream response from Claude"""
    kwargs = {
        "model": model,
        "max_tokens": max_tokens,
        "messages": messages,
    }
    if system:
        kwargs["system"] = system

    async with client.messages.stream(**kwargs) as stream:
        async for text in stream.text_stream:
            yield f"data: {json.dumps({'text': text})}\n\n"

        # Send final message with usage stats
        final_message = await stream.get_final_message()
        yield f"data: {json.dumps({'done': True, 'input_tokens': final_message.usage.input_tokens, 'output_tokens': final_message.usage.output_tokens})}\n\n"


@router.post("/")
async def chat(
    request: ChatRequest,
    db: AsyncSession = Depends(get_db),
):
    """Multi-turn chat endpoint with optional streaming"""
    client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

    messages = [{"role": m.role, "content": m.content} for m in request.messages]

    if request.stream:
        return StreamingResponse(
            stream_claude_response(
                client=client,
                messages=messages,
                model=request.model,
                max_tokens=request.max_tokens,
                system=request.system_prompt,
            ),
            media_type="text/event-stream",
            headers={
                "Cache-Control": "no-cache",
                "X-Accel-Buffering": "no",
            },
        )
    else:
        # Non-streaming response
        kwargs = {
            "model": request.model,
            "max_tokens": request.max_tokens,
            "messages": messages,
        }
        if request.system_prompt:
            kwargs["system"] = request.system_prompt

        response = await client.messages.create(**kwargs)
        return ChatResponse(
            message=response.content[0].text,
            session_id=request.session_id or "",
            model=response.model,
            input_tokens=response.usage.input_tokens,
            output_tokens=response.usage.output_tokens,
        )


@router.get("/sessions/{session_id}")
async def get_session_history(
    session_id: str,
    db: AsyncSession = Depends(get_db),
):
    """Get chat session history"""
    # TODO: Implement session history retrieval from database
    return {"session_id": session_id, "messages": []}
