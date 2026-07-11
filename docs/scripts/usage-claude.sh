#!/usr/bin/env bash
# Real token usage for Claude Code sessions (CLI, VS Code/JetBrains extension, desktop app —
# all write the same ~/.claude/projects JSONL logs). Sums message.usage tokens, deduped by
# message.id+requestId. Cost: costUSD summed when the log has it (API-key runs); subscription
# plans don't write per-message USD, so cost prints "n/a (plan)" — never guessed from a price
# table. Sessions sorted newest first. Usage: docs/scripts/usage-claude.sh [session-id]
set -eu
ROOTS=""
for d in "${CLAUDE_CONFIG_DIR:-$HOME/.config/claude}/projects" "$HOME/.claude/projects"; do
    [ -d "$d" ] && ROOTS="$ROOTS $d"
done
[ -n "$ROOTS" ] || { echo "No Claude logs (~/.config/claude or ~/.claude /projects). Real values appear after a claude session." >&2; exit 1; }
python3 - "${1:-}" $ROOTS <<'PY'
import json, sys, glob, os, collections, datetime
want, roots = sys.argv[1], sys.argv[2:]
S=collections.defaultdict(lambda:[0,0,0,0,0.0,0,collections.Counter(),0.0]); seen=set()
files=[]
for root in roots:
    files+=glob.glob(os.path.join(root,"*","*.jsonl"))+glob.glob(os.path.join(root,"*","*","chat.jsonl"))
for f in files:
    b=os.path.basename(f); sid=os.path.basename(os.path.dirname(f)) if b=="chat.jsonl" else b[:-6]
    if want and want not in sid: continue
    for line in open(f, errors="ignore"):
        if '"usage"' not in line: continue
        try: e=json.loads(line)
        except Exception: continue
        m=e.get("message") or {}; u=m.get("usage") or {}
        if not u: continue
        k=(m.get("id"), e.get("requestId"))
        if k!=(None,None) and k in seen: continue
        seen.add(k); s=S[sid]
        s[0]+=u.get("input_tokens",0)or 0; s[1]+=u.get("output_tokens",0)or 0
        s[2]+=u.get("cache_creation_input_tokens",0)or 0; s[3]+=u.get("cache_read_input_tokens",0)or 0
        s[4]+=e.get("costUSD") or 0; s[5]+=1
        md=m.get("model")
        if md and md!="<synthetic>": s[6][md]+=1
    if sid in S: S[sid][7]=max(S[sid][7], os.path.getmtime(f))
if not S: print("No matching Claude sessions"); raise SystemExit
for sid,(i,o,cw,cr,c,n,m,mt) in sorted(S.items(),key=lambda x:-x[1][7])[:10]:
    md=",".join(k for k,_ in m.most_common()) or "?"
    cost=f"${c:.4f}" if c else "n/a (plan)"
    day=datetime.date.fromtimestamp(mt).isoformat() if mt else "?"
    print(f"{day} {sid[:14]} {i:>8,} in {o:>8,} out {cw+cr:>11,} cache  {cost:>10}  {n} msg  {md}")
PY
