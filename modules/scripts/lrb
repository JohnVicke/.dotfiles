#!/usr/bin/env bash

# Fetch remote branches and store them in an array
branches=$(git branch -r | grep -v HEAD) 
echo $branches

# Define ANSI escape codes for text formatting
bold=$(tput bold)
reset=$(tput sgr0)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)

# Create a table header with formatting
printf "${bold}%-30s%-30s${reset}\n" "${yellow}Branch Name" "Last Commit Date"

# iterate through branches and log in table
for branch in "${branches[@]}"
do
    # Get the last commit date for the branch
    last_commit_date=$(git log -1 --format="%cd" $branch)

    # Get the branch name and remove the remote name
    branch_name=$(echo $branch | sed 's/origin\///')

    # Print the branch name and last commit date in a table
    printf "%-30s%-30s\n" "${cyan}$branch_name" "$last_commit_date"
done
