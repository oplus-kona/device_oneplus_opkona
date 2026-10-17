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

if [ -s /tmp/fox_backup.img ]; then
	UI_PRINT "Restoring recovery..."
	for slot in _a _b; do
		if [ -e /dev/block/bootdevice/by-name/recovery${slot} ]; then
			LOGMSG "Restoring OrangeFox to slot ${slot}..."
			if dd if="/tmp/fox_backup.img" of="/dev/block/bootdevice/by-name/recovery${slot}" bs=1M; then
				sync
			else
				LOGMSG "Failed to flash to slot ${slot}..."
			fi
		else
	        LOGMSG "Recovery partition not found for slot ${slot}, skipping restore..."
		fi
	done
else
	LOGMSG "Unable to find OrangeFox image for restoring..."
fi

# Clean up any staged sideload buffers
if [ -d /tmp/sideload_ram ]; then
	LOGMSG "Unmounting and clearing RAM sideload stage..."
	umount -l /tmp/sideload_ram 2>/dev/null
	rm -rf /tmp/sideload_ram 2>/dev/null
fi
if [ -d /data/sideload_stage ]; then
	LOGMSG "Clearing UFS disk sideload stage..."
	rm -rf /data/sideload_stage 2>/dev/null
fi

# LOGMSG "Clearing previous DFE installation logs..."
# rm -rf /sdcard/neo_file_*

# LOGMSG "Setting instructions for next reboot..."
# echo "install /FFiles/DFE.zip" > /cache/recovery/openrecoveryscript

# Calculate and display total elapsed time
if [ -f /tmp/flash_start_time ]; then
	start_time="$(cat /tmp/flash_start_time 2>/dev/null)"
	rm -f /tmp/flash_start_time 2>/dev/null
	if [ -n "$start_time" ] && [ "$start_time" -gt 0 ] 2>/dev/null; then
		elapsed=$(( $(date +%s) - start_time ))
		[ "$elapsed" -lt 1 ] && elapsed=1
		UI_PRINT "Done in ${elapsed}s."
	else
		UI_PRINT "Done."
	fi
else
	UI_PRINT "Done."
fi

LOGMSG "---$SCRIPT_NAME end---"
# mkdir -p /persist/Fox/logs
# cp /tmp/recovery.log "/persist/Fox/logs/dfe_recovery_$(date +"%Y%m%d_%H%M%S").log"

# reboot recovery
