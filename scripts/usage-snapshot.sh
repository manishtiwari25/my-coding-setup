#!/usr/bin/env bash
# Extracts real model + token usage for a Copilot CLI session from its local event log.
# AIC used is a live status-line counter, NOT in the log — read it from `Session: N AIC used`.
# Usage: scripts/usage-snapshot.sh [session-id]   (local-dev only; reads ~/.copilot/session-state)
set -eu
STATE_DIR="${COPILOT_STATE_DIR:-$HOME/.copilot/session-state}"
if [ "${1:-}" != "" ]; then EVENTS="$STATE_DIR/$1/events.jsonl"
else EVENTS="$(ls -t "$STATE_DIR"/*/events.jsonl 2>/dev/null | head -1 || true)"; fi
[ -n "${EVENTS:-}" ] && [ -f "$EVENTS" ] || { echo "No events.jsonl (looked in $STATE_DIR)" >&2; exit 1; }
SESSION_ID="$(basename "$(dirname "$EVENTS")")"
python3 - "$EVENTS" "$SESSION_ID" <<'PY'
import json, sys, collections
events, sid = sys.argv[1], sys.argv[2]
out=collections.Counter(); msgs=collections.Counter(); total=0; ctx={}
for line in open(events):
    if '"type"' not in line: continue
    try: e=json.loads(line)
    except: continue
    t=e.get("type"); d=e.get("data",{}) or {}
    if t=="assistant.message":
        m=d.get("model","?"); ot=d.get("outputTokens",0) or 0
        if ot: out[m]+=ot; msgs[m]+=1; total+=ot
    elif t=="session.compaction_start":
        for k in ("systemTokens","conversationTokens","toolDefinitionsTokens"):
            if k in d: ctx[k]=d[k]
print(f"Session : {sid[:8]}"); print("Models  :")
for m,v in out.most_common(): print(f"  - {m:16s} {v:>10,} out tokens  ({msgs[m]} msgs)")
print(f"Output  : {total:,} total output tokens")
if ctx: print(f"Context : ~{sum(ctx.values()):,} @ last compaction {dict(ctx)}")
print("AIC used: <read from CLI status line: 'Session: N AIC used'>")
PY
