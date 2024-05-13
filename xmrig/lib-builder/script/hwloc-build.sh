#!/bin/bash

set -e

source script/env.sh

cd $EXTERNAL_LIBS_BUILD_ROOT/hwloc


if [ ! -f "configure" ]; then
  ./autogen.sh
fi

archs=(arm arm64)
for arch in ${archs[@]}; do
    case ${arch} in
        "arm")
            target_host=armv7a-linux-androideabi28
            ANDROID_ABI="armeabi-v7a"
            ;;
        "arm64")
            target_host=aarch64-linux-android28
            ANDROID_ABI="arm64-v8a"
            ;;
        "x86")
            target_host=i686-linux-android28
            ANDROID_ABI="x86"
            ;;
        "x86_64")
            target_host=x86_64-linux-android28
            ANDROID_ABI="x86_64"
            ;;
        *)
            exit 16
            ;;
    esac

    TARGET_DIR=$EXTERNAL_LIBS_ROOT/hwloc/$ANDROID_ABI
    PATH=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH

    if [ -f "$TARGET_DIR/lib/hwloc.la" ]; then
      continue
    fi

    mkdir -p $TARGET_DIR
    echo "building for ${arch}"

    PATH=$NDK_TOOL_DIR/$arch/$target_host/bin:$NDK_TOOL_DIR/$arch/bin:$PATH \
        ./configure CC=${target_host}-clang CXX=${target_host}-clang++ LD=lld\
        --prefix=${TARGET_DIR} \
        --host=${target_host} \
        --enable-static \
        --disable-shared \
        --disable-io \
        --disable-libudev \
        --disable-libxml2 \
        && make -j 4 \
        && make install \
        && make clean

done

exit 0
