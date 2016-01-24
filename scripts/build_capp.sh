#!/bin/sh

# Kind of silly way.
# TODO: Script plugin should provide list of strings
#       to go in the same directory as script
cp -r ../../../src/* .

rm -rf test-c-app
make testapp
mkdir -p $1/x86_64-linux-gnu/ && mv test-c-app $1/x86_64-linux-gnu/test-c-app
if [ $? -ne 0 ]; then
    echo "build_capp - ERROR: Could not build for native architecture";
    exit 1
fi

rm -rf test-c-app
make ARCH=armhf testapp
mkdir -p $1/arm-linux-gnueabihf/ && mv test-c-app $1/arm-linux-gnueabihf/test-c-app
if [ $? -ne 0 ]; then
    echo "build_capp - ERROR: Could not build for armhf architecture";
    exit 1
fi
