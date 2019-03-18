#!/bin/bash
# Payload to initialize the chroot
export PATH="$PATH:/"
SAVE_TARGET_ARCH_NATIVE="$TARGET_ARCH_NATIVE"
TARGET_ARCH_NATIVE="0$TARGET_ARCH_NATIVE -gt 0"
NOT_TARGET_ARCH_NATIVE="0$SAVE_TARGET_ARCH_NATIVE -eq 0"

if test $TARGET_ARCH_NATIVE; then
	echo "How nice! not cross compiling today!" >&2
else
	dpkg --add-architecture $TARGET_ARCH
fi


HOST_PACKAGES="python python2.7 yasm autoconf2.13 build-essential zip unzip $EXTRA_HOST_PACKAGES"
TARGET_PACKAGES="libgtk2.0-dev libdbus-glib-1-dev libegl1-mesa-dev libasound2-dev"
TARGET_PACKAGES="$TARGET_PACKAGES libxt-dev zlib1g-dev libssl-dev libsqlite3-dev libbz2-dev $EXTRA_TARGET_PACKAGES"

if test $NOT_TARGET_ARCH_NATIVE; then
	TARGET_PACKAGES="$(echo "$TARGET_PACKAGES" | awk -vappend=":$TARGET_ARCH" 'BEGIN{RS=" "}$1!=""{printf("%s%s ",$1,append)}')"
	echo "TARGET PACKAGES: $TARGET_PACKAGES"
fi

apt update
apt install -y --no-install-recommends $HOST_PACKAGES
apt install -y --no-install-recommends $TARGET_PACKAGES

[ ! -d /root/UXP-master ] && tar -C /root -xzf /uxp.tgz
if [ "$TARGET_ARCH" != "amd64" ] && [ "$TARGET_ARCH" != "i386" ] && [ "0$NO_MONKEY_PATCHING" -eq 0 ]; then
	sed -i 's/-msse2 -mfpmath=sse//g' /root/UXP-master/build/autoconf/compiler-opts.m4
if [ "$TARGET_ARCH" = "armhf" ]; then
	# Fix ARM JIT
	sed -i -e 's/.*toMarkablePointer.*/{}/g' -e 's/.*val.isMarkable.*/if(0)/g' /root/UXP-master/js/src/jit/arm/MacroAssembler-arm.cpp
fi
fi

varsubst.sh "TARGET_ARCH TARGET_TRIPLE NO_MONKEY_PATCHING" < /mozconfig.tpl > /mozconfig

if test $TARGET_ARCH_NATIVE; then
	grep -vE '^CROSS' /mozconfig > /root/UXP-master/.mozconfig
else
	sed 's/^CROSS? //g' /mozconfig > /root/UXP-master/.mozconfig
fi

echo Configured chroot.
