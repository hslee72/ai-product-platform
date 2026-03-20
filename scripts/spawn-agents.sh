#!/usr/bin/env bash
# =============================================================================
# spawn-agents.sh - Create git worktrees for all sub-agents
# Usage: ./scripts/spawn-agents.sh [feature-name]
# =============================================================================
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_DIR="${REPO_ROOT}/.worktrees"
FEATURE_NAME=${1:-"feature"}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[spawn-agents]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1"; exit 1; }

# Ensure we're in the repo root
cd "${REPO_ROOT}"

# Ensure git is clean
if ! git diff-index --quiet HEAD --; then
  warn "Working tree has uncommitted changes. Please commit or stash first."
  read -p "Continue anyway? (y/N): " confirm
  [[ "$confirm" == "y" ]] || exit 1
fi

# Create worktrees directory
mkdir -p "${WORKTREE_DIR}"

# Define agents and their worktree directories
declare -A AGENTS=(
  ["frontend"]="feat/${FEATURE_NAME}-frontend"
  ["backend"]="feat/${FEATURE_NAME}-backend"
  ["db"]="feat/${FEATURE_NAME}-db"
  ["llm"]="feat/${FEATURE_NAME}-llm"
  ["monitoring"]="feat/${FEATURE_NAME}-monitoring"
  ["observability"]="feat/${FEATURE_NAME}-observability"
  ["qa"]="feat/${FEATURE_NAME}-qa"
)

log "Creating git worktrees for all agents..."
log "Feature: ${FEATURE_NAME}"
echo

for AGENT in "${!AGENTS[@]}"; do
  BRANCH="${AGENTS[$AGENT]}"
  WORKTREE_PATH="${WORKTREE_DIR}/${FEATURE_NAME}-${AGENT}"
  
  if [[ -d "${WORKTREE_PATH}" ]]; then
    warn "Worktree already exists: ${WORKTREE_PATH}"
    continue
  fi
  
  log "Creating worktree for ${BLUE}${AGENT}${NC} agent..."
  
  # Create branch from main if it doesn't exist
  if git show-ref --verify --quiet "refs/heads/${BRANCH}"; then
    git worktree add "${WORKTREE_PATH}" "${BRANCH}"
  else
    git worktree add -b "${BRANCH}" "${WORKTREE_PATH}" main
  fi
  
  # Copy agent CLAUDE.md to worktree root
  cp "${REPO_ROOT}/agents/${AGENT}/CLAUDE.md" "${WORKTREE_PATH}/CLAUDE.md"
  
  log "  -> ${WORKTREE_PATH} (branch: ${BRANCH})"
done

echo
log "All worktrees created!"
echo
log "To spawn a Claude agent in a worktree:"
echo -e "  ${BLUE}cd ${WORKTREE_DIR}/${FEATURE_NAME}-frontend && claude${NC}"
echo
log "To list all worktrees:"
echo -e "  ${BLUE}git worktree list${NC}"
echo
log "To run all agents in parallel (requires tmux):"
echo -e "  ${BLUE}./scripts/tmux-agents.sh ${FEATURE_NAME}${NC}"
