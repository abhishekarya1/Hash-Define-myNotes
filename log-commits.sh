#!/bin/bash

# output file
file_name="./content/changelog.md"

# clear line range
sed -i '9,17d' "$file_name"

# summary command
summary_output=$(git log -n 9 --pretty=format:"%h    %cd    %s")

# line number to insert the output
line_number=9

# use awk to insert the summary output at the specified line
awk -v line=$line_number -v text="$summary_output" 'NR==line {print text} {print}' "$file_name" > "$file_name.tmp" && mv "$file_name.tmp" "$file_name"
