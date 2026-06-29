#!/usr/bin/env bash
# Real model + token + AI-credit usage for a GitHub Copilot CLI session, from its local event log.
# Closed session  -> canonical session.shutdown.modelMetrics (real in/out/cache per model + AIC,
#                    subagents included). AIC = totalNanoAiu / 1e9; 1 AIC ~= $0.01 USD.
# Running session -> interim sum of main output + every subagent total (paste AIC from status line).
# Always prints real values; never crashes. Usage: scripts/usage-snapshot.sh [session-id]
set -eu
STATE_DIR="${COPILOT_STATE_DIR:-$HOME/.copilot/session-state}"
if [ "${1:-}" != "" ]; then EVENTS="$STATE_DIR/$1/events.jsonl"
else EVENTS="$(ls -t "$STATE_DIR"/*/events.jsonl 2>/dev/null | head -1 || true)"; fi
[ -n "${EVENTS:-}" ] && [ -f "$EVENTS" ] || { echo "No events.jsonl (looked in $STATE_DIR)" >&2; exit 1; }
SESSION_ID="$(basename "$(dirname "$EVENTS")")"
python3 - "$EVENTS" "$SESSION_ID" <<'PY'
import json, sys, collections
events, sid = sys.argv[1], sys.argv[2]
out=collections.Counter(); msgs=collections.Counter(); main_out=0
sub=collections.Counter(); subn=collections.Counter(); sub_tot=0
model=tier=effort=None; ctx={}; shut=None
for line in open(events, errors="ignore"):
    if '"type"' not in line: continue
    try: e=json.loads(line)
    except Exception: continue
    t=e.get("type"); d=e.get("data",{}) or {}
    if t=="session.start":
        model=d.get("selectedModel") or model; tier=d.get("contextTier"); effort=d.get("reasoningEffort")
    elif t=="assistant.message":
        ot=d.get("outputTokens",0) or 0
        if ot: m=d.get("model","?"); out[m]+=ot; msgs[m]+=1; main_out+=ot
    elif t=="subagent.completed":
        tk=d.get("totalTokens",0) or 0; sub[d.get("model","?")]+=tk; subn[d.get("model","?")]+=1; sub_tot+=tk
    elif t in ("session.compaction_start","session.shutdown","session.truncation"):
        for k in ("systemTokens","conversationTokens","toolDefinitionsTokens","currentTokens"):
            if isinstance(d.get(k),int): ctx[k]=d[k]
        if t=="session.shutdown": shut=d
print(f"Session : {sid[:8]}   Model: {model or 'mixed'}  tier={tier} effort={effort}")
mm=(shut or {}).get("modelMetrics") or {}
if mm:                                  # canonical real totals (incl. subagents)
    ti=to=tc=0; aic=0.0
    for m,v in sorted(mm.items(), key=lambda x:-(x[1].get("totalNanoAiu",0) or 0)):
        u=v.get("usage",{}); i=u.get("inputTokens",0); o=u.get("outputTokens",0)
        cr=u.get("cacheReadTokens",0); cw=u.get("cacheWriteTokens",0); a=(v.get("totalNanoAiu",0) or 0)/1e9
        ti+=i; to+=o; tc+=cr+cw; aic+=a
        print(f"  {m:16s} {i:>9,} in {o:>8,} out {cr+cw:>10,} cache  {a:>9,.1f} AIC")
    print(f"Tokens  : {ti:,} in / {to:,} out / {tc:,} cache = {ti+to+tc:,} total")
    print(f"AIC used: {aic:,.2f} AI credits  (~${aic*0.01:,.2f})  {shut.get('totalPremiumRequests',0)} premium req  [real]")
elif shut:                              # older log: main-only tokenDetails
    td=shut.get("tokenDetails",{}); g=lambda k:(td.get(k) or {}).get("tokenCount",0)
    aic=(shut.get("totalNanoAiu",0) or 0)/1e9
    print(f"Tokens  : {g('input'):,} in / {g('output'):,} out / {g('cache_read')+g('cache_write'):,} cache (main)")
    print(f"AIC used: {aic:,.2f} AI credits  (~${aic*0.01:,.2f})  [real]")
else:                                   # live session: interim estimate
    for m,v in out.most_common(): print(f"  main   {m:16s} {v:>10,} out ({msgs[m]} msgs)")
    for m,v in sub.most_common(): print(f"  subagt {m:16s} {v:>10,} tot ({subn[m]} runs)")
    print(f"Output  : {main_out:,} main + {sub_tot:,} subagent = {main_out+sub_tot:,} tokens (interim, live)")
    print("AIC used: <session open: paste 'Session: N AIC used' from status line>")
if ctx: print(f"Context : ~{ctx.get('currentTokens', sum(ctx.values())):,} {dict(ctx)}")
PY
