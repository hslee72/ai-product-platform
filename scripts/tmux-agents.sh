#!/usr/bin/env bash
# =============================================================================
# tmux-agents.sh - Launch all Claude agents in parallel tmux sessions
# Usage: ./scripts/tmux-agents.sh [feature-name]
# Requires: tmux, claude CLI
# =============================================================================
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_DIR="${REPO_ROOT}/.worktrees"
FEATURE_NAME=${1:-"feature"}
SESSION_NAME="agents-${FEATURE_NAME}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[tmux-agents]${NC} $1"; }

# Check dependencies
command -v tmux >/dev/null 2>&1 || { echo "tmux is required but not installed."; exit 1; }
command -v claude >/dev/null 2>&1 || { echo "claude CLI is required. Install with: npm i -g @anthropic-ai/claude-code"; exit 1; }

# Kill existing session if exists
tmux kill-session -t "${SESSION_NAME}" 2>/dev/null || true

log "Starting multi-agent tmux session: ${SESSION_NAME}"

# Create new session with orchestrator window
tmux new-session -d -s "${SESSION_NAME}" -n "orchestrator" -x 220 -y 50
tmux send-keys -t "${SESSION_NAME}:orchestrator" "cd ${REPO_ROOT} && echo 'PO/Orchestrator - Main Branch' && git status" Enter

# Define agents
AGENTS=("frontend" "backend" "db" "llm" "monitoring" "observability" "qa")

for AGENT in "${AGENTS[@]}"; do
  WORKTREE_PATH="${WORKTREE_DIR}/${FEATURE_NAME}-${AGENT}"
  
  if [[ ! -d "${WORKTREE_PATH}" ]]; then
    log "Worktree not found for ${AGENT}. Run spawn-agents.sh first."
    continue
  fi
  
  # Create new window for each agent
  tmux new-window -t "${SESSION_NAME}" -n "${AGENT}"
  tmux send-keys -t "${SESSION_NAME}:${AGENT}" "cd ${WORKTREE_PATH}" Enter
  tmux send-keys -t "${SESSION_NAME}:${AGENT}" "echo '=== ${AGENT^^} AGENT ==='" Enter
  tmux send-keys -t "${SESSION_NAME}:${AGENT}" "cat CLAUDE.md | head -20" Enter
  # Uncomment to auto-launch claude:
  # tmux send-keys -t "${SESSION_NAME}:${AGENT}" "claude" Enter
  
  log "  Created window: ${AGENT} -> ${WORKTREE_PATH}"
done

# Switch back to orchestrator window
tmux select-window -t "${SESSION_NAME}:orchestrator"

# Attach to session
log "Attaching to tmux session..."
log "Switch between agents: Ctrl+B then window number (0=orchestrator, 1=frontend, etc.)"
log "To detach: Ctrl+B then D"
echo
tmux attach-session -t "${SESSION_NAME}"
