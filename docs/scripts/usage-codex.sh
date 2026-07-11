#!/usr/bin/env bash
# Real token usage for OpenAI Codex sessions (CLI and IDE extension share ~/.codex/sessions
# rollout logs). Reads the last token_count event per session: total_token_usage is the
# session-cumulative real count (input, cached input, output incl. reasoning). Codex logs
# expose no USD — cost prints the plan type instead; never guessed from a price table.
# Sessions sorted newest first. Usage: docs/scripts/usage-codex.sh [session-id]
set -eu
DIR="${CODEX_HOME:-$HOME/.codex}/sessions"
[ -d "$DIR" ] || { echo "No Codex logs ($DIR). Real values appear after a codex session." >&2; exit 1; }
python3 - "$DIR" "${1:-}" <<'PY'
import json, sys, os, glob, datetime
root, want = sys.argv[1], sys.argv[2]
files=sorted(glob.glob(os.path.join(root,"**","*.jsonl"), recursive=True), key=os.path.getmtime, reverse=True)
shown=0
for f in files:
    if shown>=10: break
    sid=os.path.basename(f); usage=None; model=None; plan=None; day=None
    for line in open(f, errors="ignore"):
        try: e=json.loads(line)
        except Exception: continue
        p=e.get("payload") or {}
        if e.get("type")=="session_meta": sid=p.get("id") or sid; day=(e.get("timestamp") or "")[:10]
        elif e.get("type")=="turn_context": model=p.get("model") or model
        elif p.get("type")=="token_count" or e.get("type")=="token_count":
            d=p if p.get("type")=="token_count" else e
            info=d.get("info") or {}
            if info.get("total_token_usage"): usage=info["total_token_usage"]
            rl=d.get("rate_limits") or {}
            plan=rl.get("plan_type") or plan
    if not usage: continue
    if want and want not in sid: continue
    if not day: day=datetime.date.fromtimestamp(os.path.getmtime(f)).isoformat()
    i=usage.get("input_tokens",0); o=usage.get("output_tokens",0); ca=usage.get("cached_input_tokens",0)
    print(f"{day} {sid[:14]} {i:>8,} in {o:>8,} out {ca:>11,} cache  n/a ({plan or 'plan'})  {model or '?'}")
    shown+=1
if not shown: print("No matching Codex sessions")
PY
