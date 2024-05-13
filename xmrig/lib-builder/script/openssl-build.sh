#!/bin/bash

set -e

source script/env.sh

cd $EXTERNAL_LIBS_BUILD_ROOT/openssl
#mkdir build && cd build

#CC=clang
PATH=$TOOLCHAINS_PATH/bin:$PATH
ANDROID_API=29
ANDROID_PLATFORM=android-28

archs=(arm arm64)
for arch in ${archs[@]}; do
    case ${arch} in
        "arm")
            architecture=android-arm
            ANDROID_ABI="armeabi-v7a"
            CC=armv7a-linux-androideabi29-clang
            CXX=armv7a-linux-androideabi29-clang++
            ;;
        "arm64")
            architecture=android-arm64
            ANDROID_ABI="arm64-v8a"
            CC=aarch64-linux-android29-clang
            CXX=aarch64-linux-android29-clang++
            ;;
        "x86")
            architecture=android-x86
            CC=i686-linux-android29-clang
            CXX=i686-linux-android29-clang++
            ANDROID_ABI="x86"
            ;;
        "x86_64")
            architecture=android-x86_64
            ANDROID_ABI="x86_64"
            CC=x86_64-linux-android29-clang
            CXX=x86_64-linux-android29-clang++
            ;;
        *)
            exit 16
            ;;
    esac

    TARGET_DIR=$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI

    mkdir -p $TARGET_DIR
    echo "building for ${arch}"

    ./Configure ${architecture} --prefix=${TARGET_DIR} -no-shared -no-asm -no-zlib -no-comp -no-dgram -no-filenames -no-cms CC=$CC CXX=$CXX

    make -j 4
    make install
    make clean

done

exit 0
