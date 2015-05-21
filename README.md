# BOSCA CEOIL v2.0

A simple music making program

Terry Cavanagh / http://www.distractionware.com

-=-=-=-=-=-=-=-=

## Modifying Bosca Ceoil itself

Bosca Ceoil is an Adobe AIR application, written in the programming language
called "ActionScript 3". Making changes to Bosca Ceoil involves changing
ActionScript code.


### Pre-requisites

Make sure you've got the [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html)
installed.


### Building

The AIR SDK includes a tool called `amxmlc`, which is the compiler we'll use to
turn the ActionScript 3 code into an .swf "movie" (which is the term for
`.swf` files even when they represent applications).

The compiler needs quite a few options to produce a working Bosca Ceoil
"movie":

```
    amxmlc -swf-version 20 -default-frame-rate 60 -default-size 768 480 -library-path+=lib/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf -define+=CONFIG::desktop,true -define+=CONFIG::web,false
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


Available under the FreeBSD licence. Fork away!

---

Copyright 1992-2013 Terry Cavanagh. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY TERRY CAVANAGH ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FREEBSD PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of Terry Cavanagh.