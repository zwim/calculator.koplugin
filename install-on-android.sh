#!/bin/bash

if [[ "$1" == "" ]]; then
	echo "usage: install-on-android zipfile"
	exit 1 
fi

adb push $1 /sdcard/koreader/plugins/
adb shell  "cd /sdcard/koreader/plugins/; unzip $1"
adb shell  "cd /sdcard/koreader/plugins/; busybox unzip $1"
