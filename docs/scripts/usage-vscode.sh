#!/usr/bin/env bash
# VS Code Copilot Chat sessions (built-in chat/agent mode, incl. Insiders). Local logs record
# date, model, and request count per session — VS Code does NOT store token counts or cost
# locally; the spend counter (premium requests) lives on GitHub: github.com/settings/billing
# (or `gh auth refresh -s user` then the billing usage API). Only real local fields are
# printed; tokens/cost are reported as not exposed — never guessed from a price table.
# Note: Claude Code / Copilot CLI / Codex IDE *extensions* are NOT here — they share their
# CLI logs and are covered by the other collectors. Usage: docs/scripts/usage-vscode.sh [session-id]
set -eu
set -- "${1:-}"
for base in "$HOME/Library/Application Support" "$HOME/.config"; do
    for app in "Code" "Code - Insiders" "VSCodium"; do
        [ -d "$base/$app/User" ] && set -- "$@" "$base/$app/User"
    done
done
[ $# -gt 1 ] || { echo "No VS Code user data found." >&2; exit 1; }
python3 - "$@" <<'PY'
import json, sys, os, glob, re, datetime
want = sys.argv[1]; rows=[]
for user in sys.argv[2:]:
    pats=[os.path.join(user,"workspaceStorage","*","chatSessions","*"),
          os.path.join(user,"globalStorage","emptyWindowChatSessions","*")]
    for f in (p for pat in pats for p in glob.glob(pat)):
        if not os.path.isfile(f): continue
        sid=os.path.splitext(os.path.basename(f))[0]
        if want and want not in sid: continue
        raw=open(f, errors="ignore").read()
        found=re.findall(r'"modelId":"([^"]+)"', raw)+re.findall(r'"identifier":"(copilot/[^"]+)"', raw)
        models={m.split("/",1)[-1] for m in found}
        nreq=raw.count('"requestId"') or raw.count('"message":{')  # old .json / new .jsonl (approx)
        ts=os.path.getmtime(f)
        m=re.search(r'"lastMessageDate":(\d{13})', raw)
        if m: ts=int(m.group(1))/1000
        if not nreq and not models: continue
        rows.append((ts, sid, nreq, ",".join(sorted(models)) or "?"))
if not rows: print("No matching VS Code Copilot Chat sessions"); raise SystemExit
for ts,sid,n,md in sorted(rows, reverse=True)[:10]:
    day=datetime.date.fromtimestamp(ts).isoformat()
    print(f"{day} {sid[:14]} {n:>4} req  tokens/cost: not stored locally  {md}")
print("Spend: premium requests are server-side -> github.com/settings/billing")
PY
