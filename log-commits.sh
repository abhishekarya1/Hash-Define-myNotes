#!/bin/bash

# output file
file_name="./content/changelog.md"

echo "Logging commits..."

# summary command
summary_output=$(git log -n 15 --pretty=format:"%h    %cd    %s")

# line number to insert the output
line_number=8

# use awk to insert the summary output at the specified line
awk -v line=$line_number -v text="$summary_output" 'NR==line {print text} {print}' "$file_name" > "$file_name.tmp" && mv "$file_name.tmp" "$file_name"

echo "Successfully logged commits."