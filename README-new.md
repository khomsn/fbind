# fbind - Advanced Mount Wrapper



---
## LEGAL

Copyright (C) 2017-2019, VR25 @ xda-developers

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.



---
## DISCLAIMER

Always read/reread this reference prior to installing/upgrading this software.

While no cats have been harmed, the author assumes no responsibility for anything that might break due to the use/misuse of it.

To prevent fraud, do NOT mirror any link associated with this project; do NOT share builds (zips)! Share official links instead.



---
## DESCRIPTION

This is an advanced mounting utility for folders, EXT4 images (loop devices), LUKS/LUKS2 encrypted volumes, regular partitions and more.



---
## PREREQUISITES

- ARM/ARM64 CPU for `cryptsetup` (optional)
- Any root solution
- Terminal emulator
- Text editor (optional)



---
## BUILDING FROM SOURCE


Dependencies

- curl (optional)
- git
- zip


Steps

1. `git clone https://github.com/VR-25/fbind.git`
2. `cd acc`
3. `sh build.sh` (or double-click `build.bat` on Windows, if you have Windows subsystem for Linux installed)


Notes

- The output file is _builds/acc-$versionCode.zip.

- By default, `build.sh` auto-updates the [update-binary](https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh). To skip this, run `sh build.sh f` (or `buildf.bat` on Windows).

- To update the local repo, run `git pull -f`.

- To install/upgrade straight from source, refer to the next section.



---
## SETUP


### Magisk 18.2+

Install/upgrade: flash live (e.g., from Magisk Manager) or from custom recovery (e.g., TWRP).

