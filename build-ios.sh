#!/bin/sh

if [ ! -d dist ]; then
  echo "ERROR: dist DIRECTORY NOT FOUND!"
  echo "DID YOU EXECUTE setup.sh?"
  exit 1
fi

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

# ---

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

cat ../configs/ios.jam >> project-config.jam

# ---

### IPHONE-OS ###

LIB_DIR_1="../lib/ios"

./b2 -q -j$HOST_NUM_CPUS        \
  toolset=clang-iphoneos        \
  link=static                   \
  variant=release               \
  $LIBRARIES                    \
  stage                         \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

rm -rf $LIB_DIR_1
mkdir -p $LIB_DIR_1
mv stage/lib/*.a $LIB_DIR_1

### IPHONE-SIMULATOR ###

LIB_DIR_2="../lib/ios-sim"

./b2 -q -j$HOST_NUM_CPUS        \
  toolset=clang-iphonesimulator \
  link=static                   \
  variant=release               \
  $LIBRARIES                    \
  stage                         \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

rm -rf $LIB_DIR_2
mkdir -p $LIB_DIR_2
mv stage/lib/*.a $LIB_DIR_2

# ---

echo "DONE!"
ls -1 $LIB_DIR_1/*.a
ls -1 $LIB_DIR_2/*.a
