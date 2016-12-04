#!/bin/sh -e

BASE_DIR=`dirname $0`
BGB_DIR=~/Code/gb/bgb

DEV_FLAG="-d"
BGB_DEV=$BGB_DIR/bgb-dev.exe

STABLE_FLAG="-s"
BGB_STABLE=$BGB_DIR/bgb.exe

FLAG=$1
DEFAULT=$BGB_DEV

GOOD_FLAGS=0

case "$FLAG" in
    "")             VERSION=$DEFAULT;;
    "$STABLE_FLAG") VERSION=$BGB_STABLE;;
    "$DEV_FLAG")    VERSION=$BGB_DEV;;
    *) echo "Invalid flag"; exit 1;;
esac

wine $VERSION >/dev/null 2>&1 &
