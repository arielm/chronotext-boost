#!/bin/sh

#
# BASED ON https://github.com/MysticTreeGames/Boost-for-Android/blob/master/build-android.sh
#

. `dirname $0`/build-common.sh

BOOST_VER1=1
BOOST_VER2=53
BOOST_VER3=0

BOOST_DOWNLOAD_LINK="http://downloads.sourceforge.net/project/boost/boost/$BOOST_VER1.$BOOST_VER2.$BOOST_VER3/boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F${BOOST_VER1}.${BOOST_VER2}.${BOOST_VER3}%2F&ts=1291326673&use_mirror=garr"
BOOST_TAR="boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}.tar.bz2"
BOOST_DIR="boost_${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}"

# -------
# CLEANUP
# -------

rm -rf $BOOST_DIR

# -----------
# DOWNLOADING
# -----------

if [ ! -f $BOOST_TAR ]; then
  echo "Downloading boost ${BOOST_VER1}.${BOOST_VER2}.${BOOST_VER3}..."
  prepare_download
  download_file $BOOST_DOWNLOAD_LINK $PROGDIR/$BOOST_TAR
fi

if [ ! -f $PROGDIR/$BOOST_TAR ]; then
	echo "Downloading failed!"
  echo "Please download boost ${BOOST_VER1}.${BOOST_VER2}.${BOOST_VER3} and save it in this directory as $BOOST_TAR"
	exit 1
fi

# ---------
# UNPACKING
# ---------

echo "Unpacking..."
tar xjf $PROGDIR/$BOOST_TAR

# --------
# PATCHING
# --------

BOOST_VER=${BOOST_VER1}_${BOOST_VER2}_${BOOST_VER3}
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
