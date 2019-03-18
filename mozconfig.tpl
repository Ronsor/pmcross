# .mozconfig template for building
mk_add_options AUTOCLOBBER=1
# don't change this path!
mk_add_options MOZ_OBJDIR=/root/pmbuild/

# cross compiling options
CROSS? export PKG_CONFIG=%TARGET_TRIPLE%-pkg-config 
CROSS? export STRIP=%TARGET_TRIPLE%-strip
CROSS? export OBJCOPY=%TARGET_TRIPLE%-objcopy
CROSS? export AR=%TARGET_TRIPLE%-ar
CROSS? ac_add_options --target=%TARGET_TRIPLE%


ac_add_options --enable-application=palemoon 
ac_add_options --enable-optimize="-O2"
export MOZILLA_OFFICIAL=1
ac_add_options --enable-default-toolkit=cairo-gtk2
ac_add_options --enable-jemalloc
ac_add_options --enable-strip
ac_add_options --with-pthreads
 
ac_add_options --disable-tests
ac_add_options --disable-eme
ac_add_options --disable-parental-controls
ac_add_options --disable-accessibility
ac_add_options --disable-webrtc
ac_add_options --disable-dbus
ac_add_options --disable-gamepad
ac_add_options --disable-necko-wifi
ac_add_options --disable-updater
ac_add_options --disable-gconf
ac_add_options --disable-safe-browsing
ac_add_options --enable-alsa
ac_add_options --disable-pulseaudio
