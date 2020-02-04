#!/bin/sh
cd "$(dirname "$0")" || exit

# save the version information
mv .version .version.bak
make mrproper
mv .version.bak .version
./afterburnerbuild.sh

