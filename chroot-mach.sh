#!/bin/sh
DIR="$1"
shift
exec chroot "$DIR" bash -c "cd /root/UXP-master; ./mach $*; exit $?"
