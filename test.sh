#!/bin/bash

# function printWithBlink(){
#     echo -n -e "\033[5m"
# }


# for ((i=0;i<10;i++))
# do
#         tput sc; tput civis                     # 记录光标位置,及隐藏光标
#         echo -ne $(date +'%Y-%m-%d %H:%M:%S')   # 显示时间
#         sleep 1
#         tput rc                                 # 恢复光标到记录位置
# done

# tput el; tput cnorm                             # 退出时清理终端,恢复光标显示


# source ./uitls.sh

# # 记录光标位置,及隐藏光标
# tput sc; tput civis 
# # printWithBlink

# index=0


# function showChoose(){
#     if [[ $index == 0 ]]; then
#         echo  -e "\033[36m [x] 1 \033[0m" 
#     else
#         echo  -e "\033[37m [ ] 1 \033[0m" 
#     fi
#     if [[ $index == 1 ]]; then
#         echo  -e "\033[36m [x] 2 \033[0m" 
#     else
#         echo  -e "\033[37m [ ] 2 \033[0m" 
#     fi
#     if [[ $index == 2 ]]; then
#         echo  -e "\033[36m [x] 3 \033[0m" 
#     else
#         echo  -e "\033[37m [ ] 3 \033[0m" 
#     fi
# }


# showChoose


# while true
# do
#     escape_char=$(printf "\u1b")
#     read -rsn1 mode # get 1 character
#     if [[ $mode == $escape_char ]]; then
#         read -rsn2 mode # read 2 more chars
#     fi
#     case $mode in
#         '[A') ((index--)) ;;
#         '[B') ((index++)) ;;
#     esac


#     if [[ $index -lt 0 ]]; then
#         index=0
#     fi

#     if [[ $index -gt 2 ]]; then
#         index=2
#     fi

#     tput rc

#     showChoose

# done



./biu.sh choose 1 2 3 