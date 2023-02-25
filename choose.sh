#!/bin/bash

source ./utils.sh
source ./input.sh

ChooseKey="choose"

# List of params(actual)
mChooseList=()
# List of params(show, split with screen width)
mChooseShowList=()
# Choose index
mChooseIndex=0
# Choose max index
mChooseMaxIndex=0


_DEFAULT_CHOOSE_CURSOR="> "
# ○ ◉
_DEFAULT_CHOOSE_CURSOR_PREFIX="AAAA"
_DEFAULT_CHOOSE_SELECT_PREFIX="BBBB"
_DEFAULT_CHOOSE_UNSELECT_PREFIX="CCCC"


# todo limit show height
_DEFAULT_CHOOSE_SHOW_HEIGHT=10
_DEFAULT_CHOOSE_LIMIT=2

chooseParamsSelect="$_DEFAULT_CHOOSE_CURSOR"
chooseParamsUnSelect=""
chooseParamsCursorLen=0

chooseParamsCursorPrefix="$_DEFAULT_CHOOSE_CURSOR_PREFIX"
chooseParamsSelectPrefix="$_DEFAULT_CHOOSE_SELECT_PREFIX"
chooseParamsUnSelectPrefix="$_DEFAULT_CHOOSE_UNSELECT_PREFIX"

chooseParamsShowHeight=$_DEFAULT_CHOOSE_SHOW_HEIGHT
chooseParamsLimit=$_DEFAULT_CHOOSE_LIMIT


declare -A chooseUseSelect
# chooseUseSelect
# 0: use unSelect
# 1: use select

# Choose

# show choose list
# todo item color
function showChoose() {
    tput rc
    tput ed

    local colorSTC="\033[0m"
    local colorSTS="\033[36m"
    local colorET="\033[0m"

    local showInfo="$colorST$colorET"

    for ((i = 0; i < ${#mChooseList[@]}; i++)); do

        # echo "$i ${chooseUseSelect[$i]}"
        # echo "${chooseUseSelect[$i]}"

        if [ $chooseParamsLimit == 1 ] ; then
            if [[ $mChooseIndex == $i ]]; then
                echo -e "$colorSTS$chooseParamsSelect${mChooseList[i]}$colorET"
            else
                echo -e "$colorSTC$chooseParamsUnSelect${mChooseList[i]}$colorET"
            fi
        else
            if [ "${chooseUseSelect[$i]}" ] ; then
                if [[ $mChooseIndex == $i ]]; then
                    echo -e "$colorSTS$chooseParamsSelect$chooseParamsSelectPrefix${mChooseList[i]}$colorET"
                else
                    echo -e "$colorSTS$chooseParamsUnSelect$chooseParamsSelectPrefix${mChooseList[i]}$colorET"
                fi
            else
                if [[ $mChooseIndex == $i ]]; then
                    echo -e "$colorSTS$chooseParamsSelect$chooseParamsCursorPrefix${mChooseList[i]}$colorET"
                else
                    echo -e "$colorSTS$chooseParamsUnSelect$chooseParamsUnSelectPrefix${mChooseList[i]}$colorET"
                fi
            fi
        fi



        # if [[ $mChooseIndex == $i ]]; then
        #     echo -e "\033[36m$chooseParamsSelect${mChooseShowList[i]}\033[0m"
        # else
        #     echo -e "\033[37m$chooseParamsUnSelect${mChooseShowList[i]}\033[0m"
        # fi
        # ((index++))
    done
}

function returnChooseItem(){
    tput rc
    tput ed
    Utils.writeTemp "${mChooseList[$mChooseIndex]}"
}

# check input to change choose index and return choose index
function checkInput() {
    while true; do
        key=$(Input.input)
        # run command
        case "$key" in
            $Input_DOWN)
                ((mChooseIndex++))
                ;;
            $Input_UP)
                ((mChooseIndex--))
                ;;
            $Input_SPACE)
                if [ chooseUseSelect[$mChooseIndex] == 0 ]; then
                    chooseUseSelect[$mChooseIndex]=1
                else
                    chooseUseSelect[$mChooseIndex]=0
                fi
                ;;
            $Input_ENTER)
                returnChooseItem
                break
                ;;
        esac

        # # # read key, check enter
        # read -sn1 -p  "" key

        # if [[ $key = '' ]] ; then
        #     echo "space"
        #     # if [ chooseUseSelect[$mChooseIndex] == 0 ]; then
        #     #     chooseUseSelect[$mChooseIndex]=1
        #     # else
        #     #     chooseUseSelect[$mChooseIndex]=0
        #     # fi
        # fi
        # if [[ $key = '\n' ]] ; then
        #     echo "enter"
        #     # returnChooseItem
        #     # break
        # fi



        # # read key, check up, down
        # # the up or down key is 3 char, so need read 3 char
        # if [[ $key == $'\e' ]]; then
        #     read -sn1 -t 0.01 key
        #     if [[ "$key" == "[" ]]; then
        #         read -sn1 -t 0.01 key
        #         case $key in
        #         A)
        #             ((mChooseIndex--))
        #             indexChange=1
        #             ;;
        #         B)
        #             ((mChooseIndex++))
        #             indexChange=1
        #             ;;
        #         esac
        #     fi
        # fi
        # check index, if index is out of range, set it to max or min
        if [[ $mChooseIndex -lt 0 ]]; then
            mChooseIndex=$mChooseMaxIndex
        fi

        if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
            mChooseIndex=0
        fi

        showChoose
    done
}

# add param to choose list
# $1: param
# Because the param may be contain space, 
# when use $@ to get all params, it will be split by space 
# so need add one by one 
function Choose.setParma(){
    chooseUseSelect[${#mChooseList[@]}]=0

    mChooseList[${#mChooseList[@]}]=$1
    # local _cols=`expr $UtilsCols - $chooseParamsCursorLen`
    # local lineText=$1
    # local splitstr=${lineText: 0: $_cols}
    # mChooseShowList[${#mChooseShowList[@]}]=$splitstr
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