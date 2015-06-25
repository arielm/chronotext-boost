#!/bin/sh

rm -rf build/emscripten
mkdir -p build/emscripten
cd build/emscripten

emcc ../../HelloBoost.cpp -Wno-warn-absolute-paths -std=c++11 -I${BOOST_PATH}/dist/emscripten/include -L${BOOST_PATH}/dist/emscripten/lib -lboost_system -lboost_filesystem -lboost_iostreams

if [ $? != 0 ]; then
  echo "BUILD FAILED!"
  exit 1
fi

node a.out.js
