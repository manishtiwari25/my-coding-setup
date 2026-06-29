#!/usr/bin/env bash
# Real token + USD usage for Claude Code sessions, from its local JSONL logs (ccusage schema).
# Sums message.usage.{input,output,cache_creation,cache_read}; cost from costUSD when present,
# else input+output+cache. Dedups by message.id+requestId. Usage: scripts/usage-claude.sh [session-id]
set -eu
DIR="${CLAUDE_CONFIG_DIR:-$HOME/.config/claude}/projects"
[ -d "$DIR" ] || DIR="$HOME/.claude/projects"
[ -d "$DIR" ] || { echo "No Claude logs (~/.config/claude or ~/.claude /projects). Real values appear after a claude session." >&2; exit 1; }
python3 - "$DIR" "${1:-}" <<'PY'
import json, sys, glob, os, collections
root, want = sys.argv[1], sys.argv[2]
S=collections.defaultdict(lambda:[0,0,0,0,0.0,0,collections.Counter()]); seen=set()
files=glob.glob(os.path.join(root,"*","*.jsonl"))+glob.glob(os.path.join(root,"*","*","chat.jsonl"))
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
        if m.get("model"): s[6][m["model"]]+=1
if not S: print("No matching Claude sessions"); raise SystemExit
for sid,(i,o,cw,cr,c,n,m) in sorted(S.items(),key=lambda x:-(x[1][0]+x[1][1]))[:10]:
    md=",".join(k for k,_ in m.most_common()) or "?"
    print(f"{sid[:18]} {i:>8,} in {o:>8,} out {cw+cr:>10,} cache  ${c:6.4f}  {n} msg  {md}")
PY
