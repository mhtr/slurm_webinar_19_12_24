#!/bin/bash

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 FILE_SIZE_MB FILE_NAME_PREFIX FILE_COUNT"
	exit 1
fi

FILE_SIZE_MB=$1
PREFIX=$2
FILE_COUNT=$3

if ! [[ $FILE_SIZE_MB =~ ^[0-9]+$ ]] || ! [[ $FILE_COUNT =~ ^[0-9]+$ ]]; then
    echo "Error: Both file size and file count must be positive integers."
    exit 1
fi

for i in $(seq -w 1 $FILE_COUNT);do
	FILENAME="${PREFIX}_${i}.dat"
	dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none
	echo "File $FILENAME created"
done

echo "Successfully created $FILE_COUNT files with prefix $PREFIX and size ${FILE_SIZE_MB}MB each."
