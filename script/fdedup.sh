#!/bin/bash
#=============================================================
# https://github.com/cgkings/fcs
# File Name: fdedup.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:定向查重
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fcs/myfc_config.ini
: > /root/fcs/log/fdedupe.log
clear
read -p "请输入要查重的链接==>" link
if [ -z "$link" ] ; then
    echo "不允许输入为空" && exit
else
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
fi
echo -e "▣▣▣▣▣▣正在执行查重▣▣▣▣▣▣"
fclone dedupe smallest "$fclone_nameb":{$link2} --fast-list --drive-use-trash=false --no-traverse --checkers="$fs_chercker" --transfers="$fs_transfer" -p --log-level=ERROR --log-file=/root/fcs/log/fdedupe.log --check-first
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  查重完毕"
