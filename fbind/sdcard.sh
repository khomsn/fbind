#!/system/bin/sh
# /system/bin/sdcard replacement
# Copyright (C) 2019, VR25 @ xda-developers
# License: GPLv3+

sdPart=mmcblock1p1

# SELinux mode
setenforce 0

# tmpfs
mkdir -p /mnt /storage
for dir in /mnt /storage; do
  chmod 0777 $dir
  if grep -q "tmpfs $dir" /proc/mounts; then
    mount -o remount,rw,gid=9997,uid=9997,mode=777 $dir
  else
    mount -t tmpfs -o rw,gid=9997,uid=9997,mode=777 tmpfs $dir
  fi
fi

# create directories
for dir in /mnt/runtime/default/emulated \
  /storage/emulated \
  /mnt/runtime/read/emulated \
  /mnt/runtime/write/emulated \
  /storage/0000-0000 \
  /mnt/media_rw/0000-0000 \
  /mnt/runtime/default/0000-0000 \
  /mnt/runtime/read/0000-0000 \
  /mnt/runtime/write/0000-0000 \
  /storage/self \
  /mnt/runtime/default/self \
  /mnt/user/0
do
  mkdir -p $dir
  chmod 0777 $dir
done

# internal storage (bind-mounts)
echo "/mnt/runtime/default/emulated
/storage/emulated
/mnt/runtime/read/emulated
/mnt/runtime/write/emulated" | xargs su -Mc mount -o bind,rw,noatime,gid=9997 /data/media

# internal storage (symlinks)
echo "/storage/self/primary
/mnt/sdcard 
/mnt/runtime/default/self/primary
/mnt/user/0/primary" | xargs ln -fs /storage/emulated/0

# SDcard (regular mount)
mount -t auto -o rw,noatime /dev/block/$sdPart /storage/0000-0000

# SDcard (bind-mounts)
echo "/mnt/media_rw/0000-0000
/mnt/runtime/default/0000-0000
/mnt/runtime/read/0000-0000
/mnt/runtime/write/0000-0000" | xargs su -Mc mount -o bind,rw,noatime,gid=9997 /storage/0000-0000
