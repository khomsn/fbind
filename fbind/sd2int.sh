#!/system/bin/sh
# Turn SDcard into internal storage (/data/media/)
# Copyright (c) 2019, VR25 @ xda-developers
# License: GPLv3+

(partition=/dev/block/mmcblk1p1
permissiveSELinux=true
timeout=1800
fsck=true
count=0

# custom config
[ -f /data/adb/sd2int.conf ] && . /data/adb/sd2int.conf

# wait for block device
until [ -b $partition ]; do
  count=$((count+2))
  [ $count -ge $timeout ] && exit 0
  sleep 2
done

if $fsck; then
  case $(blkid $partition) in
    *ext[234]*) fsck -fy /dev/block/$partin;;
    *vfat*|*fat32*) fsck_msdos -y $partition;;
    *f2fs*) fsck.f2fs -y $partition;;
  esac > /dev/null
fi

$permissiveSELinux && setenforce 0

/sbin/su -Mc mount -t $(blkid | grep $partition | sed -e 's|.*TYPE="||' -e 's|".*||') -o rw,noatime $partition /data/media &) &
exit 0
