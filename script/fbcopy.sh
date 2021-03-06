#!/bin/bash
#=============================================================
# https://github.com/cgkings/fcs
# File Name: fbtask.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:全盘备份-task
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fcs/myfc_config.ini

clear
echo -e " 选择你需要备份的盘
[1]. 1#盘
[2]. 2#盘
[3]. 3#盘
[4]. 退出"
read -p "请输入数字 [1-5]:" num
case "$num" in
1)
    echo -e "★★★ 1#盘 ★★★"
    myid="$one_id"
    ;;
2)
    echo -e "★★★ 2#盘 ★★★"
    myid="$two_id"
    ;;
3)
    echo -e "★★★ 3#盘 ★★★"
    myid="$three_id"
    ;;
4)
    exit
    ;;
*)
    echo -e "请输入正确的数字"
    exit
    ;;
esac
read -p "请输入备份到盘ID==>" link
if [ -z "$link" ] ; then
echo "不允许输入为空" && exit
else
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
fi
echo -e "▣▣▣▣▣▣执行备份▣▣▣▣▣▣"
fclone copy "$fclone_name":{$myid} "$fclone_name":{$link} --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fb_chercker" --transfers="$fb_transfer" --drive-pacer-min-sleep="$fb_min_sleep"ms --drive-pacer-burst="$fb_BURST" --min-size "$fb_min_size"M --check-first --ignore-existing --log-level=ERROR --log-file=/root/fcs/log/fbcopy.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  备份完毕"
echo -e "▣▣▣▣▣▣执行同步▣▣▣▣▣▣"
fclone sync "$fclone_name":{$myid} "$fclone_name":{$link} --drive-server-side-across-configs --drive-use-trash=false --stats=1s --stats-one-line -P --checkers="$fb_chercker" --transfers="$fb_transfer" --drive-pacer-min-sleep="$fb_min_sleep"ms --drive-pacer-burst="$fb_BURST" --min-size "$fb_min_size"M --check-first --log-level=ERROR --log-file=/root/fcs/log/fbsync.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  同步完毕"
exit
