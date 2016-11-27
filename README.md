# tla.vim

Vim plugin for TLA+ and PlusCal. Helps with writing specs. Since there's no official TLA+ styleguide, it currently just implements my preferences. The plugin makes the following assumptions:

* You're using p-syntax. I prefer that to c-syntax because it doesn't overload the meaning of `{}` and makes the indentation file not hair-pullingly impossible.
* You're only using vim to write your spec, not to typeset or run models. Modelling is waaaaaay too complicated to be part of a text editor. Use the [TLA+ Toolbox](http://research.microsoft.com/en-us/um/people/lamport/tla/toolbox.html) for that instead.

## Current Functionality

* Some syntax highlighting
* Handles `\*` as a comment
* Autofolds PlusCal translations
* Functions for SANY and PlusCal translation
* Some indentation logic

## Planned Functionality

* Command line options for PlusCal translation
* Documentation
* More indentation
* More syntax highlighting
* Better handling of editing PlusCal algorithms
* Vim Definitions

## Pie-In-The-Sky Functionality

* Dumping SANY errors into a quickfix list
* A way to highlight expressions that are valid but not TLC-compatible
* Tags
* Rewrite in something that isn't Vimscript
* Making sure it plays nice with TLA+2
