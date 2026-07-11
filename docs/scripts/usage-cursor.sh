#!/usr/bin/env bash
# Cursor (IDE agent/composer) sessions, from its local state.vscdb SQLite store. Local data
# records session titles, dates, and message counts — Cursor does NOT store token counts or
# USD locally; real spend/usage lives at cursor.com/dashboard (Settings -> Usage). Only real
# local fields are printed; tokens/cost are reported as not exposed — never guessed from a
# price table. Usage: docs/scripts/usage-cursor.sh [session-id]
set -eu
DB=""
for base in "$HOME/Library/Application Support/Cursor" "$HOME/.config/Cursor"; do
    [ -f "$base/User/globalStorage/state.vscdb" ] && DB="$base/User/globalStorage/state.vscdb" && break
done
[ -n "$DB" ] || { echo "No Cursor data (state.vscdb not found)." >&2; exit 1; }
command -v sqlite3 >/dev/null || { echo "sqlite3 not available to read $DB" >&2; exit 1; }
PY=$(cat <<'EOF'
import json, sys, datetime
want = sys.argv[1]; rows=[]
for line in sys.stdin:
    line=line.strip()
    if not line: continue
    try: d=json.loads(line)
    except Exception: continue
    sid=d.get("composerId") or "?"
    if want and want not in sid: continue
    ts=(d.get("lastUpdatedAt") or d.get("createdAt") or 0)/1000
    n=len(d.get("conversation") or d.get("fullConversationHeadersOnly") or [])
    name=(d.get("name") or "").strip()[:28]
    rows.append((ts, sid, n, name))
if not rows: print("No matching Cursor sessions"); raise SystemExit
for ts,sid,n,name in sorted(rows, reverse=True)[:10]:
    day=datetime.date.fromtimestamp(ts).isoformat() if ts else "?"
    print(f"{day} {sid[:14]} {n:>4} msg  tokens/cost: not stored locally  {name}")
print("Spend: usage is server-side -> cursor.com/dashboard (Settings -> Usage)")
EOF
)
sqlite3 -readonly "$DB" \
  "SELECT value FROM cursorDiskKV WHERE key LIKE 'composerData:%'" 2>/dev/null \
  | python3 -c "$PY" "${1:-}"
