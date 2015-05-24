#!/bin/sh

amxmlc -swf-version 28 -default-frame-rate 60 -default-size 768 560 -library-path+=lib/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf -define+=CONFIG::desktop,true -define+=CONFIG::web,false

# adl application.xml

# adt -certificate -cn asdf 2048-RSA cert.p12 dummypass
# adt -package -storetype pkcs12 -keystore cert.p12 -storepass dummypass -target bundle something.app application.xml BoscaCeoil.swf assets
