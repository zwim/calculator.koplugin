# calculator.koplugin
A calculator plugin for KOReader.

## Installation
Copy the whole folder (incl. formulaparser subfolder) to `koreader/calculator.koplugin`. You can delete all `.git*` files and folders.

If you want predefined physical constants, then move `init.calc` to `koreader/`, otherwise you can delete `init.calc`.

The file `VERSION` is used for update-informations. If you delete it, you don't get a notification update.


## Usage

Enter a calculation and press `Calc`. You can see your inputs in lines starting with `ixxx:` and the results in lines with `oxxx:`.

If you change something in an old line, this line will be used for the next calculation.

The results are stored in variables `oxxx` and the last result is additional in the variable `ans`.

All the entered calculations and the result can be saved to `koreader/output.calc`.

Predefined expressions my be loaded from `koreader/init.calc`

You find the settings in the Hamburger menu.


![grafik](https://user-images.githubusercontent.com/36999612/121774303-3af12000-cb82-11eb-94c9-a0248b33c060.png)

You can set the output to different modi: For example if the evaluation yields 12345678.9

`Scientific` -> 1.23456789E+7

`Engineer` -> 12.3456789E+6 (not implemented yet)

`Auto` -> switches to Scientific if the absolute value is greater than 1000000 or less than 0.0001

`Native` -> show what lua calculates

`Programmer` -> show the result in `Auto` plus the value in HEX.

Additional the maximum number of decimal places can be set with `Round`.

![grafik](https://user-images.githubusercontent.com/36999612/121774734-139b5280-cb84-11eb-8a80-85df783ea1f4.png)


## Operators and functions

Variables names may start with [_A-Za-z] but not with [0-9]

1.) Variables stored with ":=":

    If you define "b=2,x:=4+b" and then set "b=5", "x" evaluates to 9.
    So you can use the variable like a function.
    
2.) Variables stored with "=":

    If you define "b=2,x=4+b" and then set "b=5", "x" evaluates to 6

Predefined constants:

    "e"        Euler's number
    "pi", "π"  Two pi :)

Predefined var:

    "ans"   42

The following operators are supported with increasing priority:
```
    ","  sequential
    ":=" store tree
    "+=" increase evaluated value by
    "-=" decrease evaluated value by
    "*=" multiply evaluated value by
    "/=" divide evaluated value by
    "="  store evaluated value,
    "?:" ternary like in C
    "&&" logical and, the lua way
    "||" logical or, the lua way
    "!&" logical nand, the lua way
    "<="
    "=="
    ">="
    "!="
    ">"
    "<"
    "+"  sing, add
    "-"  sign, subtract
    "*"  multiply
    "/"  divide
    "%"  modulo
    "^"  power
    "!"  factorial
```

The following functions are supported:
the angular functions can operate on degree, radiant and gon.
```
    "(", braces for identity function
    "abs("
    "acos("
    "asin("
    "atan("
    "bug("      show hints for a bug
    "cos("
    "exp("
    "floor("    round down
    "getAngleMode(" Info: degree, radiant, gon; not for calculations
    "kill("     delete a variable
    "ld("       logarithmus dualis
    "ln("       logarithmus naturalis
    "log("      logarithmus decadis
    "rnd("      random
    "rndseed("  randomseed
    "round("    round
    "setdeg(",  set angle mode to degree
    "setgon(",  set angle mode to gon
    "setrad(",  set angle mode to radiant
    "showvars(",  show defined variables
    "sin("
    "sqrt("
    "tan("
    "√("
```

Examples:
```
    3+4*5    -> 23
    ld(1024) -> 10
    3>4      -> true
    4!=4     -> false
    x= 3>4 ? 1 : -1 -> -1, set x=-1
    x=2,y=4  -> 4, set x=2 and y=4
    1>2 || 2<10 && 7 -> 7
```

