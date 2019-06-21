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




umask 0
modPath=/system/etc/fbind
log=/data/adb/fbind/logs/fbind-boot-$(getprop ro.product.device | grep .. || getprop ro.build.product).log
[ -f $modPath/module.prop ] || modPath=/sbin/.core/img/fbind
[ -f $modPath/module.prop ] || modPath=/sbin/.magisk/img/fbind

# log
mkdir -p ${log%/*}
[ -f $log ] && mv $log $log.old
exec 1>$log 2>&1
date
grep versionCode $modPath/module.prop
echo "Device=$(getprop ro.product.device | grep .. || getprop ro.build.product)"
echo
set -x
 
. $modPath/core.sh

# disable "force FUSE" if that causes bootloop
if [ -f $modData/.fuse ]; then
  mv $modPath/system.prop $modPath/FUSE.prop 2>/dev/null
  rm $modData/.fuse
else
  touch $modData/.fuse
fi

if grep -q noAutoMount $config; then
  rm $modData/.fuse 2>/dev/null
  exit 0
fi

apply_config # and mount partitions & loop devices
grep -Eq '^int_extf|^bind_mount |^obb.*|^from_to |^target ' $config && bind_mount_wrapper
grep -q '^remove ' $config && remove_wrapper
rm $modData/.fuse 2>/dev/null
exit 0) &

exit 0
 