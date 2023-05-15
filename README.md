# LLPdTools

This is a collection of tools that I've made to help with development
for the PlayDate console platform.

- **playdate-select** lets you select the active Playdate SDK version
- **pdxinfo-extract** returns the values out of a project's PDXINFO file
- **Makefile.Lua.mk** a makefile to be included that provides build, test, and distribution targets


# Initial Setup

First of all, I recommend that you check out this project from within
your ~/Developer/ directory.  This will make sure that the included
Makefile will work properly.  This is optional, of course.  More about
the makefile stuff in the next section.

When Playdate SDKs are installed, the version number for previous
SDKs are renamed from "PlaydateSDK" to like "PlaydateSDK-1.13.4"

Rename your PlaydateSDK/ directory in this fashion, appropriately. eg:

    # cd ~/Developer/
    # mv PlaydateSDK PlaydateSDK-1.15.3

Next, for ease of use, make two symlinks for SDK 1.x and 2.x:

    # cd ~/Developer/
    # ln -s PlaydateSDK-1.13.7 Playdate-1
    # ln -s PlaydateSDK-2.0.0 Playdate-2

This tool takes a parameter to determine which SDK to move in 
to be the active one.  For example, if you want SDK v1.(whatever), 
and things are configured as above, you can type:

    # ~/Developer/playdate-select/playdate-select.sh 1

This will create a new symlink from "PlaydateSDK" that points 
at "PlaydateSDK-1". Similarly, if you want version 1.13.2 (and you
have it installed, of course):

    # ~/Developer/playdate-select/playdate-select.sh 1.13.2

This will remove an existing symlink, and then create a new symlink 
from "PlaydateSDK" that points at "PlaydateSDK-1.13.2".

Or, more generally, it will remove an existing symlink named 
"PlaydateSDK" and replace it with "PlaydateSDK-" + selected version.

The script itself looks at your ~/.Playdate/config for the base name
of the SDK.


# Makefile.Lua.mk

The included makefile, 'Makefile.Lua.mk' allows you to build your lua 
project with one SDK and test on another.  In your project, next 
to your Source directory, create a file named "Makefile" with the contents:

    include ~/Developer/playdate-select/Makefile.Lua.mk

And now, in that directory, if you just type "make" it will build for 1.x 
and run it in the 2.x simulator.  You can of course override it, copy it,
whatever... or don't use it at all. :D


# pdxinfo-extract.sh

This tool is used by the makefile to extract the app name and the build/version number to be used for the 'dist' task, building the zip file.