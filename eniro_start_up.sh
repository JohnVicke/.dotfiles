#!/usr/bin/env bash

session="my-eniro"

session_exists=$(tmux list-sessions | grep $session)
ENIRO_DIR="~/projects/eniro"

if ["$session_exists" != ""] 
  then 
  tmux new-session -d -s $session

  tmux rename-window -t 1 'my-eniro'
  tmux send-keys -t 'my-eniro' "cd $ENIRO_DIR/my-eniro" C-m

  tmux new-window -t $session:2 -n 'backoffice'
  tmux send-keys -t 'backoffice' "cd $ENIRO_DIR/my-eniro-backoffice/develop" C-m 'nvm use && PORT=8081 npm run dev' C-m

  tmux new-window -t $session:3 -n 'gollum'
  tmux send-keys -t 'gollum' "cd $ENIRO_DIR/gollum-in-a-box/master" C-m 'docker-compose up' C-m

  tmux new-window -t $session:4 -n 'sprout-soil'
  tmux send-keys -t 'sprout-soil' "cd $ENIRO_DIR/sprout-in-a-box" C-m 'docker-compose up' C-m

  tmux new-window -t $session:5 -n 'capax'
  tmux send-keys -t 'capax' "cd $ENIRO_DIR/capax/develop" C-m
fi

tmux attach-session -t $session:1

