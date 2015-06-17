#!/bin/sh

BOOST_VER1=1
BOOST_VER2=58
BOOST_VER3=0

BOOST_DIR="android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}-master"
BOOST_ZIP="master.zip"
BOOST_SRC="https://github.com/arielm/android-vendor-boost-${BOOST_VER1}-${BOOST_VER2}-${BOOST_VER3}/archive/${BOOST_ZIP}"

# ---

if [ ! -f $BOOST_ZIP ]; then
  echo "DOWNLOADING $BOOST_SRC"
  curl -L -O $BOOST_SRC

  if [ $? != 0 ] || [ ! -f $BOOST_ZIP ]; then
    echo "DOWNLOADING FAILED!"
    exit 1
  fi
fi

# ---

echo "UNPACKING $BOOST_ZIP"
unzip $BOOST_ZIP

if [ $? != 0 ] || [ ! -d $BOOST_DIR ]; then
  echo "UNPACKING FAILED!"
  exit 1
fi

# ---

rm -rf dist
mv $BOOST_DIR dist

ln -s dist include
