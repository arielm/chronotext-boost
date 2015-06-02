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

cat ../configs/macosx.jam >> project-config.jam

# ---

LIB_DIR="../lib/macosx"

./b2 -q -j$HOST_NUM_CPUS  \
  toolset=clang-macosx    \
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
