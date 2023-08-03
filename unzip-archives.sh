#! /usr/bin/env bash
set -e

folder=$1

find "$folder" -iname '*.zip' -print | while read archive ; do
    rm -rf /tmp/unzip-files
    unzip -q -d /tmp/unzip-files "$archive"
    largest_file=$(find /tmp/unzip-files -type f -print0 | xargs -0 du -b | sort -nr | head -1 | cut -f2)
    if [ "$largest_file" != "" ] ; then
        target_filename="$(basename "$archive")-$(basename "$largest_file")"
        mv "$largest_file" "$(dirname "$archive")/$target_filename"
    fi
done
