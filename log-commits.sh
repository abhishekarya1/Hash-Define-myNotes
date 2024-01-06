#!/bin/bash

# command
command_output=$(git log -n 10 --pretty=format:"%h    %cd    %s")

# line number to insert the output
line_number=9

# output file
file_name="./content/changelog.md"

# use awk to insert the command output at the specified line
awk -v line=$line_number -v text="$command_output" 'NR==line {print text} {print}' "$file_name" > "$file_name.tmp" && mv "$file_name.tmp" "$file_name"
