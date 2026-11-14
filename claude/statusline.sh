#!/usr/bin/env bash
# Claude Code status line: model | ctx % | git branch
input=$(cat)

if command -v jq >/dev/null 2>&1; then
  model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
  pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
  dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
else
  read -r model pct dir < <(printf '%s' "$input" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
m = (d.get("model") or {}).get("display_name") or "Claude"
p = (d.get("context_window") or {}).get("used_percentage")
w = (d.get("workspace") or {}).get("current_dir") or d.get("cwd") or ""
print(m.replace(" ", "_"), "" if p is None else p, w)
' 2>/dev/null)
  model=${model//_/ }
fi

out="${model:-Claude}"

if [ -n "$pct" ]; then
  out="$out │ ctx $(printf '%.0f' "$pct")%"
else
  out="$out │ ctx --"
fi

if [ -n "$dir" ] && [ -d "$dir" ]; then
  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null \
    || git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && out="$out │  $branch"
fi

printf '%s\n' "$out"
