#!/bin/bash
# file_integrity_checker.sh — Detects file changes using SHA256 hashing

MONITOR_DIR="/mnt/e/bash project"
HASH_FILE="$HOME/file_hashes.txt"

echo "🔍 File Integrity Checker"
echo "Monitoring directory: $MONITOR_DIR"
echo "------------------------------------"

# Generate new hashes if hash file doesn't exist
if [ ! -f "$HASH_FILE" ]; then
    echo "🆕 Creating baseline hash record..."
    find "$MONITOR_DIR" -type f -exec sha256sum {} \; > "$HASH_FILE"
    echo "✅ Baseline hashes created and saved to $HASH_FILE"
    exit 0
fi

# Compare current hashes with stored baseline
echo "🔄 Checking for changes..."
TEMP_FILE=$(mktemp)
find "$MONITOR_DIR" -type f -exec sha256sum {} \; > "$TEMP_FILE"

echo "------------------------------------"
echo "🧩 Comparing results..."

# Compare baseline vs current hashes
diff_output=$(diff "$HASH_FILE" "$TEMP_FILE")

if [ -z "$diff_output" ]; then
    echo "✅ No changes detected! All files match baseline."
else
    echo "⚠️  Changes detected:"
    echo "$diff_output"
fi

# Cleanup temp file
rm "$TEMP_FILE"

echo "------------------------------------"
echo "✔️ Integrity check complete."
