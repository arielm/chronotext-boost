#!/bin/sh

PLATFORM="ios-sim"

SRC_DIR="build/src"
INSTALL_DIR="dist/$PLATFORM"

SRC_PATH="$(pwd)/$SRC_DIR"
INSTALL_PATH="$(pwd)/$INSTALL_DIR"
JAM_CONFIG_PATH="$(pwd)/configs/$PLATFORM.jam"

if [ ! -d "$SRC_PATH" ]; then
  echo "SOURCE NOT FOUND!"
  exit 1
fi

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

# ---

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

cat "$JAM_CONFIG_PATH" >> project-config.jam

# ---

rm -rf "$INSTALL_PATH"

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

./b2 -q -j$HOST_NUM_CPUS        \
  toolset=clang-iphonesimulator \
  link=static                   \
  variant=release               \
  $LIBRARIES                    \
  stage                         \
  --stagedir="$INSTALL_PATH"    \
  2>&1

if [ $? != 0 ]; then
  echo "ERROR: b2 FAILED!"
  exit 1
fi

# ---

cd "$INSTALL_PATH"
ln -s "$SRC_PATH" include
