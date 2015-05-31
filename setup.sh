#!/bin/sh

BOOST_VER1=1
BOOST_VER2=58
BOOST_VER3=0

BOOST_VER="${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}"
BOOST_ZIP="master.zip"
BOOST_SRC="https://github.com/arielm/android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}/archive/${BOOST_ZIP}"

BOOST_DIR="boost"
rm -rf $BOOST_DIR

# -----------
# DOWNLOADING
# -----------

if [ ! -f $BOOST_ZIP ]; then
  echo "Downloading ${BOOST_SRC}"
  curl -L -O $BOOST_SRC
fi

if [ ! -f $BOOST_ZIP ]; then
  echo "Downloading failed!"
  exit 1
fi

# ---------
# UNPACKING
# ---------

echo "Unpacking..."
unzip $BOOST_ZIP

BOOST_TMP_DIR="android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}-master"

if [ ! -d $BOOST_TMP_DIR ]; then
  echo "Unpacking failed!"
  exit 1
fi

mv ${BOOST_TMP_DIR} ${BOOST_DIR}
ln -s ${BOOST_DIR} include
