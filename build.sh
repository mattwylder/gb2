#!/bin/sh 

function clean_up {
    rm *.o >/dev/null 2>&1
}

function error {
   clean_up 
   exit 1
}

BASEDIR=`dirname $0`
MAIN=$BASEDIR/src/main.asm

rgbasm -o chapo.o $MAIN || error
rgblink -o $BASEDIR/chapo.gb chapo.o || error
rgbfix -v $BASEDIR/chapo.gb || error

echo "success"
clean_up 
