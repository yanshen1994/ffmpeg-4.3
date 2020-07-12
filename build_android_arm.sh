#!/bin/bash

export NDK=/home/lx/Downloads/android-ndk-r21d

export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

export API=23

export PREFIX=out/armeabi-v7a

export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm

export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip

export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

function build_x264 {
cd x264

./configure \
    --prefix=../$PREFIX \
    --enable-shared \
    --enable-pic \
    --disable-cli \
    --enable-strip \
    --sysroot=$TOOLCHAIN/sysroot \
    --host=arm-linux-androideabi

make clean

make

make install

cd ../
}

function build_ffmpeg {
./configure \
    --prefix=$PREFIX \
    --arch=arm \
    --cpu=armv7-a \
    --sysroot=$TOOLCHAIN/sysroot \
    --target-os=android \
    --nm=$NM \
    --cc=$CC \
    --strip=$STRIP \
    --enable-shared \
    --enable-runtime-cpudetect \
    --enable-gpl \
    --enable-pic \
    --enable-small \
    --enable-cross-compile \
    --enable-asm \
    --enable-neon \
    --enable-jni \
    --enable-mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-hwaccel=h264_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --disable-debug \
    --disable-static \
    --disable-doc \
    --enable-libx264 \
    --extra-cflags="-I$TOOLCHAIN/sysroot/usr/include -I$PREFIX/include -fPIC -DANDROID -mfpu=neon -mfloat-abi=softfp" \
    --extra-ldflags="-L$PREFIX/lib"

make clean

make

make install
}

build_x264

build_ffmpeg
