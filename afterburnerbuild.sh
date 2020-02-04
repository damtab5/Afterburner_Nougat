#!/bin/sh

VER="$(date +"%y.%m.%d")"

if [ -e last_build_date.log ] && grep -q $VER last_build_date.log
then
	BUILDVER=$(($(cat .version) + 1))
	VER="$(echo $VER).$BUILDVER"
else
	echo $VER > last_build_date.log
	VER="$(echo $VER).1"
	
	if [ -e .version ]
	then
		rm .version
	fi
fi

sed -i 's~\(CONFIG_LOCALVERSION="-Afterburner_N_v\).*"~\1'$VER'"~' arch/arm64/configs/j7elte_00_defconfig
sed -i 's~\(ini_set("rom_version",          "\).*");~\1'$VER'");~' afterburner/zipsrc/META-INF/com/google/android/aroma-config
sed -i 's~\(ini_set("rom_date",             "\).*");~\1'$(date +"%D")'");~' afterburner/zipsrc/META-INF/com/google/android/aroma-config
./buildkernel.sh
./builddtimg.sh $VER

