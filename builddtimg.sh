#!/bin/sh
. "$(pwd)/j7variant.sh"

TOOLCHAIN="$(pwd)/afterburner/mkdtbhbootimg/bin"

# copy ramdisk
cp afterburner/ramdisk/boot.img-ramdisk.gz arch/arm64/boot/

cd arch/arm64/boot || exit

if [ ! -e Image ]
then
	echo "Afterburner build failed"
	exit 1
fi

mkdir "$J7VARIANT"

# Compile the dt
if [ "$J7VARIANT" = "j7e3g" ]; then
	cp dts/exynos7580-"${J7VARIANT}"_rev00.dtb "$J7VARIANT"/
	cp dts/exynos7580-"${J7VARIANT}"_rev05.dtb "$J7VARIANT"/
	cp dts/exynos7580-"${J7VARIANT}"_rev08.dtb "$J7VARIANT"/
else
	cp dts/exynos7580-"${J7VARIANT}"_rev00.dtb "$J7VARIANT"/
	cp dts/exynos7580-"${J7VARIANT}"_rev04.dtb "$J7VARIANT"/
	cp dts/exynos7580-"${J7VARIANT}"_rev06.dtb "$J7VARIANT"/
fi

# a workaround to get the dt.img
$TOOLCHAIN/mkbootimg --kernel Image --ramdisk boot.img-ramdisk.gz --dt_dir "$J7VARIANT" -o boot-output.img

# copy the kernel
mv boot-output.img "../../../afterburner/zipsrc/boot.img"

# cleanup
rm -rf "$J7VARIANT"
rm Image
rm Image.gz
rm Image.gz-dtb
rm boot.img-ramdisk.gz

# make the flashable zip new ramdisk
cd "../../../afterburner/zipsrc" || exit

zip -r afterburner-N-v$1-${J7VARIANT}.zip boot.img add-ons/ META-INF/

cd ../
mv zipsrc/afterburner-N-v$1-${J7VARIANT}.zip out/
rm zipsrc/boot.img

