#!/bin/sh

if [ -z "$NDK_PATH" ]; then
  echo "NDK_PATH MUST BE DEFINED!"
  exit -1  
fi

SRC_DIR="build"
SRC_PATH="$(pwd)/$SRC_DIR"

if [ ! -d "$SRC_DIR" ]; then
  echo "SOURCE NOT FOUND!"
  exit 1
fi

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

GCC_VERSION=4.9
ANDROID_ABI=armeabi-v7a
ANDROID_API=android-16

# ---

PLATFORM="android"
INSTALL_PATH="$(pwd)/dist/$PLATFORM"

cd "$SRC_PATH"

rm bjam
rm b2
rm project-config.jam
rm boostsrap.log
rm -rf bin.v2

./bootstrap.sh 2>&1

if [ $? != 0 ]; then
  echo "ERROR: boostrap FAILED!"
  exit 1
fi

cat ../configs/android.jam >> project-config.jam

# ---

rm -rf "$INSTALL_PATH"

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')
HOST_OS=$(uname -s | tr "[:upper:]" "[:lower:]")
HOST_ARCH=$(uname -m)

TOOLCHAIN_PATH="$NDK_PATH/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/$HOST_OS-$HOST_ARCH"

export PATH="$TOOLCHAIN_PATH/bin":"$PATH"
export NDK_PATH
export GCC_VERSION
export ANDROID_API
export NO_BZIP2=1

./b2 -q -j$HOST_NUM_CPUS     \
  target-os=android          \
  toolset=gcc-android        \
  link=static                \
  variant=release            \
  $LIBRARIES                 \
  stage                      \
  --stagedir="$INSTALL_PATH" \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

cd "$INSTALL_PATH"
ln -s "$SRC_PATH" include
