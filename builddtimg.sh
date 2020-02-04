#!/bin/sh

BUILDOUT=arch/arm64/boot
TOOLCHAIN=afterburner/mkdtbhbootimg/bin

cd $BUILDOUT

if [ ! -e Image ]
then
	echo "Afterburner build failed"
	exit 1
fi

# copy a the ramdisk
cp afterburner/ramdisk/boot.img-ramdisk.gz $BUILDOUT/

mkdir $BUILDOUT/j7e3g

# Compile the dt for J7 3g as its the only one that works correctly
cp dts/exynos7580-j7e3g_rev00.dtb j7e3g/
cp dts/exynos7580-j7e3g_rev05.dtb j7e3g/
cp dts/exynos7580-j7e3g_rev08.dtb j7e3g/


# a workaround to get the dt.img for j7e3g
$TOOLCHAIN/mkbootimg --kernel Image --ramdisk boot.img-ramdisk.gz --dt_dir j7e3g -o boot-new2.img

# copy the kernel
mv boot-new2.img afterburner/zipsrc/boot.img

# cleanup
rm -rf $BUILDOUT/j7e3g/
rm $BUILDOUT/Image
rm $BUILDOUT/Image.gz
rm $BUILDOUT/Image.gz-dtb
rm $BUILDOUT/boot.img-ramdisk.gz

# make the flashable zip new ramdisk
cd afterburner/zipsrc

zip -r afterburner-N-v$1.zip boot.img add-ons/ META-INF/

mkdir -p afterburner/out
mv afterburner-N-v$1.zip afterburner/out/
rm afterburner/zipsrc/boot.img

