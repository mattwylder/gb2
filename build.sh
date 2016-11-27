#!/bin/sh
rgbasm -o chapo.o chapo.asm
rgblink -o chapo.gb chapo.o
rm chapo.o
rgbfix -v chapo.gb

