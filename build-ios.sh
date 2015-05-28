#!/bin/sh

#
# FOR $HOST_NUM_CPUS
#
. `dirname $0`/build-common.sh

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

cat ../configs/ios.jam >> project-config.jam

# ---

LIBRARIES=" --with-system --with-filesystem --with-iostreams"

LIB_DIR_1="../lib/ios"
LIB_DIR_2="../lib/ios-sim"

# ---

./b2 -q -j${HOST_NUM_CPUS}   \
toolset=clang-ios            \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \

rm -rf $LIB_DIR_1
mkdir -p $LIB_DIR_1
mv stage/lib/*.a $LIB_DIR_1

# ---

./b2 -q -j${HOST_NUM_CPUS}   \
toolset=clang-ios_sim        \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \

rm -rf $LIB_DIR_2
mkdir -p $LIB_DIR_2
mv stage/lib/*.a $LIB_DIR_2

# ---

echo "\nDONE!"
ls -1 ${LIB_DIR_1}/*.a
ls -1 ${LIB_DIR_2}/*.a
