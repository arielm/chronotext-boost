#!/bin/sh

if [ -z "$NDK_PATH" ]; then
  echo "NDK_PATH MUST BE DEFINED!"
  exit -1  
fi

if [ ! -d dist ]; then
  echo "ERROR: dist DIRECTORY NOT FOUND!"
  echo "DID YOU EXECUTE setup.sh?"
  exit 1
fi

HOST_OS=$(uname -s | tr "[:upper:]" "[:lower:]")
HOST_ARCH=$(uname -m)
HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

# ---

GCC_VERSION=4.9
ANDROID_ABI=armeabi-v7a
ANDROID_PLATFORM=android-16

TOOLCHAIN_PATH="$NDK_PATH/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/$HOST_OS-$HOST_ARCH"

LIBRARIES="--with-system --with-filesystem --with-iostreams"

# ---

cd dist

rm bjam
rm b2
rm project-config.jam
rm -rf bin.v2

./bootstrap.sh 2>&1

if [ $? != 0 ]; then
  echo "ERROR: boostrap FAILED!"
  exit 1
fi

cat ../configs/android.jam >> project-config.jam

# ---

LIB_DIR="../lib/android/$ANDROID_ABI"

export PATH="$TOOLCHAIN_PATH/bin":"$PATH"
export NDK_PATH
export GCC_VERSION
export ANDROID_PLATFORM
export NO_BZIP2=1

./b2 -q -j$HOST_NUM_CPUS  \
  target-os=android       \
  toolset=gcc-android     \
  link=static             \
  variant=release         \
  $LIBRARIES              \
  stage                   \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

# ---

rm -rf $LIB_DIR
mkdir -p $LIB_DIR
mv stage/lib/*.a $LIB_DIR

echo "DONE!"
ls -1 $LIB_DIR/*.a
