#!/bin/sh 

function clean_up {
    rm chapo.o >/dev/null 2>&1
}

function error {
   clean_up 
   exit 1
}

rgbasm -o chapo.o chapo.asm || error
rgblink -o chapo.gb chapo.o || error
rgbfix -v chapo.gb || error

clean_up 
