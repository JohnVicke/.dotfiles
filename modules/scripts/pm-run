#!/usr/bin/env bash

jq ".scripts" package.json | fzf | awk -F ':' '{print $1}' | cut -d '"' -f2

