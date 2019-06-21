#!/system/bin/sh
# remove leftovers

(until [ -d /data/adb/fbind ]; do sleep 20; done
rm -rf /data/adb/fbind
exit 0 &) &
exit 0
