#!/bin/bash

source ./utils.sh

ChooseKey="choose"

# List of params(actual)
mChooseList=()
# List of params(show, split with screen width)
mChooseShowList=()
# Choose index
mChooseIndex=0
# Choose max index
mChooseMaxIndex=0


_DEFAULT_CHOOSE_Select="> "

chooseParamsSelect="$_DEFAULT_CHOOSE_Select"
chooseParamsUnSelect=""
chooseParamsCursorLen=0

# Choose

# show choose list
# todo item color
function showChoose() {
    tput rc
    tput ed
    for ((i = 0; i < ${#mChooseShowList[@]}; i++)); do
        if [[ $mChooseIndex == $i ]]; then
            echo -e "\033[36m$chooseParamsSelect${mChooseShowList[i]}\033[0m"
        else
            echo -e "\033[37m$chooseParamsUnSelect${mChooseShowList[i]}\033[0m"
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

function Choose.init(){
    ((mChooseMaxIndex--))
    chooseParamsCursorLen=${#chooseParamsSelect}
    chooseParamsUnSelect=`printf "%-${chooseParamsCursorLen}s" ""`
}


# run choose
function Choose.run() {
    Choose.init
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

function Choose.helpParams(){
    echo "biu choose $1 need a param"
    echo ""
    Choose.help
    exit 1
}


function Choose.help(){
    echo "Usage: biu.exe choose [options] [params]"
    echo ""
    echo "Choose an option from a list of choices"
    echo ""
    echo "Flags: "
    echo "    -h, --help      Show help information"
    echo "    -v, --version   Show version information"
    echo ""
    echo "Examples: "
    echo "    biu.exe choose 1 2 3 4 5"
    echo "    biu.exe choose -h"
    echo "    biu.exe choose -v"
    echo ""
    echo "Run \"biu.exe choose --help\" for more information about a command."
    exit 1
}





function Choose.checkPmarm(){
    # echo "Choose.checkPmarm: $*"

    # check biu.choose params 

    # use getopt to parse args
    # -q: disable getopt's own error message
    # -a: Make long options can use - or --
    # -o: short options  
    # -l: long options
    # --: other to show help.

    ARGS=$(getopt -q -a -o vh -l version,help,cursor: -- "$@")
    # [ $? -ne 0 ] && Config.help && exit 1
    eval set -- "${ARGS}"
    while true; do
        case "$1" in
        -h | --help)
            Choose.help
            exit 1
            ;;
        -v | --version)
            Config.version
            exit 1
            ;;
        --cursor)
            chooseParamsSelect=$2
            if [[ $chooseParamsSelect == "" ]]; then
                Choose.helpParams "--cursor"
            fi
            shift
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
}