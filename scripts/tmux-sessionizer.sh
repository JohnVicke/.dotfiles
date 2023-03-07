#!/usr/bin/env bash

personal_projects=(~/dev/personal)
cygni_projects=(~/dev/work/cygni)
eniro_projects=(~/dev/work/eniro)
north_stat_projects=(~/dev/work/north-stat)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find $personal_projects $eniro_projects $cygni_projects $north_stat_projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
