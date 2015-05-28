#!/bin/sh

#
# FOR $HOST_NUM_CPUS, $HOST_OS, $HOST_ARCH
#
. `dirname $0`/build-common.sh

if [ -z $NDK_ROOT ]; then
  echo "NDK_ROOT MUST BE DEFINED!"
  echo "e.g. export NDK_ROOT=$HOME/android-ndk"
  exit -1  
fi

# ---

BOOST_DIR="boost"

if [ ! -d $BOOST_DIR ]; then
  echo "ERROR: boost DIRECTORY NOT FOUND"
  echo "DID YOU EXECUTE init.sh?"
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

STAGE_DIR="stage/armeabi-v7a"

GCC_VERSION=4.9
ANDROID_PLATFORM=android-16

TOOLCHAIN_BIN=${NDK_ROOT}/toolchains/arm-linux-androideabi-${GCC_VERSION}/prebuilt/${HOST_OS}-${HOST_ARCH}/bin

# ---

export PATH=${TOOLCHAIN_BIN}:${PATH}
export NDK_ROOT
export GCC_VERSION
export ANDROID_PLATFORM
export NO_BZIP2=1

rm -rf $STAGE_DIR

./b2 -q -j${HOST_NUM_CPUS}   \
target-os=android            \
toolset=gcc-android          \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \
--stagedir=$STAGE_DIR        \

# ---

echo "\nDONE! BUILT LIBS ARE IN ${BOOST_DIR}/${STAGE_DIR}/lib"
