
  

# Pong GB

Pong ported to the original [Gameboy](https://en.wikipedia.org/wiki/Game_Boy) using the [Rednex Gameboy Development System (RGBDS)](https://rgbds.gbdev.io/).

  

Requires an emulator to run. Personal recommendation: [Emulicious](https://emulicious.net/)

  

## Contents:

* [Installation](#installation)

* [Running](#running)

* [Makefile Targets](#makefile-targets)

* [Known Issues](#known-issues)

  

## Installation

Clone the repo using:

```sh

git  clone  https://github.com/Yashovardhan-Singh/Pong-GB.git  --recursive

```

Then initialize submodules to store them locally:

```sh

git  submodule  init

```

Update the submodules:

```sh

git  submodule  update

```

There is only one dependency for compiling, which is [RGBDS](https://rgbds.gbdev.io/). This repository does add it as a submodule, and you can compile it yourself or look up [Install instructions](https://rgbds.gbdev.io/install)

  

To use a local installation of RGBDS or after compiling the submodule, edit the variable in makefile:

```make

...

  

RGBDS ?= <path-to-rgbds-installation>

  

RGBASM := $(RGBDS)rgbasm

RGBLINK := $(RGBDS)rgblink

...

```

or run:

```make

make RGBDS=<path-to-rgbds-installation>

```

  

## Running

To change which emulator you want to run the ROM with, edit the EMU variable in makefile or run with:

  

```make

make run EMU=<path-to-emulator>

```
  


## Makefile Targets

* <ins>all</ins>: Run targets in the following order: Build sprites -> Build Objects -> Link objects -> Add header -> Build ROM -> Zip ROM -> Run ROM on emulator  

* <ins>default</ins>: only builds the ROM by building sprites, objects, linking, and fixing headers  
 
* <ins>rebuild</ins>: cleans artefacts from previous builds, configures the project, builds the rom again by running the "Default" target  

* <ins>pre-config</ins>: Checks if necessary output directories exist, and if not, then creates them  

* <ins>objects</ins>: Build object files from all the source files in project  

* <ins>link</ins>: Links object files to the ROM  

* <ins>fix</ins>: Fix ROM headers and provide metadata of ROM  

* <ins>clean</ins>: Removes all output files generated, i.e: Objects, ROM, Zips, Generated Assets  

* <ins>run</ins>: Rebuilds the ROM through the "rebuild" target first, then runs it using the emulator provided  

* <ins>release</ins>: Compresses ROM to a zip for release  

* <ins>sprites</ins>: Generates GB compatible sprite files from raw .PNG



## Known Issues

* <ins>Collision</ins>: I am aware sometimes the ball gets stuck and bounces inside the paddle a lot, that's an issue cause i am using Point-Rect Collision formula for collisions. The fix will not be implemented, cause i am lazy. Possible solution: While checking Y collision with the paddle, if the X coordinate is inside the paddle but the y coordinate is greater or equal to, just invert the Y coordinate.  

  
* <ins>Sound</ins>: Related to collision, the sound being played for too long is because the ball is stuck in a paddle, so every frame that it's stuck it plays and stops a sound, which causes that weird drawn out beep instead of normal one. Should be fixed with collision.  

  
* <ins>Impossible to win</ins>: Balancing issues in the enemy AI, can't figure out a good speed in general, and implementing checks to decide what speed to pick is tedious. Possible fix: Pick speed based on the difference of the Y coordinate of the ball, and Y coordinate of enemy Paddle, the greater the distance, the greater the speed and vice-a-versa.