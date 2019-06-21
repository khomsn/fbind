#!/system/bin/sh
# Turn SDcard into internal storage (/data/media/0)

(partition=mmcblk1p1
until [ -b /dev/block/$partition ]; do sleep 2; done
blkid /dev/block/$partition | grep -q 'ext[234]' && fsck -fy /dev/block/$partition >/dev/null
setenforce 0
/sbin/su -Mc mount -t auto -o rw,noatime /dev/block/$partition /data/media/0 &) &
exit 0
