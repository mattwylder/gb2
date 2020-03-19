#!/bin/sh 

function clean_up {
    echo "Cleanup! Removing object files..."
    rm *.o >/dev/null 2>&1
    echo "Cleanup complete!"
}

function error {
    echo "Build failed!"
   clean_up 
   exit 1
}

BASEDIR=`dirname $0`
MAIN=$BASEDIR/src/main.asm

echo "assembling..."
rgbasm -o chapo.o $MAIN || error
echo "assembling complete!"
echo "linking..."
rgblink -o $BASEDIR/chapo.gb chapo.o || error
echo "linking complete!"
echo "fixing gb file..."
rgbfix -v $BASEDIR/chapo.gb || error
echo "fixing complete!"
echo "build complete!"
clean_up 
