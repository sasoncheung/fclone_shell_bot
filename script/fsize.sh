#!/bin/bash
#=============================================================
# https://github.com/cgkings/fcs
# File Name: fqcopy_a.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:极速版-多任务版
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fcs/myfc_config.ini

clear
read -p "【极速任务队列模式】请输入分享链接任务，任务序号【01】==>" link
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
rootname=$(fclone lsd "$fclone_name":{$link} --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
if [ -z "$link" ] ; then
echo "不允许输入为空" && exit ;
elif [ -z "$rootname" ] ; then
echo -e "读取文件夹名称出错，请反馈问题给作者,如果是全盘请用fb,此模式读不了盘名!\n"
break
else
echo -e "$link" >>/root/fcs/log/fqtask.txt
fi
suma=1
while [ $link!=[0] ];do
    suma=$((suma+1))
    echo -e "队列任务模式,任务序号【$suma】"
    read -p "请继续输入分享链接任务，如需终止添加队列则回复"0"==>" link
    link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
    rootname=$(fclone lsd "$fclone_name":{$link} --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
    if [ x"$link" == x"0" ];then
    echo -e "总共添加了【$suma】项任务,队列任务即将执行"
    break
    elif [ -z "$link" ];then
    echo -e "不允许输入为空"
    echo -e "再给你一次机会"
    continue
    elif [ -z "$rootname" ] ; then
    echo -e "读取文件夹名称出错,如果是全盘请用fb,此模式读不了盘名!\n"
    echo -e "再给你一次机会"
    continue
    else
    echo -e "$link" >> /root/fcs/log/fqtask.txt
    fi
done
clear
if [ -s /root/fcs/log/fqtask.txt ] ; then
IFS=$'\n'
sumb=0
sumh=$(grep -n '' /root/fcs/log/fqtask.txt | awk -F : 'END{print $1}')
for input_id in $(cat ~/fcs/log/fqtask.txt)
do
sumb=$(sumb+1)
rootname=$(fclone lsd "$fclone_name":{$input_id} --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
echo -e "▣▣▣▣▣▣▣任务信息▣▣▣▣▣▣▣\n" 
echo -e "┋资源名称┋:"$rootname"\n"
echo -e "┋资源地址┋:"$input_id"\n"
echo -e "┋任务信息┋:第"$sumb"项/共"$sumh"项\n"
echo -e "▣▣▣▣▣▣执行转存▣▣▣▣▣▣"
fclone copy "$fclone_name":{$input_id} "$fclone_name":{$gd_id}/"$rootname" --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fq_chercker" --transfers="$fq_transfer" --drive-pacer-min-sleep="$fq_min_sleep"ms --drive-pacer-burst="$fq_BURST" --min-size "$fq_min_size"M --check-first --log-level=ERROR --log-file=/root/fcs/log/fqcopy1.log
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  拷贝完毕"
echo -e "▣▣▣▣▣▣查漏补缺▣▣▣▣▣▣"
fclone copy "$fclone_name":{$input_id} "$fclone_name":{$gd_id}/"$rootname" --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fq_chercker" --transfers="$fq_transfer" --drive-pacer-min-sleep="$fq_min_sleep"ms --drive-pacer-burst="$fq_BURST" --min-size "$fq_min_size"M --check-first --log-level=ERROR --log-file=/root/fcs/log/fqcopy2.log
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  补缺完毕"
done
: > /root/fcs/log/fqtask.txt
exit
else
echo "/root/fcs/log/fqtask.txt为空，即将退出" && exit ; 
fi
#!/bin/bash
#=============================================================
# https://github.com/cgkings/fcs
# File Name: fsize.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:size查询
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fcs/myfc_config.ini

#三种模式，在myfc_config.ini中选择size_mode
#其中：1#，ls基础模式，2#，ls列表模式，3#，size基础模式,3#size列表模式
read -p "请输入查询链接==>" link
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
rootname=$(fclone lsd "$fclone_name3":{$link} --disable listR --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
if [ -z "$link" ] ; then
echo "不允许输入为空" && exit ;
fi
#1号，ls基础模式
size_mode_num_simple() {
    file_num=$(fclone ls "$fclone_name3":{$link} --disable listR --checkers="$fs_chercker" | wc -l)
    folder_num=$(fclone lsd "$fclone_name3":{$link} --disable listR -R --checkers="$fs_chercker" | wc -l)
    echo -e "▣▣▣▣▣▣▣▣查询信息▣▣▣▣▣▣▣▣\n" 
    echo -e "┋ name  ┋:$rootname \n"
    echo -e "┋ file  ┋:$file_num \n"
    echo -e "┋ folder┋:$folder_num \n"
    echo -e "┋ total ┋:$[file_num+folder_num] \n"
}
#2号，ls列表模式
size_mode_num() {
    file_num0=$(fclone ls "$fclone_name3":{$link} --disable listR --checkers="$fs_chercker" | wc -l)
    file_num1=$(fclone ls "$fclone_name3":{$link} --include "*.{avi,mpeg,wmv,mp4,mkv,rm,rmvb,3gp,mov,flv,vob}" --ignore-case --disable listR --checkers="$fs_chercker" | wc -l)
    file_num2=$(fclone ls "$fclone_name3":{$link} --include "*.{png,jpg,jpeg,gif,webp,tif}" --ignore-case --disable listR --checkers="$fs_chercker" | wc -l)
    file_num3=$(fclone ls "$fclone_name3":{$link} --include "*.{html,htm,txt,pdf,nfo}" --ignore-case --disable listR --checkers="$fs_chercker" | wc -l)
    echo -e "资源名称："$rootname""
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 类型 文件数量
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 视频 "$file_num1"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 图片 "$file_num2"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 文本 "$file_num3"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 合计 "$file_num0"
    echo -e "--------------"
}
#3号，size基础模式
size_mode_simple() {
    size_info=`fclone size "$fclone_name3":{$link} --disable listR --checkers="$fs_chercker"`
    file_num=$(echo "$size_info" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size=$(echo "$size_info" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    echo -e "▣▣▣▣▣▣▣▣查询信息▣▣▣▣▣▣▣▣\n" 
    echo -e "┋资源名称┋:$rootname \n"
    echo -e "┋资源数量┋:$file_num \n"
    echo -e "┋资源大小┋:$file_size \n"
}
#4号，size列表模式
size_mode_fully() {
    size_info0=`fclone size "$fclone_name3":{$link} --disable listR --checkers="$fs_chercker"`
    file_num0=$(echo "$size_info0" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size0=$(echo "$size_info0" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info1=`fclone size "$fclone_name3":{$link} --include "*.{avi,mpeg,wmv,mp4,mkv,rm,rmvb,3gp,mov,flv,vob}" --ignore-case --disable listR --checkers="$fs_chercker"`
    file_num1=$(echo "$size_info1" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size1=$(echo "$size_info1" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info2=`fclone size "$fclone_name3":{$link} --include "*.{png,jpg,jpeg,gif,webp,tif}" --ignore-case --disable listR --checkers="$fs_chercker"`
    file_num2=$(echo "$size_info2" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size2=$(echo "$size_info2" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info3=`fclone size "$fclone_name3":{$link} --include "*.{html,htm,txt,pdf,nfo}" --ignore-case --disable listR --checkers="$fs_chercker"`
    file_num3=$(echo "$size_info3" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size3=$(echo "$size_info3" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    echo -e "资源名称："$rootname""
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 类型 文件数量 文件大小
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 视频 "$file_num1" "$file_size1"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 图片 "$file_num2" "$file_size2"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 文本 "$file_num3" "$file_size3"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 合计 "$file_num0" "$file_size0"
    echo -e "----------------------------------"
}
echo -e " 选择模式
[1]. ls基础模式
[2]. ls列表模式
[3]. size基础模式
[4]. size列表模式"
read -p "请输入数字 [1-4]:" num
case "$num" in
1)
    echo -e "你的选择，ls基础模式"
    size_mode_num_simple
    exit
    ;;
2)
    echo -e "你的选择，ls列表模式"
    size_mode_num
    exit
    ;;
3)
    echo -e "你的选择，size基础模式"
    size_mode_simple
    exit
    ;;
4)
    echo -e "你的选择，size列表模式"
    size_mode_fully
    exit
    ;;
*)
    echo -e "请输入正确的数字"
    exit
    ;;
esac
