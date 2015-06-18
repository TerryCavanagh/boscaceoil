# Bosca Ceoil

A simple music making program

## Modifying Bosca Ceoil itself

Bosca Ceoil is an Adobe AIR application, written in the programming language
called "ActionScript 3". Making changes to Bosca Ceoil involves changing
ActionScript code.

### Pre-requisites

Make sure you've got the [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html)
installed.

### Building

The easiest way to compile Bosca Ceoil is on windows - install FlashDevelop on your computer, then install the latest AIR SDK from Adobe. Then you can compile it by opening the Bosca Ceoil.as3proj file. Alternatively, you can use the command line.

The AIR SDK includes a tool called `amxmlc`, which is the compiler we'll use to
turn the ActionScript 3 code into an .swf "movie" (which is the term for
`.swf` files even when they represent applications).

The compiler needs quite a few options to produce a working Bosca Ceoil
"movie":

```
    amxmlc -swf-version 28 -default-frame-rate 60 -default-size 768 560 -library-path+=lib/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf -define+=CONFIG::desktop,true -define+=CONFIG::web,false
```

All the NativeApplication, File, etc. stuff from the Air API needs to be wrapped in CONFIG::desktop { ... } blocks so they don't get compiled into the web version, or else it breaks.

Desktop builds will now have to be compiled with the -define+=CONFIG::desktop,true -define+=CONFIG::web,false flags.
Likewise, web builds will have to be compiled with -define+=CONFIG::desktop,false -define+=CONFIG::web,true.


### Running

The AIR application description file, `application.xml`, tells AIR about the application you'd like to create from which movie files.

The AIR SDK comes with a tool called `adl`, the Application Description Loader, which lets you run Bosca with the newly-compiled SWF:

```
    adl application.xml
```

If you want to distribute the application, the AIR SDK contains all the tools you'll need for that.

Available under the FreeBSD licence. Feel free to fork Bosca Ceoil and do your own thing with it!
