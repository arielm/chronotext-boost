#!/bin/sh

if [ -z "$EMSCRIPTEN_PATH" ]; then
  echo "EMSCRIPTEN_PATH MUST BE DEFINED!"
  exit -1  
fi

SRC_DIR="build"

if [ ! -d "$SRC_DIR" ]; then
  echo "$SRC_DIR DIRECTORY NOT FOUND!"
  exit 1
fi

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

# ---

PLATFORM="emscripten"
INSTALL_PATH="$(pwd)/dist/$PLATFORM"

SRC_PATH="$(pwd)/$SRC_DIR"
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

cat ../configs/emscripten.jam >> project-config.jam

# ---

rm -rf "$INSTALL_PATH"

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')

export PATH="$EMSCRIPTEN_PATH":"$PATH"
export NO_BZIP2=1

./b2 -q -j$HOST_NUM_CPUS     \
  toolset=clang-emscripten   \
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
