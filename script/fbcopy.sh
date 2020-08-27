Skip to content
Search or jump to…

Pull requests
问题
广场
探索
 
@sasoncheung 
sasoncheung
/
fclone_shell_bot
forked from cgkings/fcs
0
0236
Code
拉取请求
Actions
Projects
Wiki
安全
Insights
设置
fclone_shell_bot
/
script
/
fbcopy.sh
 

1
#!/bin/bash
2
#=============================================================
3
# https://github.com/cgkings/fcs
4
# File Name: fbtask.sh
5
# Author: cgking
6
# Created Time : 2020.7.8
7
# Description:全盘备份-task
8
# System Required: Debian/Ubuntu
9
# Version: final
10
#=============================================================
11
​
12
source /root/fcs/myfc_config.ini
13
​
14
clear
15
echo -e " 选择你需要备份的盘
16
[1]. 1#盘
17
[2]. 2#盘
19
[4]. 退出"
20
read -p "请输入数字 [1-5]:" num
21
case "$num" in
22
1)
23
    echo -e "★★★ 1#盘 ★★★"
24
    myid="$one_id"
25
    ;;
26
2)
27
    echo -e "★★★ 2#盘 ★★★"
28
    myid="$two_id"
29
    ;;
30
3)
31
    echo -e "★★★ 3#盘 ★★★"
32
    myid="$three_id"
33
    ;;
34
4)
35
    exit
36
    ;;
37
*)
38
    echo -e "请输入正确的数字"
39
    exit
40
    ;;
41
esac
42
read -p "请输入备份到盘ID==>" link
43
if [ -z "$link" ] ; then
44
echo "不允许输入为空" && exit
45
else
@sasoncheung
Commit changes
Commit summary
Update fbcopy.sh
Optional extended description
Add an optional extended description…
 Commit directly to the master branch.
 Create a new branch for this commit and start a pull request. Learn more about pull requests.
 
© 2020 GitHub, Inc.
条款
隐私
安全
状态
帮助
Contact GitHub
定价
API
培训
博客
关于
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
[3]. BOOK盘
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
