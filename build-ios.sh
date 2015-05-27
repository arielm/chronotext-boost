#!/bin/sh

. `dirname $0`/build-common.sh

BOOST_DIR="boost_1_55_0"

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

cat ../configs/ios.jam >> project-config.jam

# ---

LIBRARIES=" --with-system --with-filesystem --with-iostreams"

STAGE_DIR_1="stage/ios"
STAGE_DIR_2="stage/ios-sim"

# ---

rm -rf $STAGE_DIR_1

./b2 -a -j${HOST_NUM_CPUS}   \
toolset=clang-ios            \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \
--stagedir=$STAGE_DIR_1      \

# ---

rm -rf $STAGE_DIR_2

./b2 -a -j${HOST_NUM_CPUS}   \
toolset=clang-ios_sim        \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \
--stagedir=$STAGE_DIR_2      \

# ---

echo "\nDONE! BUILT LIBS ARE IN:"
echo "  ${BOOST_DIR}/${STAGE_DIR_1}/lib"
echo "  ${BOOST_DIR}/${STAGE_DIR_2}/lib"
