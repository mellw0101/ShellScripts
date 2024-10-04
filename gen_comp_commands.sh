#!/bin/bash

# Usage: ./generate_compile_commands.sh [path/to/project/root]

# If no directory is specified, use the current directory as the project root
if [ $# -eq 0 ]; then
  DIR="$(pwd)"
else
  DIR="$1"
fi

OUTPUT_FILE="$DIR/compile_commands.json"

echo "[" > "$OUTPUT_FILE"
FIRST_ENTRY=true

declare -A FILE_COMMANDS

# First, find all .cpp files and store their compile commands
find "$DIR" -type f -name '*.cpp' | while read -r FILE; do
  DIRECTORY=$(dirname "$FILE")
  COMMAND="/usr/bin/clang++ -I./src/include/ -DDEBUG -c \\\"$FILE\\\""
  FILE_PATH="$FILE"

  FILE_COMMANDS["$FILE_PATH"]="$COMMAND"

  if [ "$FIRST_ENTRY" = true ]; then
    FIRST_ENTRY=false
  else
    echo "," >> "$OUTPUT_FILE"
  fi

  cat <<EOT >> "$OUTPUT_FILE"
  {
    "directory": "$DIR",
    "command": "${FILE_COMMANDS["$FILE_PATH"]}",
    "file": "$FILE_PATH"
  }
EOT
done

# Now, find all .h files and associate them with a compile command
find "$DIR" -type f -name '*.h' | while read -r HEADER; do
  DIRECTORY=$(dirname "$HEADER")
  FILE_PATH="$HEADER"

  # Try to find a .cpp file in the same directory
  CPP_FILE=$(find "$DIRECTORY" -maxdepth 1 -type f -name '*.cpp' | head -n 1)
  if [ -n "$CPP_FILE" ]; then
    COMMAND="${FILE_COMMANDS["$CPP_FILE"]}"
  else
    # Use a generic compile command if no .cpp file is found
    COMMAND="/usr/bin/clang++ -Iinclude -DDEBUG -c \\\"$HEADER\\\""
  fi

  # Ensure we add a comma before the new entry
  echo "," >> "$OUTPUT_FILE"

  cat <<EOT >> "$OUTPUT_FILE"
  {
    "directory": "$DIR",
    "command": "$COMMAND",
    "file": "$FILE_PATH"
  }
EOT
done

echo "]" >> "$OUTPUT_FILE"
