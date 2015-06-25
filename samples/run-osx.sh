#!/bin/sh

rm -rf build/osx
mkdir -p build/osx
cd build/osx

xcrun clang++ ../../HelloBoost.cpp -std=c++11 -stdlib=libc++ -I${BOOST_PATH}/dist/osx/include -L${BOOST_PATH}/dist/osx/lib -lboost_system -lboost_filesystem -lboost_iostreams

if [ $? != 0 ]; then
  echo "BUILD FAILED!"
  exit 1
fi

./a.out
