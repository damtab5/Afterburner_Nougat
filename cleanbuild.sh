#!/bin/sh

# save the version information
mv .version .version.bak
make mrproper
mv .version.bak .version
./afterburnerbuild.sh

