# Boost

Provides support for Boost 1.58 on:
- OSX (i386, x86_64)
- iOS (armv7, arm64, i386, x86_64)
- Android (armeabi-v7a)
- Emscripten

More info in the [Wiki](https://github.com/arielm/chronotext-boost/wiki)...

## Setup...
```
cd chronotext-boost
./setup.sh
```
This will download and unpack a version of Boost adapted to the relevant platforms.

## Build...
```
./build-osx.sh
./build-ios.sh
./build-android.sh
./build-emscripten.sh
```
This will build static libs for the relevant platforms, and package everything as follows:
```
|--include
|  |--boost
|--lib
   |--osx
   |  |--libboost_system.a
   |  |--...
   |--ios
   |  |--libboost_system.a
   |  |--...
   |--android
   |  |--libboost_system.a
   |  |--...
   |--emscripten
      |--libboost_system.a
      |--...
```
