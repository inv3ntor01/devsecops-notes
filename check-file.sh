#!/usr/bin/env bash

set -euo pipefail
echo "Starting..."

echo "Finished..."

#Check if file exists
FILE="$1"

[[ -f "$FILE" ]] || { echo "File not found: $FILE"; exit 1; }

echo "File exists: $FILE"

