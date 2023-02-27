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
_DEFAULT_CHOOSE_SELECT_PREFIX="◉ "
_DEFAULT_CHOOSE_UNSELECT_PREFIX="○ "


# todo limit show height
_DEFAULT_CHOOSE_SHOW_HEIGHT=10
_DEFAULT_CHOOSE_LIMIT=1
_DEFAULT_CHOOSE_STRICT=$ConfigOff
_DEFAULT_CHOOSE_ERROR_INFO=$ConfigOn

chooseParamsSelect="$_DEFAULT_CHOOSE_CURSOR"
chooseParamsUnSelect=""
chooseParamsCursorLen=0

chooseParamsSelectPrefix="$_DEFAULT_CHOOSE_SELECT_PREFIX"
chooseParamsUnSelectPrefix="$_DEFAULT_CHOOSE_UNSELECT_PREFIX"

chooseParamsShowHeight=$_DEFAULT_CHOOSE_SHOW_HEIGHT
chooseParamsLimit=$_DEFAULT_CHOOSE_LIMIT


chooseParamsStrict=$_DEFAULT_CHOOSE_STRICT
chooseParamsErrorInfo=$_DEFAULT_CHOOSE_ERROR_INFO

chooseItemCount=0

declare -A chooseUseSelect
# chooseUseSelect
# 0: use unSelect
# 1: use select

# Choose

mError=""

# show choose Error info
# 1: choose too many
# 2: choose too less
function showError() {
    if [ $1 == 1 ]; then
        mError="\033[31mYou have select $chooseItemCount item, You can not then more.\033[0m"
    elif [ $1 == 2 ]; then
        mError="\033[31mYou only then $chooseItemCount item, You need select more until $chooseParamsLimit.\033[0m"
    fi
}

# show choose Error info in next loop
function showErrorInLoop() {
    if [[ $mError != "" ]]; then
        echo -e "$mError"
    fi
    mError=""
}


# show choose list
# todo item color
function showChoose() {
    tput rc
    tput ed

    local colorSTC="\033[0m"
    local colorSTS="\033[36m"
    local colorReset="\033[0m"


    for ((i = 0; i < ${#mChooseList[@]}; i++)); do

        # echo item is [un]current + [[un]select] + item 

        local item="${mChooseList[i]}"

        if [[ $mChooseIndex == $i || ${chooseUseSelect[$i]} == 1 ]]; then
            item="$colorSTS"
        else
            item="$colorSTC"
        fi

        if [ $mChooseIndex == $i ]; then
            item="$item$chooseParamsSelect"
        else
            item="$item$chooseParamsUnSelect"
        fi

        if [ $chooseParamsLimit != 1 ]; then
            if [ ${chooseUseSelect[$i]} == 1 ]; then
                item="$item$chooseParamsSelectPrefix"
            else
                item="$item$chooseParamsUnSelectPrefix"
            fi
        fi

        item="$item${mChooseList[i]}$colorReset"

        echo -e "$item"
    done

    showErrorInLoop
    
}

# retun choose item(s)
function returnChooseItem(){
    tput rc
    tput ed
    # if limit is 1, return only one item
    if [ $chooseParamsLimit == 1 ]; then
        Utils.writeTemp "${mChooseList[$mChooseIndex]}"
    else
    # if limit is not 1, return all item
    # but if use select none, return current item
        local useChoose=0
        for ((i = 0; i < ${#mChooseList[@]}; i++)); do

            if [ ${chooseUseSelect[$i]} == 1 ]; then
                useChoose=1
                Utils.writeTemp "${mChooseList[$i]}"
            fi

        done

        if [ $useChoose == 0 ]; then
            Utils.writeTemp "${mChooseList[$mChooseIndex]}"
        fi
    fi

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
                # check limit not only 1 
                if [ $chooseParamsLimit != 1 ]; then
                    if [ ${chooseUseSelect[$mChooseIndex]} == 0 ] ; then
                        if [ $chooseItemCount -ge $chooseParamsLimit ]; then
                            if [ $chooseParamsErrorInfo == $ConfigOn ]; then
                                showError 1
                            fi
                        else
                            ((chooseItemCount++))
                            chooseUseSelect[$mChooseIndex]=1
                        fi
                    else
                        ((chooseItemCount--))
                        if [ $chooseItemCount -lt 0 ]; then
                            chooseItemCount=0
                        fi
                        chooseUseSelect[$mChooseIndex]=0
                    fi
                fi
                ;;
            $Input_ENTER)
                if [[ $chooseParamsLimit == 1 || $chooseParamsStrict == $ConfigOff ]]; then
                    returnChooseItem
                    break
                else
                    if [ $chooseItemCount -lt $chooseParamsLimit ]; then
                        if [ $chooseParamsErrorInfo == $ConfigOn ]; then
                            showError 2
                        fi
                    else 
                        returnChooseItem
                        break
                    fi
                fi
                ;;
        esac

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
    if [ $# -gt 1 ]; then
        local _params="$@"
        local _param_len=${#1}
        ((_param_len++))
        _params=${_params:$_param_len}
        _params=${_params// /, }
        echo "biu choose $1 param need in [$_params]"
    else
        echo "biu choose $1 need a param"
    fi
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
    echo "   --cursor        Set cursor, default is >"
    echo "   --limit         Set limit, default is 1"
    echo "   --select-prefix Set select prefix, default is ◉ "
    echo "   --un-select-prefix Set un-select prefix, default is ○ "
    echo "   --strict        Set strict, default is on"
    echo "   --error-info    Set error info, default is on"
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

    ARGS=$(getopt -q -a -o vh -l version,help,cursor:,limit:,select-prefix:,un-select-prefix:,strict:,error-info: -- "$@")
    [ $? -ne 0 ] && Config.help && exit 1
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
        --limit)
            chooseParamsLimit=$2
            if [[ $chooseParamsLimit == "" ]]; then
                Choose.helpParams "--limit"
            fi
            shift
            ;;
        --select-prefix)
            chooseParamsSelectPrefix=$2
            if [[ $chooseParamsSelectPrefix == "" ]]; then
                Choose.helpParams "--select-prefix"
            fi
            shift
            ;;
        --un-select-prefix)
            chooseParamsUnSelectPrefix=$2
            if [[ $chooseParamsUnSelectPrefix == "" ]]; then
                Choose.helpParams "--un-select-prefix"
            fi
            shift
            ;;
        --strict)
            chooseParamsStrict=$2
            if [[ $chooseParamsStrict == "" ]]; then
                Choose.helpParams "--strict" $ConfigOn $ConfigOff
            fi
            if [[ $chooseParamsStrict != $ConfigOn && $chooseParamsStrict != $ConfigOff ]]; then
                Choose.helpParams "--strict" $ConfigOn $ConfigOff
            fi
            shift
            ;;
        --error-info)
            chooseParamsErrorInfo=$2
            if [[ $chooseParamsErrorInfo == "" ]]; then
                Choose.helpParams "--error-info" $ConfigOn $ConfigOff
            fi
            if [[ $chooseParamsErrorInfo != $ConfigOn && $chooseParamsErrorInfo != $ConfigOff ]]; then
                Choose.helpParams "--error-info" $ConfigOn $ConfigOff
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