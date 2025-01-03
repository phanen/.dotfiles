#!/usr/bin/env bash

# https://github.com/kovidgoyal/kitty/issues/1303#issuecomment-1311202869

windows=$(
  kitty @ ls |
    jq -r '
    .[]
    | .id as $os_win_id
    | .tabs[] += { tab_len: (.tabs|length) }
    | .tabs[]
    | select(.is_focused == false)
    | .id as $tab_id
    | .tab_len as $tab_len
    | .windows[] += { tab_id: $tab_id, os_win_id: $os_win_id, win_len: (.windows|length), tab_len: $tab_len }
    | .windows[]
    | [.os_win_id, .tab_id, .id, .tab_len, .win_len, .title  ]
    | @tsv
    ' |
    awk -F"\t" '
      {
        single_tab=$4==1;
        single_win=$5==1;
        last_tab=$4==i+1;
        last_win=$5==j+1;
        first_tab=i==0;
        first_win=j==0;
      }

      { printf $3"\t" }

      single_tab && first_win { printf "---" }
      !single_tab && first_win { printf "+--" }
      !single_win && !first_win { printf "   " }

      single_win { printf "---" }
      !single_win { printf "+--" }

      {print "\t"$1":"$2"\t"$6}

      { last_tab ? i=0 : i++ ; last_win ? j=0 : j++}
      ' | column -ts $'\t'
)

window_id=$(fzf \
  --reverse \
  --height=80% \
  --padding=30%,20%,20%,5% \
  --margin=0%,0%,0%,0% \
  --ansi \
  --delimiter=' | ' \
  --preview="x={7}; eza --color=always \${x/\~/$HOME}" \
  <<<"${windows}" | awk '{ print $1 }')

kitty @ focus-window -m "id:${window_id}"
