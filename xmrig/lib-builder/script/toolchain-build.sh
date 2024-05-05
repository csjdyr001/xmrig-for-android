#!/usr/bin/env bash

set -e

source script/env.sh

build_root=$EXTERNAL_LIBS_BUILD_ROOT
PATH=$ANDROID_NDK_ROOT/build/tools/:$PATH

args="--api 29 --stl=libc++"
archs=(arm arm64 x86 x86_64)

for arch in ${archs[@]}; do
    if [ ! -d "$NDK_TOOL_DIR/$arch" ]; then
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
    fi
done
