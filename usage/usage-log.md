# Usage Log

Per-session work-accounting ledger. Each row records the **real usage reported by the runner** for a session — never a guess from a static price table.

- **Cost is the runner's native unit:** AIC (GitHub Copilot CLI), USD (OpenCode / paid APIs), or token cost. Record the value shown by that runner's own usage view.
- **Figures are cumulative, live counters.** Token counts and credit/AIC/USD totals keep climbing while a session runs. Record the value at **session close**; any row added mid-session is an **interim, timestamped snapshot** (mark it with `†` and the time).
- **Never fabricate.** If the runtime does not expose an exact figure, record what the runner's usage view shows and label unreadable values `≈ estimate`.
- The GitHub Copilot event log records **output tokens + a context snapshot**, but **not** exact per-turn input tokens and **not** the AIC counter; paste the AIC value from the CLI status line (`Session: N AIC used`). See [`scripts/usage-snapshot.sh`](../scripts/usage-snapshot.sh).

| Date       | Session  | Model(s)                       | Cost (unit)             | Output tokens | Turns | Summary                                                  |
| ---------- | -------- | ------------------------------ | ----------------------- | ------------- | ----- | -------------------------------------------------------- |
| 2026-06-27 | a1b2c3d4 | claude-opus-4 (GitHub Copilot) | ~5 AIC used @ 14:32 †   | 12,480        | 7     | Example row — add Work Accounting rule, ledger & script. |

† Interim, timestamped snapshot — counters were still climbing at the recorded time; finalize at session close.
