#!/usr/bin/env bash

if [[ $0 -ne 1 ]]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

DIRECTRY=$1

if [[ ! -d $DIRECTORY ]]; then
    echo "Error: $DIRECTORY is not a valid directory."
    exit 1
fi

FILE_COUNT=$(find "$DIRECTORY" | wc -l)

echo "The directory '$DIRECTORY' contains '$FILE_COUNT' file(s)."
