#!/usr/bin/env bash
# Real USD cost + token usage for OpenCode sessions, from its local message store.
# Cost is OpenCode's own per-message USD (real, no price-table guessing). All tokens summed.
# Usage: scripts/usage-opencode.sh [session-id]   (default: highest-cost session)
set -eu
STORE="${OPENCODE_STORE:-$HOME/.local/share/opencode/storage/message}"
[ -d "$STORE" ] || { echo "No OpenCode store ($STORE)" >&2; exit 1; }
python3 - "$STORE" "${1:-}" <<'PY'
import json, sys, glob, os, collections
store, want = sys.argv[1], sys.argv[2]
S=collections.defaultdict(lambda:[0.0,0,0,0,0,collections.Counter()])  # cost,in,out,cache,msgs,models
for f in glob.glob(os.path.join(store,"*","*.json")):
    try: d=json.load(open(f))
    except Exception: continue
    if d.get("role")!="assistant": continue
    sid=d.get("sessionID") or os.path.basename(os.path.dirname(f))
    if want and want not in sid: continue
    t=d.get("tokens") or {}; c=t.get("cache") or {}; s=S[sid]
    s[0]+=d.get("cost") or 0; s[1]+=t.get("input",0)or 0; s[2]+=t.get("output",0)or 0
    s[3]+=(c.get("read",0)or 0)+(c.get("write",0)or 0); s[4]+=1
    if d.get("modelID"): s[5][d["modelID"]]+=1
if not S: print("No matching OpenCode sessions"); raise SystemExit
for sid,(cost,i,o,ca,n,m) in sorted(S.items(),key=lambda x:-x[1][0])[:10]:
    md=",".join(k for k,_ in m.most_common()) or "?"
    print(f"{sid[:22]} ${cost:7.4f}  {i:>9,} in {o:>8,} out {ca:>11,} cache  {n} msg  {md}")
PY
