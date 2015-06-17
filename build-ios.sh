#!/bin/sh

if [ ! -d dist ]; then
  echo "ERROR: dist DIRECTORY NOT FOUND!"
  echo "DID YOU EXECUTE setup.sh?"
  exit 1
fi

cd dist

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

LIB_DIR_1="../lib/ios"
LIB_DIR_2="../lib/ios-sim"

# ---

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

cat ../configs/ios.jam >> project-config.jam

# ---

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

# --- IPHONE-OS ---

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

# --- IPHONE-SIMULATOR ---

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
