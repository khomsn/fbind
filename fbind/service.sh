#!/system/bin/sh
# fbind initializer
# Copyright (C) 2017-2019, VR25 @ xda-developers
# License: GPLv3+

# prepare working directory
([ -d /sbin/.fbind ] && exit 0
mkdir /sbin/.fbind
ln -fs ${0%/*} /sbin/.fbind/fbind
ln -fs /sbin/.fbind/fbind/fbind /sbin/fbind

# fix termux su PATH
termuxSu=/data/data/com.termux/files/usr/bin/su
if [ -f $termuxSu ] && grep -q '/su:' $termuxSu; then
  sed -i 's|/su:|:|' $termuxSu
  magisk --clone-attr ${termuxSu%su}apt $termuxSu
fi
unset termuxSu

/sbin/.fbind/fbind/fbind-init
exit 0 &) &

exit 0
 