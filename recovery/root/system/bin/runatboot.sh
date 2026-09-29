# automatically set device props for unified tree shared-hardware models/variants

load_op8()
{
    resetprop "ro.build.product" "OnePlus8"
    resetprop "ro.display.series" "OnePlus 8"
    resetprop "ro.product.device" "OnePlus8"
    resetprop "ro.product.model" "OnePlus 8"
    resetprop "ro.product.name" "OnePlus8"
    resetprop "ro.product.odm.device" "OnePlus8"
    resetprop "ro.product.odm.model" "OnePlus 8"
    resetprop "ro.product.odm.name" "OnePlus8"
    resetprop "ro.product.product.device" "OnePlus8"
    resetprop "ro.product.product.model" "OnePlus 8"
    resetprop "ro.product.product.name" "OnePlus8"
    resetprop "ro.product.system.device" "OnePlus8"
    resetprop "ro.product.system_ext.device" "OnePlus8"
    resetprop "ro.product.system_ext.model" "OnePlus 8"
    resetprop "ro.product.system_ext.name" "OnePlus8"
    resetprop "ro.product.vendor.device" "OnePlus8"
    resetprop "ro.product.vendor.model" "OnePlus 8"
    resetprop "ro.product.vendor.name" "OnePlus8"
    resetprop "ro.product.system.brand" "OnePlus"
    resetprop "ro.product.system.manufacturer" "OnePlus"
    resetprop "ro.product.system.model" "IN2013"
    resetprop "ro.product.system.name" "OnePlus8"
}

load_op8t()
{
    resetprop "ro.build.product" "OnePlus8T"
    resetprop "ro.display.series" "OnePlus 8T"
    resetprop "ro.product.device" "OnePlus8T"
    resetprop "ro.product.model" "OnePlus 8T"
    resetprop "ro.product.name" "OnePlus8T"
    resetprop "ro.product.odm.device" "OnePlus8T"
    resetprop "ro.product.odm.model" "OnePlus 8T"
    resetprop "ro.product.odm.name" "OnePlus8T"
    resetprop "ro.product.product.device" "OnePlus8T"
    resetprop "ro.product.product.model" "OnePlus 8T"
    resetprop "ro.product.product.name" "OnePlus8T"
    resetprop "ro.product.system_ext.device" "OnePlus8T"
    resetprop "ro.product.system_ext.model" "OnePlus 8T"
    resetprop "ro.product.system_ext.name" "OnePlus8T"
    resetprop "ro.product.vendor.device" "OnePlus8T"
    resetprop "ro.product.vendor.model" "OnePlus 8T"
    resetprop "ro.product.vendor.name" "OnePlus8T"
    resetprop "ro.product.system.brand" "OnePlus"
    resetprop "ro.product.system.manufacturer" "OnePlus"
    resetprop "ro.product.system.model" "KB2003"
    resetprop "ro.product.system.name" "OnePlus8T"
}

load_op8pro()
{
    resetprop "ro.build.product" "OnePlus8Pro"
    resetprop "ro.display.series" "OnePlus 8Pro"
    resetprop "ro.product.device" "OnePlus8Pro"
    resetprop "ro.product.model" "OnePlus 8 Pro"
    resetprop "ro.product.name" "OnePlus8Pro_IND"
    resetprop "ro.product.odm.device" "OnePlus8Pro"
    resetprop "ro.product.odm.model" "OnePlus 8Pro"
    resetprop "ro.product.odm.name" "OnePlus8Pro_IND"
    resetprop "ro.product.product.device" "OnePlus8Pro"
    resetprop "ro.product.product.model" "OnePlus 8Pro"
    resetprop "ro.product.product.name" "OnePlus8Pro_IND"
    resetprop "ro.product.system.device" "OnePlus8Pro"
    resetprop "ro.product.system_ext.device" "OnePlus8Pro"
    resetprop "ro.product.system_ext.model" "OnePlus 8Pro"
    resetprop "ro.product.system_ext.name" "OnePlus8Pro_IND"
    resetprop "ro.product.vendor.device" "OnePlus8Pro"
    resetprop "ro.product.vendor.model" "OnePlus 8Pro"
    resetprop "ro.product.vendor.name" "OnePlus8Pro_IND"
    resetprop "ro.product.system.brand" "OnePlus"
    resetprop "ro.product.system.manufacturer" "OnePlus"
    resetprop "ro.product.system.model" "IN2025"
    resetprop "ro.product.system.name" "OnePlus8Pro"
}

