del plane.gb
rgbasm -o chapo.obj chapo.asm
rgblink -o chapo.gb chapo.obj
del chapo.obj
rgbfix -v chapo.gb
