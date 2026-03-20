"""Agents endpoint - manages AI sub-agents with Claude Code"""
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import anthropic
import asyncio

from app.core.config import settings
from app.core.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter()


class AgentTask(BaseModel):
    task_type: str  # "code", "research", "analysis", "document"
    prompt: str
    context: Optional[Dict[str, Any]] = None
    tools: Optional[List[str]] = None


class SubAgentResult(BaseModel):
    agent_type: str
    result: str
    tokens_used: int


class OrchestratorRequest(BaseModel):
    main_task: str
    sub_tasks: Optional[List[AgentTask]] = None
    parallel: bool = True


SYSTEM_PROMPTS = {
    "code": "You are an expert software engineer. Analyze code, write tests, refactor, and provide technical solutions.",
    "research": "You are a thorough research analyst. Gather information, synthesize findings, and provide comprehensive summaries.",
    "analysis": "You are a data analyst. Analyze data, identify patterns, and provide actionable insights.",
    "document": "You are a technical writer. Create clear, well-structured documentation and reports.",
}


async def run_sub_agent(
    client: anthropic.AsyncAnthropic,
    task: AgentTask,
) -> SubAgentResult:
    """Run a single sub-agent task"""
    system_prompt = SYSTEM_PROMPTS.get(task.task_type, "You are a helpful AI assistant.")

    messages = [{"role": "user", "content": task.prompt}]
    if task.context:
        context_str = "\n".join([f"{k}: {v}" for k, v in task.context.items()])
        messages[0]["content"] = f"Context:\n{context_str}\n\nTask: {task.prompt}"

    response = await client.messages.create(
        model="claude-opus-4-5",
        max_tokens=4096,
        system=system_prompt,
        messages=messages,
    )

    return SubAgentResult(
        agent_type=task.task_type,
        result=response.content[0].text,
        tokens_used=response.usage.input_tokens + response.usage.output_tokens,
    )


@router.post("/orchestrate")
async def orchestrate_agents(
    request: OrchestratorRequest,
    db: AsyncSession = Depends(get_db),
):
    """Orchestrate multiple sub-agents for complex tasks"""
    client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

    if not request.sub_tasks:
        # Auto-decompose the main task
        decompose_response = await client.messages.create(
            model="claude-opus-4-5",
            max_tokens=2048,
            system="You are a task orchestrator. Decompose complex tasks into subtasks. Respond with JSON array of {task_type, prompt} objects.",
            messages=[{"role": "user", "content": f"Decompose this task into subtasks: {request.main_task}"}],
        )
        # Parse decomposed tasks (simplified)
        sub_tasks = [AgentTask(task_type="analysis", prompt=request.main_task)]
    else:
        sub_tasks = request.sub_tasks

    if request.parallel:
        # Run sub-agents in parallel
        results = await asyncio.gather(
            *[run_sub_agent(client, task) for task in sub_tasks],
            return_exceptions=True,
        )
        results = [r for r in results if not isinstance(r, Exception)]
    else:
        # Run sequentially
        results = []
        for task in sub_tasks:
            result = await run_sub_agent(client, task)
            results.append(result)

    # Synthesize results with orchestrator
    synthesis_prompt = f"Main task: {request.main_task}\n\nSub-agent results:\n"
    for r in results:
        synthesis_prompt += f"\n[{r.agent_type}]: {r.result}\n"

    synthesis = await client.messages.create(
        model="claude-opus-4-5",
        max_tokens=4096,
        system="You are an expert synthesizer. Combine multiple agent results into a coherent final answer.",
        messages=[{"role": "user", "content": synthesis_prompt}],
    )

    return {
        "main_task": request.main_task,
        "sub_results": [r.dict() for r in results],
        "synthesis": synthesis.content[0].text,
        "total_tokens": sum(r.tokens_used for r in results) + synthesis.usage.input_tokens + synthesis.usage.output_tokens,
    }


@router.get("/types")
async def list_agent_types():
    """List available agent types"""
    return {"agent_types": list(SYSTEM_PROMPTS.keys())}
