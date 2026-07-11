#!/usr/bin/env bash
# Unified real-usage report across AI coding harnesses. Each collector reads the harness's
# own local logs — real tokens and runner-native cost, never a static price table. CLI and
# IDE entry points of the same product share the same logs, so one collector covers both:
#   claude    Claude Code (CLI, VS Code/JetBrains ext, desktop)  ~/.claude/projects
#   copilot   GitHub Copilot CLI                                 ~/.copilot/session-state
#   opencode  OpenCode (TUI + IDE)                               ~/.local/share/opencode
#   codex     OpenAI Codex (CLI + IDE extension)                 ~/.codex/sessions
#   vscode    VS Code Copilot Chat (built-in chat/agent)         VS Code chatSessions
#   cursor    Cursor IDE (agent/composer)                        Cursor state.vscdb
# vscode/cursor keep no token/cost data locally — those collectors print real session/model/
# turn data and point to the product's own usage dashboard for spend.
# Usage: docs/scripts/usage.sh [all|claude|copilot|opencode|codex|vscode|cursor] [session-id]
# Default "all": runs every harness whose logs exist on this machine; missing ones are
# listed as "not detected" and never fail the run.
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"
PICK="${1:-all}"; SID="${2:-}"
case "$PICK" in all|claude|copilot|opencode|codex|vscode|cursor) ;; *) SID="$PICK"; PICK="all" ;; esac
ran=0
run() { # $1 name  $2 data-dir  $3 script
    [ "$PICK" = "all" ] || [ "$PICK" = "$1" ] || return 0
    if [ -e "$2" ]; then
        echo "== $1 =="; "$HERE/$3" $SID || true; ran=1
    else
        [ "$PICK" = "$1" ] && { echo "$1: not detected ($2 missing)"; ran=1; } \
            || echo "== $1 == not detected"
    fi
    echo
}
run claude   "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"                        usage-claude.sh
run copilot  "${COPILOT_STATE_DIR:-$HOME/.copilot/session-state}"         usage-copilot.sh
run opencode "${OPENCODE_STORE:-$HOME/.local/share/opencode/storage/message}" usage-opencode.sh
run codex    "${CODEX_HOME:-$HOME/.codex}/sessions"                       usage-codex.sh
VSCODE_USER="$HOME/Library/Application Support/Code/User"
[ -d "$VSCODE_USER" ] || VSCODE_USER="$HOME/.config/Code/User"
run vscode   "$VSCODE_USER"                                               usage-vscode.sh
CURSOR_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb"
[ -f "$CURSOR_DB" ] || CURSOR_DB="$HOME/.config/Cursor/User/globalStorage/state.vscdb"
run cursor   "$CURSOR_DB"                                                 usage-cursor.sh
[ "$ran" = 1 ] || echo "No AI-harness logs detected on this machine."
