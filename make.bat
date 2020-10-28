del game.gb
C:\gbdk\bin\rgbasm -o game.obj src\main.asm
C:\gbdk\bin\rgblink -o game.gb game.obj
del game.obj
C:\gbdk\bin\rgbfix -v game.gb
