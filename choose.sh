#!/bin/bash

source ./utils.sh

# List of params(actual)
mChooseList=()
# List of params(show, split with screen width)
mChooseShowList=()
# Choose index
mChooseIndex=0
# Choose max index
mChooseMaxIndex=0

# Choose

# show choose list
# todo item color
function showChoose() {
    tput rc
    tput ed
    for ((i = 0; i < ${#mChooseShowList[@]}; i++)); do
        if [[ $mChooseIndex == $i ]]; then
            echo -e "\033[36m> ${mChooseShowList[i]} \033[0m"
        else
            echo -e "\033[37m  ${mChooseShowList[i]}  \033[0m"
        fi
        ((index++))
    done
}

function returnChooseItem(){
    tput rc
    tput ed
    Utils.writeTemp "${mChooseList[$mChooseIndex]}"
}

# check input to change choose index and return choose index
function checkInput() {
    local indexChange=0
    while true; do

        # read key, check enter
        read -sn1 -p "" key
        if [[ $key = "" ]]; then
            returnChooseItem
            break
        fi
        # read key, check up, down
        # the up or down key is 3 char, so need read 3 char
        if [[ $key == $'\e' ]]; then
            read -sn1 -t 0.01 key
            if [[ "$key" == "[" ]]; then
                read -sn1 -t 0.01 key
                case $key in
                A)
                    ((mChooseIndex--))
                    indexChange=1
                    ;;
                B)
                    ((mChooseIndex++))
                    indexChange=1
                    ;;
                esac
            fi
        fi
        # check index, if index is out of range, set it to max or min
        if [[ $mChooseIndex -lt 0 ]]; then
            mChooseIndex=0
            indexChange=0
        fi

        if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
            mChooseIndex=$mChooseMaxIndex
            indexChange=0
        fi

        # only when index change, show choose list
        if [[ $indexChange == 1 ]]; then
            indexChange=0
            showChoose
        fi
    done
}

# add param to choose list
# $1: param
# Because the param may be contain space, 
# when use $@ to get all params, it will be split by space 
# so need add one by one 
function Choose.setParma(){
    mChooseList[${#mChooseList[@]}]=$1
    local _cols=`expr $UtilsCols - 4`
    local lineText=$1
    local splitstr=${lineText: 0: $_cols}
    mChooseShowList[${#mChooseShowList[@]}]=$splitstr
    ((mChooseMaxIndex++))
}


# run choose
function Choose.run() {
    ((mChooseMaxIndex--))
    # setInputParams
    # set tput info
    tput sc
    tput civis
    # show choose list
    showChoose
    # check input
    checkInput
    # reset tput info
    tput cnorm
}
