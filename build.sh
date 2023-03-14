#!/bin/bash

#set -e
PREBUILTS=$(pwd)/prebuilts
FINAL_KERNEL_ZIP=FlyCore_smartisan_odin_Docker_v1.0.0.zip
ANYKERNEL3_DIR=$PWD/AnyKernel3/
blue='\033[1;34m'
yellow='\033[1;33m'
nocol='\033[0m'

# compile
echo -e "$yellow**** Start compile! ****$nocol"
if [ ! -d "out" ]; then
    mkdir out
else
    make mrproper
fi

export ARCH=arm64
export CROSS_COMPILE=$PREBUILTS/aarch64-linux-android-4.9/bin/aarch64-linux-android-
make O=out mokee_odin_defconfig
make -j$(nproc --all) O=out

# anykernel
echo -e "$yellow**** Verify Image.gz-dtb ****$nocol"
ls $PWD/out/arch/arm64/boot/Image.gz-dtb

echo -e "$yellow**** Verifying AnyKernel3 Directory ****$nocol"
ls $ANYKERNEL3_DIR
echo -e "$yellow**** Removing leftovers ****$nocol"
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP

echo -e "$yellow**** Copying Image.gz-dtb****$nocol"
cp $PWD/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL3_DIR/

echo -e "$yellow**** Time to zip up! ****$nocol"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP ../$FINAL_KERNEL_ZIP

echo -e "$yellow**** Done, here is your checksum ****$nocol"
cd ..
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf out/

echo -e "$yellow Build completed.$nocol"
sha1sum $FINAL_KERNEL_ZIP
