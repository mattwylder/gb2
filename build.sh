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

function pretty_print {
    echo "****************************"
    echo $1
    echo "****************************"
}

BASEDIR=`dirname $0`
MAIN=$BASEDIR/src/main.asm
OUTPUT=$BASEDIR/result.gb

pretty_print "assembling..."
rgbasm -o object.o $MAIN || error
echo "assembling complete!\n"
echo "linking..."
rgblink -o $OUTPUT object.o || error
echo "linking complete!\n"
echo "fixing gb file..."
rgbfix -v $OUTPUT || error
echo "fixing complete!\n"
echo "build complete!"
clean_up 
