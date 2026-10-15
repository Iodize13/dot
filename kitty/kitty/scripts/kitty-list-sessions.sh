#!/usr/bin/env bash
# fzf picker for open kitty sessions (Linux port of linkarzu's kitty-list-sessions.sh).
# Run inside a kitty overlay so KITTY_LISTEN_ON is set.
# Insert mode (default): type to filter, enter open, esc -> normal
# Normal mode: j/k move, d close session, enter open, i insert, esc quit

set -euo pipefail

for dep in fzf jq kitten; do
  command -v "$dep" >/dev/null || { echo "$dep not found in PATH"; read -rn1; exit 1; }
done

to=()
[[ -n "${KITTY_LISTEN_ON:-}" ]] && to=(--to "$KITTY_LISTEN_ON")
k() { kitten @ "${to[@]}" "$@"; }

cursor() { printf '\e[%s q' "$1" >/dev/tty; } # 2 = block, 6 = bar
trap 'cursor 6' EXIT

# Current session in green, others in blue (follows the kitty theme's palette)
cur_color=$'\e[32m' base_color=$'\e[34m' reset=$'\e[0m'

build_menu_lines() {
  k ls 2>/dev/null | jq -r '
    [ .[] as $os | $os.tabs[] as $tab | $tab.windows[]?
      | select((.session_name // "") != "")
      | { name: .session_name,
          pwd: (.env.PWD // .cwd),
          cur: (($os.is_focused // false) and ($tab.is_focused // false)),
          t: (.last_focused_at // 0) } ]
    | group_by(.name)
    | map((map(select(.cur)) + .)[0] + {t: (map(.t) | max)})
    | sort_by(-.t, .name)[]
    | [.name, (.cur | tostring), .pwd] | @tsv' |
    awk -F'\t' -v home="$HOME" -v c="$cur_color" -v b="$base_color" -v r="$reset" '{
      p = $3; if (index(p, home) == 1) p = "~" substr(p, length(home) + 1)
      printf "%d\t%s\t%s%s%s  %s\n", NR, $1, ($2 == "true" ? c : b), $1, r, p
    }'
}

mode=insert
start_pos=""

while true; do
  menu="$(build_menu_lines || true)"
  [[ -z "$menu" ]] && { echo "No sessions found."; read -rn1; exit 1; }

  opts=(--ansi --height=100% --reverse --no-multi --no-clear --with-nth=3..
    --prompt="Kitty Sessions > " --bind 'esc:abort')
  if [[ $mode == normal ]]; then
    cursor 2
    opts+=(--disabled --header="Normal: j/k move, d close, enter open, i insert, esc quit"
      --expect=enter,d,i --bind 'j:down,k:up,d:accept,i:accept')
    if [[ -n $start_pos && $start_pos -gt 1 ]]; then
      act=down; for ((n = 3; n <= start_pos; n++)); do act+="+down"; done
      opts+=(--bind "result:$act")
    fi
    start_pos=""
  else
    cursor 6
    opts+=(--header="Insert: type to filter, enter open, esc normal" --expect=enter)
  fi

  out="$(printf '%s\n' "$menu" | fzf "${opts[@]}")" || out=""
  key="$(sed -n 1p <<<"$out")"
  sel="$(sed -n 2p <<<"$out")"
  idx="$(cut -f1 <<<"$sel")"
  name="$(cut -f2 <<<"$sel")"

  if [[ -z $out ]]; then # esc
    [[ $mode == insert ]] && { mode=normal; continue; }
    exit 0
  fi

  case "$key" in
  i) mode=insert ;;
  d)
    total="$(wc -l <<<"$menu")"
    start_pos=$((idx >= total ? idx - 1 : idx))
    k action close_session "$name" >/dev/null 2>&1 || true
    ;;
  enter | "")
    [[ -n $name ]] && k action goto_session "$name"
    exit 0
    ;;
  esac
done
