# calculator.koplugin
A calculator plugin for KOReader.

## Installation
Go to https://github.com/zwim/calculator.koplugin/releases and download the desired `koreader.plugin-x.x.x.zip` and unpack it to `koreader/plugins/calculator.koplugin`.

Predefined physical constants, are in `init.calc`. You can autoload them (see settings menu). If you don't need them delete `init.calc`.

The file `VERSION` is used for update-informations. If you delete it, you don't get a notification update.


## Usage

You find the calculator in `More tools/calculator` additionally you can set a gesture (in the device submenu) to call it.

If you select a text starting with a number in reader and long press on it (>4 seconds), then you can select `Convert unit`, which directly brings you to unit conversion. (see: https://github.com/koreader/koreader/issues/10834)

Enter a calculation and press `⮠`. You can see your inputs in lines starting with `ixxx:` and the results in lines with `oxxx:`.

If you change something in an old line, this line will be used for the next calculation.

The results are stored in variables `o1, o2, ...` and the last result is additional in the variable `ans`.

Most of the time you can skip the opening braces in a function (e.g. sin40+66 is replaces with sin(40+6); but sin40)+60 gives sin(40)+60; try it out).

All the entered calculations and the results can be saved with the `⇩'` button.

Predefined expressions my be loaded with the `⇧` button.

You change the settings in the Hamburger menu.

![grafik](https://user-images.githubusercontent.com/36999612/122679158-18967c80-d1ea-11eb-9a20-177d41908e9b.png)

![grafik](https://user-images.githubusercontent.com/36999612/122679584-c35b6a80-d1eb-11eb-9c31-e28a7008fe89.png)


You can set the output to different modi: For example if the evaluation yields 12345678.9

`Scientific` -> 1.23456789E+7

`Engineer` -> 12.3456789E+6

`Auto` -> switches to Scientific if the absolute value is greater than 1000000 or less than 0.0001

`Native` -> show what lua calculates

`Programmer` -> show the result in `Auto` plus the value in HEX.

Additional the maximum number of significant places can be set with `Significance ≈`. (e.g. significance set to 2: 0.0001234 -> 0.00012)

![grafik](https://user-images.githubusercontent.com/36999612/122679565-af176d80-d1eb-11eb-881a-a06c100efe36.png)


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
    "##" logical nand, the lua way, -> logical not
    "~~" logical nand, the lua way
    "&"  bitwise and
    "|"  bitwise or
    "#"  bitwise nand -> bitwise not
    "~"  bitwise nand
    "<="
    "=="
    ">="
    "!="
    ">"
    "<"
    "+"  sign, add
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
    "avg("      average of multiple values
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
    3<4      -> true
    4!=4     -> false
    x= 3>4 ? 1 : -1 -> -1, set x=-1
    x=2,y=4  -> 4, set x=2 and y=4
    1>2 || 2<10 && 7 -> 7
```
