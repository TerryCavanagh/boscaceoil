BOSCA CEOIL v1.1

A simple music making program

Terry Cavanagh / http://www.distractionware.com

-=-=-=-=-=-=-=-=

### Pre-requisites
Make sure you've got the AIR SDK installed. You'll also need a copy of a particular version (0.65) of the SiON library that powers Bosca Ceoil's sound.


### Building
```
    amxmlc -swf-version 20 -default-frame-rate 60 -default-size 768 480 -library-path+=libs/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf
```

### Running

This compiles the app into `BoscaCeoil.swf`, which you can run with:

```
    adl application.xml
```




Available under the FreeBSD licence. Fork away!

---

Copyright 1992-2013 Terry Cavanagh. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY TERRY CAVANAGH ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FREEBSD PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of Terry Cavanagh.