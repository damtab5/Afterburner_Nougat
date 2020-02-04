#!/bin/sh

. "$(pwd)/j7variant.sh"

VER="$(date +"%y.%m.%d")"

if [ -e last_build_date.log ] && grep -q "$VER" last_build_date.log
then
	BUILDVER=$(($(cat .version) + 1))
	VER="$VER.$BUILDVER"
else
	echo "$VER" > last_build_date.log
	VER="$VER.1"
	
	if [ -e .version ]
	then
		rm .version
	fi
fi

if [ "$J7VARIANT" = "j7e3g" ]; then
	sed -i 's/exynos7580-j7elte_rev00\ exynos7580-j7elte_rev04\ exynos7580-j7elte_rev06/exynos7580-j7e3g_rev00\ exynos7580-j7e3g_rev05\ exynos7580-j7e3g_rev08/g' arch/arm64/configs/j7elte_00_defconfig
else
	sed -i 's/exynos7580-j7e3g_rev00\ exynos7580-j7e3g_rev05\ exynos7580-j7e3g_rev08/exynos7580-j7elte_rev00\ exynos7580-j7elte_rev04\ exynos7580-j7elte_rev06/g' arch/arm64/configs/j7elte_00_defconfig
fi


sed -i 's~\(CONFIG_LOCALVERSION="-Afterburner_N_v\).*"~\1'"$VER"'"~' arch/arm64/configs/j7elte_00_defconfig
sed -i 's~\(ini_set("rom_version",          "\).*");~\1'"$VER"'");~' afterburner/zipsrc/META-INF/com/google/android/aroma-config
sed -i 's~\(ini_set("rom_date",             "\).*");~\1'"$(date +"%D")"'");~' afterburner/zipsrc/META-INF/com/google/android/aroma-config
./buildkernel.sh
./builddtimg.sh "$VER"

