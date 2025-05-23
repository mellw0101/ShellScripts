#!/bin/bash

# Usage: ./generate_compile_commands.sh [path/to/project/root]

# If no directory is specified, use the current directory as the project root
if [ $# -eq 0 ]; then
  DIR="$(pwd)"
else
  DIR="$1"
fi

if [[ -f "$DIR"/compile_commands.json ]]; then
  CONTINUE_LOOP="1"
  while [[ $CONTINUE_LOOP == "1" ]]; do
    read -p 'File: compile_commands.json.  Already exists, replace?: ' Answer
    case "${Answer,,}" in
      y|yes)
        rm "$DIR"/compile_commands.json
        CONTINUE_LOOP="0"
        ;;
      n|no)
        echo "Terminating."
        exit 0
        ;;
      *)
        ;;
    esac
  done
fi

OUTPUT_FILE="$DIR/compile_commands.json"

echo "[" > "$OUTPUT_FILE"
FIRST_ENTRY=true

declare -A FILE_COMMANDS

# First, find all .cpp files and store their compile commands
for FILE in $(find "$DIR" -type f -name '*.cpp'); do
  DIRECTORY=$(dirname "$FILE")
  FILE_NAME=$(basename "$FILE")
  FILE_NAME_NO_EXT="${FILE_NAME%.*}"
  OUTPUT_PATH="$DIR"/build/obj/"$FILE_NAME_NO_EXT".o
  COMMAND="/usr/bin/cc -O2 -g -flto=auto -fno-fat-lto-objects -Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes\
 -Wshadow -Wconversion -Wvla -Wdouble-promotion -Wmissing-noreturn -Wmissing-format-attribute -Wnonnull\
 -Wmissing-prototypes -fsigned-char -fstack-protector-strong -Wno-conversion -fno-common -Wunused-result\
 -Wimplicit-fallthrough -fdiagnostics-color=always -march=native -Rpass=loop-vectorize -mavx -Wno-vla\
 -I"$DIR"/src/include/ \
 -o "$OUTPUT_PATH" \
 -c "$FILE""

  FILE_COMMANDS["$FILE"]="$COMMAND"

  if [ "$FIRST_ENTRY" = true ]; then
    FIRST_ENTRY=false
  else
    printf "," >> "$OUTPUT_FILE"
  fi

  cat <<EOT >> "$OUTPUT_FILE"
  {
    "directory": "$DIR",
    "command": "${FILE_COMMANDS["$FILE"]}",
    "file": "$FILE",
    "output": "$OUTPUT_PATH"
  }
EOT
done

# Then, find all .c files and input each one into the compile commands file.
for FILE in $(find "$DIR" -type f -name '*.c'); do
  DIRECTORY=$(dirname "$FILE")
  FILE_NAME=$(basename "$FILE")
  FILE_NAME_NO_EXT="${FILE_NAME%.*}"
  OUTPUT_PATH="$DIR"/build/obj/"$FILE_NAME_NO_EXT".o
  COMMAND="/usr/bin/cc -O2 -g -flto=auto -fno-fat-lto-objects -Wall -Wextra -pedantic -Wunused-parameter -Wstrict-prototypes -Woverflow\
 -Wshadow -Wconversion -Wvla -Wdouble-promotion -Wmissing-noreturn -Wmissing-format-attribute\
 -Wmissing-prototypes -fsigned-char -fstack-protector-strong -Wno-conversion -fno-common -Wunused-result\
 -Wimplicit-fallthrough -fdiagnostics-color=always -march=native -Rpass=loop-vectorize -mavx -Wno-vla -std=gnu99\
 -I"$DIR"/src/include/ \
 -o "$OUTPUT_PATH" \
 -c "$FILE""

  FILE_COMMANDS["$FILE"]="$COMMAND"

  if [ "$FIRST_ENTRY" = true ]; then
    FIRST_ENTRY=false
  else
    printf "," >> "$OUTPUT_FILE"
  fi

  cat <<EOT >> "$OUTPUT_FILE"
  {
    "directory": "$DIR",
    "command": "${FILE_COMMANDS["$FILE"]}",
    "file": "$FILE",
    "output": "$OUTPUT_PATH"
  }
EOT
done

echo "]" >> "$OUTPUT_FILE"
