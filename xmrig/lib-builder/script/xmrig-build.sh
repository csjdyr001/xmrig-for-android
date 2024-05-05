#!/bin/bash

set -e

source script/env.sh

cd $EXTERNAL_LIBS_BUILD_ROOT/xmrig
mkdir build && cd build

TOOLCHAIN=$ANDROID_HOME/ndk/$NDK_VERSION/build/cmake/android.toolchain.cmake
CMAKE=$ANDROID_HOME/cmake/3.22.1/bin/cmake
ANDROID_PLATFORM=android-29

archs=(arm arm64 x86 x86_64)
for arch in ${archs[@]}; do
    case ${arch} in
        "arm")
            target_host=armv7a-linux-androideabi
            ANDROID_ABI="armeabi-v7a"
            CC=armv7a-linux-androideabi29-clang
            CXX=armv7a-linux-androideabi29-clang++
            ARM_TARGET=7
            ;;
        "arm64")
            target_host=aarch64-linux-android
            ANDROID_ABI="arm64-v8a"
            CC=aarch64-linux-android29-clang
            CXX=aarch64-linux-android29-clang++
            ARM_TARGET=8
            ;;
        "x86")
            target_host=i686-linux-android
            ANDROID_ABI="x86"
            CC=i686-linux-android29-clang
            CXX=i686-linux-android29-clang++
            ARM_TARGET=0
            ;;
        "x86_64")
            target_host=x86_64-linux-android
            ANDROID_ABI="x86_64"
            CC=x86_64-linux-android29-clang
            CXX=x86_64-linux-android29-clang++
            ARM_TARGET=0
            ;;
        *)
            exit 16
            ;;
    esac

    mkdir -p $EXTERNAL_LIBS_BUILD_ROOT/xmrig/build/$ANDROID_ABI
    cd $EXTERNAL_LIBS_BUILD_ROOT/xmrig/build/$ANDROID_ABI

    TARGET_DIR=$EXTERNAL_LIBS_ROOT/xmrig/$ANDROID_ABI


    if [ -f "$TARGET_DIR/lib/xmrig" ]; then
      continue
    fi

    mkdir -p $TARGET_DIR
    echo "building for ${arch}"

    $CMAKE -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
        -DANDROID_ABI="$ANDROID_ABI" \
        -DANDROID_PLATFORM=$ANDROID_PLATFORM \
        -DCMAKE_INSTALL_PREFIX=$TARGET_DIR \
        -DANDROID_CROSS_COMPILE=ON \
        -DBUILD_SHARED_LIBS=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_CUDA=OFF \
        -DBUILD_STATIC=OFF \
        -DWITH_TLS=ON \
        -DHWLOC_LIBRARY="$EXTERNAL_LIBS_ROOT/hwloc/$ANDROID_ABI/lib/libhwloc.a" \
        -DHWLOC_INCLUDE_DIR="$EXTERNAL_LIBS_ROOT/hwloc/$ANDROID_ABI/include" \
        -DUV_LIBRARY="$EXTERNAL_LIBS_ROOT/libuv/$ANDROID_ABI/lib/libuv.a" \
        -DUV_INCLUDE_DIR="$EXTERNAL_LIBS_ROOT/libuv/$ANDROID_ABI/include " \
        -DOPENSSL_ROOT_DIR="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/lib/" \
        -DOPENSSL_SSL_LIBRARY="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/lib/libssl.a" \
        -DOPENSSL_CRYPTO_LIBRARY="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/lib/libcrypto.a" \
        -DOPENSSL_INCLUDE_DIR="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/include " \
        ../../ && make -j 4 CXXFLAGS="-flto" && make install && make clean

done

exit 0
