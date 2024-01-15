i#!/bin/ash

file_name="../data/info_respaldar"
file_size=25

dd if=/dev/urandom of="$file_name" bs=1M count="$file_size"

echo "dummy file '$file_name' created."
