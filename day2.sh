#!/usr/bin/env bash

set -euo pipefail

#Create a file with a space in the name
FILENAME="my report.txt"
touch "$FILENAME"

echo "Creating $FILENAME"
[[ -f "$FILENAME" ]] || { echo "File not found: $FILENAME"; exit 1; }

echo "File exists: $FILENAME"

#rm "$FILENAME"
