#!/bin/sh

rm -rf build/mxe
mkdir -p build/mxe
cd build/mxe

i686-w64-mingw32.static-g++ ../../HelloBoost.cpp -Wno-deprecated-declarations -std=c++11 -I${BOOST_PATH}/dist/mxe/include -L${BOOST_PATH}/dist/mxe/lib -lboost_system -lboost_filesystem -lboost_iostreams

if [ $? != 0 ]; then
  echo "BUILD FAILED!"
  exit 1
fi

wine a.exe