Uninstall: use Magisk Manager (app) or [Magisk Manager for Recovery Mode (utility)](https://github.com/VR-25/mm/).


### Any Root Solution (Advanced)

Install/upgrade: extract `acc-*.zip`, run `su`, then execute `sh /path/to/extracted/install-current.sh`.

Uninstall: for Magisk install, use Magisk Manager (app); else, run `su -c rm -rf /data/adb/acc/`.


### Notes

ACC supports live upgrades - meaning, rebooting after installing/upgrading is unnecessary.

For non-Magisk install, `/data/adb/acc/acc-init.sh` must be executed on boot to initialize acc. Without this, acc commands won't work. Additionally, ff your system lacks executables such as `awk` and `grep`, [busybox](https://duckduckgo.com/?q=busybox+android) or similar binary must be installed prior to installing acc.



---
## CONFIG SYNTAX
```
bind_mount <target> <mount point>   Generic bind-mount
  e.g., bind_mount $extsd/loop_device/app_data/spotify /data/data/com.spotify.music

extsd_path <path>   Use <path> as extsd.
  e.g., extsd_path /mnt/mmcblk1p2

from_to <source> <dest>   Wrapper for bind_mount <$extsd/[path]> <$intsd/[path]>
  e.g., from_to WhatsApp .WhatsApp

<fsck> <block device>   Check/fix external partition before system gets a chance to mount it. This is great for EXT[2-4] filesystems (e2fsck -fy is stable and fast) and NOT recommend for F2FS (fsck.f2fs can be extremely slow and cause/worsen corruption).
  e.g., e2fsck -fy /dev/block/mmcblk1p1

int_extf <path>   Bind-mount the entire user 0 (internal) storage to $extsd/<path> (implies obb). If <path> is not supplied, .fbind is used.
  e.g., int_extf .external_storage

intsd_path <path>   Use <path> as intsd.
  e.g., intsd_path /storage/emulated/0

loop <.img file> <mount point>   Mount an EXT4 .img file (loop device). e2fsck -fy <.img file> is executed first.
  e.g., loop $extsd/loop.img $intsd/loop

noAutoMount   Disable on boot auto-mount.

noWriteRemount   Read the SDcardFS note below.

obb   Wrapper for bind_mount $extobb $obb

obbf <package name>   Wrapper for bind_mount $extobb/<package name> $obb/<package name>
  e.g., obbf com.mygame.greatgame

part <[block device] or [block device--L]> <mount point> <"fsck -OPTION(s)" (filesystem specific, optional)>   Auto-mount a partition. The --L flag is for LUKS volume, opened manually by running any fbind command. Filesystem is automatically detected. The first two arguments can be -o <mount options>, respectively. In that case, positional parameters are shifted. The defaut mount options are rw and noatime.
  e.g., part /dev/block/mmcblk1p1 /mnt/_sdcard
  e.g., part -o nodev,noexec,nosuid /dev/block/mmcblk1p1 /mnt/_sdcard

permissive   Set SELinux mode to permissive.

remove <target>   Auto-remove stubborn/unwanted file/folder from $intsd & $extsd.
  e.g, remove Android/data/com.facebook.orca, remove DCIM/.8be0da06c44688f6.cfg

target <path>   Wrapper for bind_mount <$extsd/[path]> <$intsd/[same path]>
  e.g., target Android/data/com.google.android.youtube
```


---
## USAGE


ACC is designed to run out of the box, without user intervention. You can simply install it and forget. However, as it's been observed, most people will want to tweak settings - and obviously everyone will want to know whether the thing is actually working.

If you feel uncomfortable with the command line, skip this section and use the [ACC app](https://github.com/MatteCarra/AccA/releases/) to manage ACC.

Alternatively, you can use a `text editor` to modify `/sdcard/acc/config.txt`. Changes to this file take effect almost instantly, and without a [daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) restart.


### Terminal Commands
```
Usage: fbind or fbind <options(s)> <argument(s)>

<no options>   Launch the folder mounting wizard.

-a|--auto-mount   Toggle on boot auto-mount (default: enabled).

-b|--bind-mount <target> <mount point>   Bind-mount folders not listed in config.txt. Extra SDcarsFS paths are handled automatically. Missing directories are created accordingly.
  e.g., fbind -b /data/someFolder /data/mountHere

-c|--config <editor [opts]>   Open config.txt w/ <editor [opts]> (default: vim/vi).
  e.g., fbind -c nano -l

-C|--cryptsetup <opt(s)> <arg(s)>   Run $modPath/bin/cryptsetup <opt(s)> <arg(s)>.

-f|--fuse   Toggle force FUSE yes/no (default: no). This is automatically enabled during installation if /data/forcefuse exists or the zip name contains the word "fuse" (case insensitive) or PROPFILE=true in config.sh. The setting persists across upgrades.

-h|--help  List all commands.

-i|--info   Show debugging info.

-l|--log  <editor [opts]>   Open fbind-boot-\$deviceName.log w/ <editor [opts]> (default: vim/vi).
  e.g., fbind -l

-m|--mount <pattern|pattern2|...>   Bind-mount matched or all (no arg).
  e.g., fbind -m Whats|Downl|part

-M|--move <pattern|pattern2|...>   Move matched or all (no args) to external storage. Only unmounted folders are affected.
  e.g., fbind -M Download|obb

-Mm <pattern|pattern2|...>   Same as "fbind -M <arg> && fbind -m <arg>"
  e.g., fbind -Mm

-r|--readme   Open README.md w/ <editor [opts]> (default: vim/vi).

-R|--remove <target>   Remove stubborn/unwanted file/folder from $intsd and $extsd. <target> is optional. By default, all <remove> lines from config are included.
  e.g., fbind -R Android/data/com.facebook.orca

-u|--unmount <pattern|pattern2|... or [mount point] >   Unmount matched or all (no arg). This works for regular bind-mounts, SDcardFS bind-mounts, regular partitions, loop devices and LUKS/LUKS2 encrypted volumes. Unmounting all doesn't affect partitions nor loop devices. These must be unmounted with a pattern argument. For unmounting folders bound with the -b|--bind_mount option, <mount point> must be supplied, since these pairs aren't in config.txt.
  e.g., fbind -u loop|part|Downl

-um|--remount <pattern|pattern2|...>   Remount matched or all (no arg).
  e.g., fbind -um Download|obb
```


---
## NOTES/TIPS FOR FRONT-END DEVELOPERS


It's best to use full commands over short equivalents - e.g., `--set chargingSwitch` instead of `-s s`.

Use provided config descriptions for ACC settings in your app(s). Include additional information (trusted) where appropriate.


### Online ACC Install

- The installer must run as root (obviously).
- Log: /sbin/.acc/install-stderr.log
```
1) Check whether ACC is installed (exit code 0)
which acc > /dev/null

2) Download the installer (https://raw.githubusercontent.com/VR-25/acc/master/install-latest.sh)
- e.g., curl -#L [URL] > [output file] (progress is shown)

3) Run "sh [installer]" (progress is shown)
```

### Offline ACC Install

Refer to [SETUP > Any Root Solution (Advanced)](https://github.com/VR-25/acc/tree/master#any-root-solution-advanced) and [SETUP > Notes ](https://github.com/VR-25/acc/tree/master#notes).



---
## TROUBLESHOOTING


### Charging Switch

By default, ACC cycles through all available [charging control files](https://github.com/VR-25/acc/blob/master/acc/switches.txt) until it finds one that works.

Charging switches that support battery idle mode take precedence - allowing the device to draw power directly from the external power supply when charging is paused.

However, things don't always go well.
Some switches may be unreliable under certain conditions (e.g., screen off).
Others may hold a [wakelock](https://duckduckgo.com/?q=wakelock) - causing faster battery drain - while in plugged in, not charging state.

Run `acc --set chargingSwitch` (or `acc -s s` for short) to enforce a particular switch.

Test default/set switch(es) with `acc --test`.

Evaluate custom switches with `acc --test <file onValue offValue>`.


### Charging Voltage Limit

Unfortunately, not all devices/kernels support custom charging voltage limit.
Those that do are rare.
Most OEMs don't care about that.

The existence of a potential voltage control file doesn't necessarily mean it works.


### Restore Default Config

`acc --set reset` (or `acc -s r`)


### Slow Charging

Check whether charging current in being limited by `applyOnPlug` or `applyOnBoot`.

Nullify coolDownRatio (`acc --set coolDownRatio`) or change its value. By default, coolDownRatio is null.


### Logs

Logs are stored at `/sbin/.acc/`. You can export all to `/sdcard/acc-logs-$device.tar.bz2` with `acc --log --export`. In addition to acc logs, the archive includes `charging-ctrl-files.txt`, `charging-voltage-ctrl-files.txt`, `config.txt` and `magisk.log`.



---
## POWER SUPPLY LOG


Please upload `/sbin/.acc/acc-power_supply-*.log` to [this dropbox](https://www.dropbox.com/request/WYVDyCc0GkKQ8U5mLNlH/).
This file contains invaluable power supply information, such as battery details and available charging control files.
A public database is being built for mutual benefit.
Your cooperation is greatly appreciated.


Privacy Notes

- When asked for a name, give your `XDA username` or any random name.
- For the email, you can type something like `noway@areyoucrazy.com`.

Example
- Name: `user .`
- Email: `myemail@iscool.com`


See current submissions [here](https://www.dropbox.com/sh/rolzxvqxtdkfvfa/AABceZM3BBUHUykBqOW-0DYIa?dl=0).



---
## LOCALIZATION

Currently Supported Languages
- English (en): complete
- Portuguese (pt): partial

Translation Notes
- Translators should start with copies of [acc/strings.sh](https://github.com/VR-25/acc/blob/master/acc/strings.sh) and [README.md](https://github.com/VR-25/acc/blob/master/README.md) - and append the appropriate language suffix to the base names - e.g., `strings_it`, `README_it`.
- Anyone is free and encouraged to open translation [pull requests](https://duckduckgo.com/?q=pull+request).
- Alternatively, `strings_*.sh` and `README_*.md` files can be send to the developer.



---
## TIPS


### Generic

Force fast charge: `applyOnBoot=/sys/kernel/fast_charge/force_fast_charge:1`


### Google Pixel Family

Force fast wireless charging with third party wireless chargers that are supposed to charge the battery faster: `applyOnPlug=wireless/voltage_max:9000000`.


### Razer Phone

Alternate charging control configuration:
```
capacity=5,60,0,101
applyOnBoot=razer_charge_limit_enable:1 usb/device/razer_charge_limit_max:80 usb/device/razer_charge_limit_dropdown:70
```

### Samsung

The following files could be used to control charging current and voltage (with `applyOnBoot`):
```
battery/batt_tune_fast_charge_current (default: 2100)

battery/batt_tune_input_charge_current (default: 1800)

battery/batt_tune_float_voltage (max: 4350)
```


---
## LINKS

- [ACC app](https://github.com/MatteCarra/AccA/releases/)
- [Battery University](http://batteryuniversity.com/learn/article/how_to_prolong_lithium_based_batteries/)
- [Donate](https://paypal.me/vr25xda/)
- [Facebook page](https://facebook.com/VR25-at-xda-developers-258150974794782/)
- [Git repository](https://github.com/VR-25/acc/)
- [Telegram channel](https://t.me/vr25_xda/)
- [Telegram group](https://t.me/acc_magisk/)
- [Telegram profile](https://t.me/vr25xda/)
- [XDA thread](https://forum.xda-developers.com/apps/magisk/module-magic-charging-switch-cs-v2017-9-t3668427/)



---
## LATEST CHANGES

**2019.6.20 (201906200)**
- Additional charging control files
- Enhanced daemon reliability
- `install-current.sh` no longer requires absolute path
- Updated documentation
- wakeUnlock - auto-unlock select wakelocks after charging is disabled

**2019.6.17 (201906170)**
- Fixed: "automatic" charging switch not working

**2019.6.15 (201906150)**
- Prioritize charging switches that put the battery on idle when charging is paused - allowing the device to draw power directly from the external power supply
- Updated documentation
