# PDP Gimp Scripts #

## Installation ##

You can either clone the git repository, or if you are just interested in using the scripts (without modifying them), simply download the SCM file(s) and move them into the directory that your Gimp/Preferences identifies as your Scripts folder.

From there, you can find the menu item in Image/Resample.

## Current Status ##

Troublingly, when `gimp-displays-flush` is included (so that we can see the results of the script), subsequent calls to the `Resample` script are blocked until the Script-Fu scripts are refreshed.