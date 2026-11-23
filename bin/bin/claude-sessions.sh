#!/usr/bin/env bash
# Requires jq. List every saved Claude Code session: last activity, directory, first prompt, resume command.
# Usage: claude-sessions.sh [N]   (default 30, newest first)
n=${1:-30}
ls -t ~/.claude/projects/*/*.jsonl 2>/dev/null | head -n "$n" | while read -r f; do
  id=$(basename "$f" .jsonl)
  when=$(date -r "$f" '+%Y-%m-%d %H:%M')
  cwd=$(grep -m1 -o '"cwd":"[^"]*"' "$f" | cut -d'"' -f4)
  prompt=$(grep '"type":"user"' "$f" | jq -r '.message.content | if type=="string" then . else (map(select(.type=="text")|.text)|join(" ")) end' 2>/dev/null | grep -v -m1 -E "^\s*(<|$)" | tr '\n' ' ' | cut -c1-70)
  printf '%s  %s\n    %s\n    cd %q && claude --resume %s\n' "$when" "${cwd:-?}" "${prompt:-(no prompt)}" "${cwd:-.}" "$id"
done
