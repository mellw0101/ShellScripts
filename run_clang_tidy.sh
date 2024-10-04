#!/bin/bash

# Set the project root directory
# If no directory is specified, use the current directory as the project root
if [ $# -eq 0 ]; then
  PROJECT_ROOT="$(pwd)"
else
  PROJECT_ROOT="$1"
fi


# Change to project root directory
cd "$PROJECT_ROOT" || exit

# Path to compile_commands.json
COMPILE_COMMANDS="$PROJECT_ROOT/compile_commands.json"

# Find all .cpp and .h files
FILES=$(find "$PROJECT_ROOT" -type f \( -name "*.cpp" -o -name "*.h" \))

# Run clang-tidy with the desired options
clang-tidy -p "$COMPILE_COMMANDS" -header-filter='.*' -system-headers $FILES
