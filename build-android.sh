#!/bin/sh

if [ -z $NDK_ROOT ]; then
  echo "NDK_ROOT MUST BE DEFINED!"
  echo "e.g. export NDK_ROOT=$HOME/android-ndk"
  exit -1  
fi

# ---

BOOST_DIR="boost_1_53_0"

if [ ! -d $BOOST_DIR ]; then
  echo "ERROR: boost DIRECTORY NOT FOUND"
  echo "DID YOU EXECUTE init.sh?"
  exit 1
fi

cd $BOOST_DIR

rm bjam
rm b2
rm project-config.jam

./bootstrap.sh 2>&1

if [ $? != 0 ]; then
dump "ERROR: boostrap FAILED"
exit 1
fi

cat ../config-android.jam >> project-config.jam

CPUS=$(sysctl hw.ncpu | awk '{print $2}')

# ---

LIBRARIES=" --with-system --with-filesystem --with-iostreams"
STAGE_DIR="stage/armeabi-v7a"

GCC_VERSION=4.9
ANDROID_PLATFORM=android-16

TOOLCHAIN_PATH=${NDK_ROOT}/toolchains/arm-linux-androideabi-${GCC_VERSION}/prebuilt/darwin-x86_64

# ---

export PATH=${TOOLCHAIN_PATH}/bin:${PATH}
export NDK_ROOT
export GCC_VERSION
export ANDROID_PLATFORM
export NO_BZIP2=1

rm -rf $STAGE_DIR

./b2 -a -j$CPUS              \
target-os=linux              \
toolset=gcc-android          \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \
--stagedir=$STAGE_DIR        \

# ---

echo "\nDONE! BUILT LIBS ARE IN ${BOOST_DIR}/${STAGE_DIR}/lib"
