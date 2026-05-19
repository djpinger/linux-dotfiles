#!/bin/bash

# Status line: p10k-inspired layout with dir, git, model, context, and daily cost
# Receives JSON input via stdin with session information

input=$(cat)
TODAY=$(date +%Y-%m-%d)

# --- Directory ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# p10k-style truncate_to_unique: abbreviate each parent component to the
# shortest prefix that's unique among its siblings. Last component stays full.
# Paths under $HOME are prefixed with "~" instead of the abbreviated home path.
p10k_truncate() {
    local abs="$1"
    [ -z "$abs" ] && return

    # If exactly $HOME, return "~"
    if [ -n "$HOME" ] && [ "$abs" = "$HOME" ]; then
        printf '~'
        return
    fi

    local out accum rest
    if [ -n "$HOME" ] && [[ "$abs" == "$HOME"/* ]]; then
        out="~"
        accum="$HOME"
        rest="${abs#$HOME}"
    else
        out=""
        accum=""
        rest="$abs"
    fi

    local IFS='/'
    local -a parts
    read -ra parts <<<"$rest"
    local n=${#parts[@]}
    local i
    for ((i=0; i<n; i++)); do
        local comp="${parts[$i]}"
        [ -z "$comp" ] && continue
        local parent="$accum"
        [ -z "$parent" ] && parent="/"
        local short="$comp"
        # Abbreviate everything except the final component
        if [ $i -lt $((n-1)) ] && [ -d "$parent" ]; then
            local -a siblings=()
            local s
            # -A includes dotfiles (excluding . and ..)
            while IFS= read -r s; do
                [ -n "$s" ] && siblings+=("$s")
            done < <(ls -1A "$parent" 2>/dev/null)
            local clen=${#comp} len count prefix sib
            for ((len=1; len<clen; len++)); do
                prefix="${comp:0:$len}"
                count=0
                for sib in "${siblings[@]}"; do
                    case "$sib" in "$prefix"*) count=$((count+1)) ;; esac
                    [ $count -gt 1 ] && break
                done
                if [ $count -le 1 ]; then
                    short="$prefix"
                    break
                fi
            done
        fi
        out="$out/$short"
        accum="$accum/$comp"
    done
    [ -z "$out" ] && out="/"
    printf '%s' "$out"
}

dir=$(p10k_truncate "$cwd")

# --- Git branch (skip optional locks) ---
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- Context usage ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Rate limits (5-hour window + 7-day rolling) ---
limit_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage | if . == null then empty else round end')
limit_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage | if . == null then empty else round end')

# Helper: pick ANSI color for a percentage on a 4-tier scale
pct_color() {
    local p=$1
    if [ "$p" -ge 90 ] 2>/dev/null; then printf '\033[31m'           # red
    elif [ "$p" -ge 75 ] 2>/dev/null; then printf '\033[38;5;208m'   # orange
    elif [ "$p" -ge 50 ] 2>/dev/null; then printf '\033[33m'         # yellow
    else printf '\033[2m'                                            # dim
    fi
}

# --- Session tokens + rate (from transcript JSONL) ---
# Burn rate is computed over a sliding window ending at the latest message
# timestamp, not across the whole session — otherwise long sessions average
# recent bursts with hours of earlier activity.
BURN_WINDOW_SEC=300
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
session_tokens=""
session_rate=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    read -r total wtotal elapsed <<<"$(jq -rs --argjson win "$BURN_WINDOW_SEC" '
        def ts: (.timestamp // "") | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601? // empty;
        def tokens: .message.usage |
            (.input_tokens // 0) + (.output_tokens // 0)
            + (.cache_creation_input_tokens // 0)
            + (.cache_read_input_tokens // 0);
        [.[] | select(.message.usage)] as $m
        | (([$m[] | tokens] | add) // 0) as $t
        | ([$m[] | ts] | sort) as $ts
        | ($ts | length) as $n
        | (if $n > 0 then $ts[-1] else 0 end) as $latest
        | (if $n > 0 then $ts[0] else 0 end) as $earliest
        | ($latest - $win) as $cutoff
        | (([$m[] | select((ts // 0) >= $cutoff) | tokens] | add) // 0) as $wt
        | (if $n > 0 and ($latest - $earliest) < $win then ($latest - $earliest) else $win end) as $e
        | "\($t) \($wt) \($e)"
    ' "$transcript" 2>/dev/null)"
    if [ -n "$total" ] && [ "$total" -gt 0 ] 2>/dev/null; then
        if [ "$total" -ge 1000000 ]; then
            session_tokens=$(awk -v t="$total" 'BEGIN{printf "%.1fM", t/1000000}')
        elif [ "$total" -ge 1000 ]; then
            session_tokens=$(awk -v t="$total" 'BEGIN{printf "%dk", t/1000}')
        else
            session_tokens="$total"
        fi
        if [ "$elapsed" -ge 60 ] 2>/dev/null; then
            rate=$(awk -v t="$wtotal" -v e="$elapsed" 'BEGIN{printf "%.0f", (t/e)*3600}')
            if [ "$rate" -ge 1000000 ]; then
                session_rate=$(awk -v r="$rate" 'BEGIN{printf "%.1fM/h", r/1000000}')
            else
                session_rate=$(awk -v r="$rate" 'BEGIN{printf "%dk/h", r/1000}')
            fi
        fi
    fi
fi

# --- Assemble output ---
parts=()

# (Directory is added last, after width-aware truncation below)

# Git branch (yellow)
if [ -n "$git_branch" ]; then
    parts+=("$(printf '\033[33m\xee\x82\xa0 %s\033[0m' "$git_branch")")
fi

# Model (dim white)
if [ -n "$model" ]; then
    parts+=("$(printf '\033[2m%s\033[0m' "$model")")
fi

# Context used percentage (dim → yellow → red, with mood emoji)
if [ -n "$used_pct" ]; then
    used_int=${used_pct%.*}
    if [ "$used_int" -ge 90 ] 2>/dev/null; then
        ctx_ansi='\033[31m'    # red
        ctx_mood=' 🤯'
    elif [ "$used_int" -ge 70 ] 2>/dev/null; then
        ctx_ansi='\033[33m'    # yellow
        ctx_mood=' 😬'
    else
        ctx_ansi='\033[2m'     # dim
        ctx_mood=' 😀'
    fi
    parts+=("$(printf "${ctx_ansi}ctx %s%%\033[0m%s" "$used_int" "$ctx_mood")")
fi

# Session tokens (magenta) + rate (dim)
if [ -n "$session_tokens" ]; then
    parts+=("$(printf '\033[35m%s\033[0m 🎟️' "$session_tokens")")
fi
if [ -n "$session_rate" ]; then
    # Color thresholds derived from user's own session burn-rate percentiles
    # green <25M/h | yellow 25-50M/h | orange 50-100M/h | red >100M/h
    # Fire count: 0/1/2/3 follows the color tier
    if [ "$rate" -ge 100000000 ] 2>/dev/null; then
        rate_ansi='\033[31m'           # red
        rate_fires=' 🔥🔥🔥'
    elif [ "$rate" -ge 50000000 ] 2>/dev/null; then
        rate_ansi='\033[38;5;208m'     # orange (256-color)
        rate_fires=' 🔥🔥'
    elif [ "$rate" -ge 25000000 ] 2>/dev/null; then
        rate_ansi='\033[33m'           # yellow
        rate_fires=' 🔥'
    else
        rate_ansi='\033[32m'           # green
        rate_fires=''
    fi
    parts+=("$(printf "${rate_ansi}%s\033[0m%s" "$session_rate" "$rate_fires")")
fi

# Rate limits: separate columns for 5h and 7d, each color-tiered
if [ -n "$limit_5h" ]; then
    c=$(pct_color "$limit_5h")
    parts+=("$(printf '%b5h %s%%\033[0m' "$c" "$limit_5h")")
fi
if [ -n "$limit_7d" ]; then
    c=$(pct_color "$limit_7d")
    parts+=("$(printf '%b7d %s%%\033[0m' "$c" "$limit_7d")")
fi

# Prepend directory (cyan) so it renders first
# (No width-aware truncation: Claude Code doesn't expose terminal width to the
# script, so we rely solely on p10k_truncate to keep the dir short.)
if [ -n "$dir" ]; then
    parts=("$(printf '\033[36m%s\033[0m' "$dir")" "${parts[@]}")
fi

# Join with separator
output=""
for part in "${parts[@]}"; do
    if [ -z "$output" ]; then
        output="$part"
    else
        output="$output $(printf '\033[2m|\033[0m') $part"
    fi
done

printf '%s' "$output"
