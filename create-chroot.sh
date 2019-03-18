#!/bin/sh

[ -z "$MOZCONFIG" ] && MOZCONFIG="$3"
[ -z "$MOZCONFIG" ] && MOZCONFIG="mozconfig.tpl"
[ -z "$UXPTGZ" ] && UXPTGZ="$4"
[ -z "$UXPTGZ" ] && UXPTGZ="uxp.tgz"
[ -z "$TARGET_ARCH" ] && TARGET_ARCH="$2"
[ -z "$TARGET_ARCH" ] && TARGET_ARCH="amd64"
[ -z "$HOST_ARCH" ] && HOST_ARCH="amd64"
[ -z "$DEBIAN_SUITE" ] && DEBIAN_SUITE=stable

[ "$TARGET_ARCH" = "amd64" ] && TARGET_ARCH_NATIVE=1

case $TARGET_ARCH in
	amd64)
	TARGET_TRIPLE="x86_64-linux"
	;;
	i386)
	;;
	armhf)
	TARGET_TRIPLE="arm-linux-gnueabihf"
	;;
	*)
	echo "Sorry, don't know the target triple!" >&2
	exit 1
	;;
esac

DIR="$1"

[ ! -f $DIR/bin/bash ] && { debootstrap --arch $HOST_ARCH $DEBIAN_SUITE $DIR || exit 1; }

cp chroot-init-payload.sh $DIR || exit 1
cp varsubst.sh $DIR || exit 1
cp $MOZCONFIG $DIR || exit 1
cp $UXPTGZ $DIR || exit 1

export TARGET_TRIPLE="$TARGET_TRIPLE"
export TARGET_ARCH="$TARGET_ARCH"
export TARGET_ARCH_NATIVE="$TARGET_ARCH_NATIVE"

chroot $DIR /chroot-init-payload.sh || exit 1
