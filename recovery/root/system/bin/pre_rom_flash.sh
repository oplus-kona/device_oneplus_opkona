#!/system/bin/sh

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
    echo "I:$@" >> /tmp/recovery.log
}

UI_PRINT() {
    echo "ui_print [High-Speed Flash] $*" >> /tmp/recovery.log
    echo "ui_print [High-Speed Flash] $*" > /proc/self/fd/2 2>/dev/null || true
    echo "ui_print [High-Speed Flash] $*" > /proc/self/fd/1 2>/dev/null || true
}

LOGMSG "---$SCRIPT_NAME start---"
date +%s > /tmp/flash_start_time 2>/dev/null
UI_PRINT "Starting..."

LOGMSG "Resetting SPL date to prevent anti-rollback protection..."
resetprop ro.build.version.security_patch 2023-12-31

# LOGMSG "Formatting /metadata..."
# make_f2fs /dev/block/bootdevice/by-name/metadata

D="/metadata/ota"

mount /metadata 2>/dev/null

LOGMSG "Checking for stale OTA metadata which may block ROM install..."
if [ -d "$D" ]; then
    LOGMSG "Wiping $D..."
    rm -rf "$D" 2>/dev/null
fi

LOGMSG "Detecting active boot slot..."
slot="$(getprop ro.boot.slot_suffix)"
if [ -z "$slot" ]; then
    LOGMSG "Unable to detect active boot slot; skipping recovery backup..."
else
    LOGMSG "Active boot slot: $slot"

    LOGMSG "Backing up OrangeFox recovery before ROM overwrites..."
    if [ -e /dev/block/bootdevice/by-name/recovery${slot} ]; then
        if dd if="/dev/block/bootdevice/by-name/recovery${slot}" of="/tmp/fox_backup.img" bs=1M; then
            sync
            LOGMSG "Backup of OrangeFox recovery was successful"
        else
            LOGMSG "Failed to backup OrangeFox recovery..."
        fi
    else
        LOGMSG "Recovery partition not found; skipping backup..."
    fi
fi

# Automatic High-Speed Sideload staging
if [ "$1" != "--no-recurse" ] && [ -f /sideload/package.zip ]; then
    LOGMSG "Detected active ADB sideload package (/sideload/package.zip)..."
    if [ -x /system/bin/highspeed_sideload.sh ]; then
        /system/bin/highspeed_sideload.sh --stage-fuse
        exit $?
    fi
fi

LOGMSG "---$SCRIPT_NAME end---"
