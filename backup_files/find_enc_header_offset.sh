#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <binary-file> <hex-value>"
    exit 1
fi

# Assign arguments to variables
binary_file="$1"
hex_value="$2"

# Validate that the hex_value contains only valid hex characters
if ! [[ $hex_value =~ ^[0-9a-fA-F]+$ ]]; then
    echo "Error: The value must be a valid hexadecimal string."
    exit 1
fi

# Convert the entire binary file to a single line of hex values
hex_string=$(hexdump -v -e '1/1 "%.2x"' "$binary_file")

# Search for the hex value in the hex string and calculate the offset
offset=$(echo "$hex_string" | grep -b -o "$hex_value" | cut -d':' -f1)

# If an offset is found, convert it to the correct byte offset
if [ -n "$offset" ]; then
    # The offset is in hex digits (each pair represents a byte)
    byte_offset=$((offset / 2))
    echo "Hex value found at offset: $byte_offset"
else
    echo "Hex value not found in the binary file."
fi
