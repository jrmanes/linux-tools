#!/bin/bash
# Removes old revisions of snaps and clean apt cache
set -eu

echo "Cache apt..."
sudo du -sh /var/cache/apt 

echo "Cleaning with autoremove, autoclean and clean"
sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean

echo "Before cleaning"
du -h /var/lib/snapd/snaps

snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done

echo "After cleaning..."
du -h /var/lib/snapd/snaps

echo "thumbnails"
du -sh ~/.cache/thumbnails
rm -rf ~/.cache/thumbnails/*