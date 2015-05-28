#!/bin/sh

#
# FOR $HOST_NUM_CPUS
#
. `dirname $0`/build-common.sh

if [ -z $EMSCRIPTEN_BIN ]; then
  echo "EMSCRIPTEN_BIN MUST BE DEFINED!"
  echo "IT SHOULD POINT TO A FOLDER CONTAINING emcc, emar, emranlib AND emlink"
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

cat ../configs/emscripten.jam >> project-config.jam

# ---

LIBRARIES=" --with-system --with-filesystem --with-iostreams"

LIB_DIR="../lib/emscripten"

# ---

export PATH=${EMSCRIPTEN_BIN}:${PATH}
export NO_BZIP2=1

./b2 -q -j${HOST_NUM_CPUS}   \
toolset=clang-emscripten     \
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
