#!/system/bin/sh
#
# High-Speed Sideload Flasher for OrangeFox Recovery (OnePlus Kona Family)
#
# Staging Pipeline:
# - RAM: tmpfs (Tier 1) if MemAvailable > package size + 1.2 GB
# - UFS: /data/sideload_stage (Tier 2) fallback
# - Parallel 8-worker otaripper extraction directly from staged local storage
# - Automatic cleanup on completion or error

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
    echo "I:[Hi-Speed Sideload] $*"
    echo "I:[Hi-Speed Sideload] $*" >> /tmp/recovery.log
}

UI_PRINT() {
    echo "ui_print [High-Speed Flash] $*" >> /tmp/recovery.log
    echo "ui_print [High-Speed Flash] $*" > /proc/self/fd/2 2>/dev/null || true
    echo "ui_print [High-Speed Flash] $*" > /proc/self/fd/1 2>/dev/null || true
}

ERRORMSG() {
    echo "E:[Hi-Speed Sideload] $*"
    echo "E:[Hi-Speed Sideload] $*" >> /tmp/recovery.log
    UI_PRINT "Error: $*"
}

RAM_STAGE_DIR="/tmp/sideload_ram"
DISK_STAGE_DIR="/data/sideload_stage"
SAFETY_MARGIN_KB=1258291 # 1.2 GB margin

STAGE_TARGET=""
STAGE_IS_RAM=0

cleanup() {
    [ -f "$STAGE_TARGET" ] && rm -f "$STAGE_TARGET" 2>/dev/null
    if [ -d "$RAM_STAGE_DIR" ]; then
        umount -l "$RAM_STAGE_DIR" 2>/dev/null
        rm -rf "$RAM_STAGE_DIR" 2>/dev/null
    fi
    [ -d "$DISK_STAGE_DIR" ] && rm -rf "$DISK_STAGE_DIR" 2>/dev/null
    sync
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
}

trap cleanup EXIT INT TERM

determine_staging() {
    local req_bytes="$1"
    local req_kb=$(( req_bytes / 1024 ))
    [ "$req_kb" -le 0 ] && req_kb=2621440

    local mem_avail
    mem_avail="$(awk '/MemAvailable/ {print $2}' /proc/meminfo 2>/dev/null)"
    [ -z "$mem_avail" ] && mem_avail=0

    LOGMSG "Size: $((req_kb / 1024))MB | RAM: $((mem_avail / 1024))MB"

    if [ "$mem_avail" -gt "$((req_kb + SAFETY_MARGIN_KB))" ]; then
        UI_PRINT "Staging in RAM..."
        mkdir -p "$RAM_STAGE_DIR"
        local mount_size=$(( (req_kb + 131072) / 1024 + 1 ))M
        mount -t tmpfs -o size="$mount_size" tmpfs "$RAM_STAGE_DIR"
        STAGE_TARGET="$RAM_STAGE_DIR/update.zip"
        STAGE_IS_RAM=1
    else
        UI_PRINT "Staging on UFS..."
        mount /data 2>/dev/null
        mkdir -p "$DISK_STAGE_DIR"
        STAGE_TARGET="$DISK_STAGE_DIR/update.zip"
        STAGE_IS_RAM=0
    fi
}

run_highspeed_flash() {
    local target_pkg="$1"
    local initial_start="$2"

    if [ ! -s "$target_pkg" ]; then
        ERRORMSG "Package missing or empty"
        return 1
    fi

    if [ -x /system/bin/pre_rom_flash.sh ]; then
        /system/bin/pre_rom_flash.sh --no-recurse
    fi

    local start_time end_time elapsed
    if [ -n "$initial_start" ] && [ "$initial_start" -gt 0 ] 2>/dev/null; then
        start_time="$initial_start"
    else
        start_time="$(date +%s)"
    fi

    UI_PRINT "Flashing (8 parallel workers)..."
    if /system/bin/otaripper "$target_pkg"; then
        UI_PRINT "Flash finished."
    else
        ERRORMSG "Flash failed"
        return 1
    fi

    if [ -x /system/bin/post_rom_flash_completion.sh ]; then
        /system/bin/post_rom_flash_completion.sh
    fi

    end_time="$(date +%s)"
    elapsed=$(( end_time - start_time ))
    [ "$elapsed" -lt 1 ] && elapsed=1

    UI_PRINT "Done in ${elapsed}s."
    return 0
}

case "$1" in
    --prepare)
        determine_staging "${2:-0}"
        echo "$STAGE_TARGET"
        trap - EXIT
        exit 0
        ;;
    --flash)
        target="${2:-$STAGE_TARGET}"
        run_highspeed_flash "$target"
        exit $?
        ;;
    --stream)
        determine_staging "${2:-0}"
        cat > "$STAGE_TARGET"
        run_highspeed_flash "$STAGE_TARGET"
        exit $?
        ;;
    --stage-fuse)
        if [ -f /sideload/package.zip ]; then
            local fuse_size overall_start
            overall_start="$(date +%s)"
            fuse_size="$(wc -c < /sideload/package.zip 2>/dev/null)"
            determine_staging "${fuse_size:-0}"
            UI_PRINT "Copying to stage..."
            dd if=/sideload/package.zip of="$STAGE_TARGET" bs=4M status=none
            run_highspeed_flash "$STAGE_TARGET" "$overall_start"
            exit $?
        else
            ERRORMSG "/sideload/package.zip not found"
            exit 1
        fi
        ;;
    *)
        if [ -n "$1" ] && [ -f "$1" ]; then
            run_highspeed_flash "$1"
            exit $?
        else
            echo "Usage: $SCRIPT_NAME [--prepare|--stream|--flash|--stage-fuse|<file>]"
            exit 1
        fi
        ;;
esac
