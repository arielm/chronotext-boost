#!/bin/sh

#
# BASED ON https://github.com/MysticTreeGames/Boost-for-Android/blob/master/build-android.sh
#

. `dirname $0`/build-common.sh

BOOST_VER1=1
BOOST_VER2=53
BOOST_VER3=0

BOOST_VER="${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}"
BOOST_TAR="boost_${BOOST_VER}.tar.bz2"
BOOST_SRC="http://downloads.sourceforge.net/project/boost/boost/${BOOST_VER1}.${BOOST_VER2}.${BOOST_VER3}/${BOOST_TAR}"

BOOST_DIR="boost_${BOOST_VER}"
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
  pv $BOOST_TAR | tar xjf - -C $PROGDIR
else
  tar xjf $BOOST_TAR
fi

if [ ! -d $BOOST_DIR ]; then
  echo "Unpacking failed!"
  exit 1
fi

# --------
# PATCHING
# --------

PATCH_BOOST_DIR=$PROGDIR/patches/boost-${BOOST_VER}

echo "Patching..."

for dir in $PATCH_BOOST_DIR; do
  if [ ! -d "$dir" ]; then
    echo "Could not find directory '$dir' while looking for patches"
    exit 1
  fi

  PATCHES=`(cd $dir && ls *.patch | sort) 2> /dev/null`

  if [ -z "$PATCHES" ]; then
    echo "No patches found in directory '$dir'"
    exit 1
  fi

  for PATCH in $PATCHES; do
    PATCH=`echo $PATCH | sed -e s%^\./%%g`
    SRC_DIR=$PROGDIR/$BOOST_DIR
    PATCHDIR=`dirname $PATCH`
    PATCHNAME=`basename $PATCH`
    echo "Applying $PATCHNAME to $SRC_DIR/$PATCHDIR"
    cd $SRC_DIR && patch -p1 < $dir/$PATCH && cd $PROGDIR
    if [ $? != 0 ]; then
      echo "Patching failed!"
      echo "Problematic patch: $dir/$PATCHNAME"
      exit 1
    fi
  done
done
