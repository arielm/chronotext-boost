#!/bin/sh

SRC_DIR="build"
SRC_PATH="$(pwd)/$SRC_DIR"

if [ ! -d "$SRC_PATH" ]; then
  echo "SOURCE NOT FOUND!"
  exit 1
fi

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

# ---

PLATFORM_1="ios"
INSTALL_PATH_1="$(pwd)/dist/$PLATFORM_1"

PLATFORM_2="ios-sim"
INSTALL_PATH_2="$(pwd)/dist/$PLATFORM_2"

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

cat ../configs/ios.jam >> project-config.jam

# ---

rm -rf "$INSTALL_PATH_1"
rm -rf "$INSTALL_PATH_2"

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

# --- IPHONE-OS ---

./b2 -q -j$HOST_NUM_CPUS        \
  toolset=clang-iphoneos        \
  link=static                   \
  variant=release               \
  $LIBRARIES                    \
  stage                         \
  --stagedir="$INSTALL_PATH_1"  \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

# --- IPHONE-SIMULATOR ---

./b2 -q -j$HOST_NUM_CPUS        \
  toolset=clang-iphonesimulator \
  link=static                   \
  variant=release               \
  $LIBRARIES                    \
  stage                         \
  --stagedir="$INSTALL_PATH_2"  \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

# ---

cd "$INSTALL_PATH_1"
ln -s "$SRC_PATH" include

cd "$INSTALL_PATH_2"
ln -s "$SRC_PATH" include
