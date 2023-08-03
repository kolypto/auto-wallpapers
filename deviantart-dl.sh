#!/usr/bin/env bash
set -e


# Detect removed images
find gallery-dl -type f | sort > images-currently-present.list
cp images-removed.list{,.old} || touch images-removed.list.old
(cat images-removed.list ; fgrep -v -x -f images-currently-present.list images-ever-seen.list) | sort | uniq  > images-removed.list

poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/digitalart' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/fantasy' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/artwork' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/scifi' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/art' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/3d' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/wallpaper' || true
poetry run gallery-dl -c 'gallery-dl.config.json' --range 1-200 'https://www.deviantart.com/tag/pixelart' || true

# Update the list of all images ever seen
cp images-ever-seen.list{,.old} || touch images-ever-seen.list.old
cat images-ever-seen.list.old images-currently-present.list | sort | uniq  > images-ever-seen.list

# Remove images that were previously removed
cat images-removed.list | xargs -d '\n' rm -vf

# TODO: remove images that have weird aspect ratios

# Unzip archives
./unzip-archives.sh gallery-dl

# Remove all non-JPEGs: mp4, swf, zip, abr (brushes), etc
# Exceptions: pixel-art, gif
find gallery-dl/ -not -path "gallery-dl/deviantart/Tags/pixelart/*" -regextype posix-extended -type f -not -regex '.*\.(jpg|jpeg|gif|png|heic)$' -delete