load_op9r()
{
    resetprop "ro.build.product" "OnePlus9R"
    resetprop "ro.display.series" "OnePlus 9R"
    resetprop "ro.product.device" "OnePlus9R"
    resetprop "ro.product.model" "OnePlus 9R"
    resetprop "ro.product.name" "OnePlus9R_IND"
    resetprop "ro.product.odm.device" "OnePlus9R"
    resetprop "ro.product.odm.model" "OnePlus 9R"
    resetprop "ro.product.odm.name" "OnePlus9R_IND"
    resetprop "ro.product.product.device" "OnePlus9R"
    resetprop "ro.product.product.model" "OnePlus 9R"
    resetprop "ro.product.product.name" "OnePlus9R_IND"
    resetprop "ro.product.system.device" "OnePlus9R"
    resetprop "ro.product.system_ext.device" "OnePlus9R"
    resetprop "ro.product.system_ext.model" "OnePlus 9R"
    resetprop "ro.product.system_ext.name" "OnePlus9R_IND"
    resetprop "ro.product.vendor.device" "OnePlus9R"
    resetprop "ro.product.vendor.model" "OnePlus 9R"
    resetprop "ro.product.vendor.name" "OnePlus9R_IND"
    resetprop "ro.product.system.brand" "OnePlus"
    resetprop "ro.product.system.manufacturer" "OnePlus"
    resetprop "ro.product.system.model" "LE2101"
    resetprop "ro.product.system.name" "OnePlus9R"
}

project=$(getprop ro.boot.prj_version)
project11=$(getprop ro.boot.project_name)
echo "Setting device props for device with $project..." >> /tmp/recovery.log
echo $project11

case $project in
    20828)
     load_op9r
     ;;
    20838)
     load_op9r
     ;;
    19821)
     load_op8
     ;;
    19855)
     load_op8
     ;;
    19867)
     load_op8
     ;;
    19811)
     load_op8pro
     ;;
    19805)
     load_op8t
     ;;
    20809)
     load_op8t
     ;;
esac

case $project11 in
    20828)
     load_op9r
     ;;
    20838)
     load_op9r
     ;;
    19821)
     load_op8
     ;;
    19855)
     load_op8
     ;;
    19867)
     load_op8
     ;;
    19811)
     load_op8pro
     ;;
    19805)
     load_op8t
     ;;
    20809)
     load_op8t
     ;;
esac

optimize_io_and_cpu() {
    echo "I:Applying I/O optimizations to block devices..." >> /tmp/recovery.log

    # Optimize all physical UFS partitions (sda, sdb, sdc, sdd, sde, sdf)
    for disk in /sys/block/sd*; do
        if [ -d "$disk/queue" ]; then
            dev=$(basename "$disk")
            # 1. Direct I/O dispatch
            if grep -q "none" "$disk/queue/scheduler" 2>/dev/null; then
                echo none > "$disk/queue/scheduler" 2>/dev/null
            fi

            # 2. Increase read-ahead buffer to 2048 KB
            echo 2048 > "$disk/queue/read_ahead_kb" 2>/dev/null

            # 3. Increase block request backlog depth
            echo 512 > "$disk/queue/nr_requests" 2>/dev/null

            # 4. Disable I/O accounting statistics to reduce CPU kernel overhead
            echo 0 > "$disk/queue/iostats" 2>/dev/null

            # 5. Disable rotational delay penalty
            echo 0 > "$disk/queue/rotational" 2>/dev/null

            # 6. Disable add_random overhead
            echo 0 > "$disk/queue/add_random" 2>/dev/null

            echo "I:Optimized physical device: $dev" >> /tmp/recovery.log
        fi
    done

    # Optimize dynamic partition mapper and loop devices (dm-*, loop*)
    for dev in /sys/block/dm-* /sys/block/loop*; do
        if [ -d "$dev/queue" ]; then
            echo 2048 > "$dev/queue/read_ahead_kb" 2>/dev/null
            echo 512 > "$dev/queue/nr_requests" 2>/dev/null
            echo 0 > "$dev/queue/iostats" 2>/dev/null
        fi
    done

    echo "I:Setting CPU scaling governors..." >> /tmp/recovery.log
    for gov in /sys/devices/system/cpu/cpufreq/policy*/scaling_governor; do
        echo performance > "$gov" 2>/dev/null || echo schedutil > "$gov" 2>/dev/null || echo walt > "$gov" 2>/dev/null
    done

    echo "I:I/O and CPU optimization complete." >> /tmp/recovery.log
}

optimize_io_and_cpu

exit 0
