#!/bin/bash

#set -e
PREBUILTS=$(pwd)/prebuilts

if [ ! -d "out" ]; then
    mkdir out
else
    make mrproper
fi

export ARCH=arm64
export CROSS_COMPILE=$PREBUILTS/aarch64-linux-android-4.9/bin/aarch64-linux-android-
make O=out mokee_odin_defconfig
make -j$(nproc --all) O=out
