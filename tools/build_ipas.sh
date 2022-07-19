#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: build_ipas.sh <path to Fugu16App.app> <path to mounted root file system>"
    exit -1
fi

if [ ! -f "./pwnify_compiled" ]; then
    echo "Couldn't find ./pwnify_compiled"
    echo "Please compile pwnify and put it into the current directory as pwnify_compiled"
    exit -1
fi

# Create IPA structure
mkdir -p Payload
rm -rf Payload/Fugu16App.app
rm -f Fugu16_Setup.ipa Fugu16_Pwn.ipa

# Build first IPA
cp -r "$1" Payload/Fugu16App.app
zip -r Fugu16_Setup.ipa Payload

# Inject Spotlight
./pwnify_compiled Payload/Fugu16App.app/Fugu16App "$2/Applications/Spotlight.app/Spotlight"

# Build second IPA
cp Fugu16_Setup.ipa Fugu16_Pwn.ipa
zip Fugu16_Pwn.ipa Payload/Fugu16App.app/Fugu16App

rm -rf Payload
