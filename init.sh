#!/bin/sh

BOOST_VER1=1
BOOST_VER2=58
BOOST_VER3=0

BOOST_VER="${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}"
BOOST_TAR="master.zip"
BOOST_SRC="https://github.com/arielm/android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}/archive/${BOOST_TAR}"

BOOST_DIR="boost"
rm -rf $BOOST_DIR

# -----------
# DOWNLOADING
# -----------

if [ ! -f $BOOST_TAR ]; then
  echo "Downloading ${BOOST_SRC}"
  curl -L -O $BOOST_SRC
fi

if [ ! -f $BOOST_TAR ]; then
  echo "Downloading failed!"
  exit 1
fi

# ---------
# UNPACKING
# ---------

echo "Unpacking..."

if [ $(which pv) ]; then
  pv $BOOST_TAR | tar xjf -
else
  tar xjf $BOOST_TAR
fi

BOOST_TMP_DIR="android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}-master"

if [ ! -d $BOOST_TMP_DIR ]; then
  echo "Unpacking failed!"
  exit 1
fi

mv ${BOOST_TMP_DIR} ${BOOST_DIR}
