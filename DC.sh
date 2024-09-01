#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
MODPATH="/data/adb/modules/AA+™"
[[ ! -e ${MODDIR}/ll/log ]] && mkdir -p ${MODDIR}/ll/log
source "${MODPATH}/scripts/GK.sh"
# 设定温度阈值
MAX_TEMP=420  # 42度，单位是十分之一摄氏度
MIN_TEMP=400  # 40度，单位是十分之一摄氏度

# 无限循环，定期检查电池温度
while true; do
    # 获取电池温度
    temp=$(dumpsys battery | grep "temperature" | awk '{print $2}')
    
    # 检查电池是否在充电
    is_charging=$(dumpsys battery | grep "status" | awk '{print $2}')
    
    # 如果电池温度超过42度且正在充电，则停止充电
    if [ "$temp" -ge "$MAX_TEMP" ] && [ "$is_charging" -eq 2 ]; then
        echo "电池温度过高（$temp/10°C）停止充电."
        su root -c dumpsys battery set ac 0
		su root -c XXX  亮屏快冲关
    elif [ "$temp" -lt "$MIN_TEMP" ] && [ "$is_charging" -eq 1 ]; then
        # 如果电池温度低于40度且不在充电，则开始充电
        echo "电池温度过低（$temp/10°C）开始充电."
		su root -c XXX  亮屏快冲开
        su root -c dumpsys battery set ac 1
    else
        echo "电池温度在安全范围内 ($temp/10°C)."
    fi
    
    # 等待一段时间后再次检查
    sleep 60
done

