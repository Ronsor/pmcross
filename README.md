# PMCross

PMCross is a tool to help you cross-compile Pale Moon for different architectures. You have to run it as root, as it uses chroot.

### Tested:

* Linux/amd64
* Linux/armhf

### Dependencies:

* debootstrap
* GNU make

### Example:

Make an ARM build.

```
wget -O uxp.tgz https://github.com/MoonchildProductions/UXP/archive/master.tar.gz
./create-chroot.sh rootfs armhf
./chroot-mach.sh rootfs build
./chroot-mach.sh rootfs package
```
