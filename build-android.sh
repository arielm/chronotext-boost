#!/bin/sh

#
# FOR $HOST_NUM_CPUS, $HOST_OS, $HOST_ARCH
#
. `dirname $0`/build-common.sh

if [ -z $NDK_PATH ]; then
  echo "NDK_PATH MUST BE DEFINED!"
  exit -1  
fi

# ---

BOOST_DIR="boost"

if [ ! -d $BOOST_DIR ]; then
  echo "ERROR: boost DIRECTORY NOT FOUND"
  echo "DID YOU EXECUTE setup.sh?"
  exit 1
fi

cd $BOOST_DIR

rm bjam
rm b2
rm project-config.jam
rm -rf bin.v2

./bootstrap.sh 2>&1

if [ $? != 0 ]; then
  echo "ERROR: boostrap FAILED"
  exit 1
fi

cat ../configs/android.jam >> project-config.jam

# ---

LIBRARIES=" --with-system --with-filesystem --with-iostreams"

LIB_DIR="../lib/android/armeabi-v7a"

GCC_VERSION=4.9
ANDROID_PLATFORM=android-16

TOOLCHAIN_BIN=${NDK_PATH}/toolchains/arm-linux-androideabi-${GCC_VERSION}/prebuilt/${HOST_OS}-${HOST_ARCH}/bin

# ---

export PATH=${TOOLCHAIN_BIN}:${PATH}
export NDK_PATH
export GCC_VERSION
export ANDROID_PLATFORM
export NO_BZIP2=1

./b2 -q -j${HOST_NUM_CPUS}   \
target-os=linux              \
toolset=gcc-android          \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \

rm -rf $LIB_DIR
mkdir -p $LIB_DIR
mv stage/lib/*.a $LIB_DIR

# ---

echo "\nDONE!"
ls -1 ${LIB_DIR}/*.a
