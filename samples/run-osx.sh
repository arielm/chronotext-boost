#!/bin/sh

rm -rf build/osx
mkdir -p build/osx
cd build/osx

xcrun clang++ ../../HelloBoost.cpp -std=c++11 -stdlib=libc++ -I${BOOST_ROOT}/include -L${BOOST_ROOT}/lib/osx -lboost_system -lboost_filesystem -lboost_iostreams

if [ $? == 0 ]; then
  ./a.out
fi
