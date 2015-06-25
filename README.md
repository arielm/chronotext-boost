# Boost

Provides support for Boost 1.58 on:
- OSX (i386, x86_64)
- iOS (armv7, arm64, i386, x86_64)
- Android (armeabi-v7a)
- Emscripten
- Windows/MXE (i686)

More info in the [Wiki](https://github.com/arielm/chronotext-boost/wiki)...

## Setup...
```
cd chronotext-boost
source setup.sh
```
This will download and unpack a version of Boost adapted to the relevant platforms.

## Build...
```
./build-osx.sh
./build-ios.sh
./build-android.sh
./build-emscripten.sh
./build-mxe.sh
```
This will build and package static libs for the relevant platforms.
