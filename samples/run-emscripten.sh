#!/bin/sh

rm -rf build/emscripten
mkdir -p build/emscripten
cd build/emscripten

emcc ../../HelloBoost.cpp -Wno-warn-absolute-paths -std=c++11 -I${BOOST_ROOT}/include -L${BOOST_ROOT}/lib/emscripten -lboost_system -lboost_filesystem -lboost_iostreams

if [ $? == 0 ]; then
  node a.out.js
fi
