#!/bin/bash

GODOT="${GODOT_EXE:-godot}"
BUILD_PATH=$PWD/build

if [ ! -d "$BUILD_PATH" ]; then
	mkdir $BUILD_PATH
fi

echo "Using Godot: $GODOT"

CONTENT=$PWD/content
echo "Exporting content.pck from $CONTENT"
$GODOT -q --headless --path $CONTENT --import
$GODOT -q --headless --path $CONTENT --export-pack PCK $BUILD_PATH/content.pck

CLIENT=$PWD/client
echo "Exporting client from $CLIENT"
echo "Exporting for Linux"
if [ ! -d "$BUILD_PATH/linux" ]; then
	mkdir $BUILD_PATH/linux
fi
$GODOT -q --headless --path $CLIENT --import
$GODOT -q --headless --path $CLIENT --export-debug Linux $BUILD_PATH/linux/Vulnus.x86_64
echo "Copying content.pck"
cp $BUILD_PATH/content.pck $BUILD_PATH/linux/content.pck

echo "Exporting for Windows"
if [ ! -d "$BUILD_PATH/win" ]; then
	mkdir $BUILD_PATH/win
fi
$GODOT -q --headless --path $CLIENT --export-debug Windows $BUILD_PATH/win/Vulnus.exe
echo "Copying content.pck"
cp $BUILD_PATH/content.pck $BUILD_PATH/win/content.pck