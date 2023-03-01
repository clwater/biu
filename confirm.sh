#!/bin/bash

ConfigFirst=0
if [[ $ConfigFirst == 0 ]]; then
    source ./config.sh
    source ./style.sh
    ConfigFirst=1
fi

_CONFIRM_DEFAULT_NEGATIVE_TEXT="No"
_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT="Yes"
_CONFIRM_DEFAULT_MESSAGE="Are you sure?"
_CONFIRM_DEFAULT_CHOICE=1

_DEFAULT_CHOOSE_WIDTH=30

mConfirmNegativeText=$_CONFIRM_DEFAULT_NEGATIVE_TEXT
mConfirmAffirmativeText=$_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT
mConfirmMessage=$_CONFIRM_DEFAULT_MESSAGE
mConfirmChoice=$_CONFIRM_DEFAULT_CHOICE
mConfirmWidth=$_DEFAULT_CHOOSE_WIDTH

# function center(){
# }



function show() {
    local colorReverse=$(Color.getBackgroundReverse)
    local colorReset="\033[0m"
    local emptyLine=$(printf "%${mConfirmWidth}s" "")
    printf "%b\n" "$colorReverse$(printf "$emptyLine" "")$colorReset"
    printf "%b\n" "$colorReverse$(printf "$emptyLine" "")$colorReset"
    printf "%b\n" "$colorReverse$(printf "$emptyLine" "")$colorReset"
    printf "%b\n" "$colorReverse$(printf "$emptyLine" "")$colorReset"
    printf "%b\n" "$colorReverse$(printf "$emptyLine" "")$colorReset"

    tput sc
    # get mConfirmMessage length
    local messageLen=${#mConfirmMessage}
    local negativeLen=${#mConfirmNegativeText}
    local affirmativeLen=${#mConfirmAffirmativeText}
    
    tput cuu 4          
    # move to center
    tput cuf $((mConfirmWidth/2 - messageLen/2)) 
    echo "$mConfirmMessage"

    tput rc

    tput cuu 2
    tput sc

    tput cuf $((mConfirmWidth/4 - negativeLen/2))
    echo -n "$mConfirmNegativeText"

    # move to line start
    tput  rc
    tput cuf $((mConfirmWidth/2 + affirmativeLen/2))
    
    echo "$mConfirmAffirmativeText"

}

function Confirm.run() {
    show
}


function Confirm.helpParams(){
    if [ $# -gt 1 ]; then
        local _params="$@"
        local _param_len=${#1}
        ((_param_len++))
        _params=${_params:$_param_len}
        _params=${_params// /, }
        echo "biu confirm $1 param need in [$_params]"
    else
        echo "biu confirm $1 need a param"
    fi
    echo ""
    Choose.help
    exit 1
}

function Confirm.help(){
    echo "Confirm.help"
}



function Confirm.checkPmarm(){
    echo "Confirm.checkPmarm"


    ARGS=$(getopt -q -a -o vh -l version,help,affirmative::,negative::,default::,message:: -- "$@")
    [ $? -ne 0 ] && Confirm.help && exit 1
    eval set -- "${ARGS}"
    while true; do
        case "$1" in
        -h | --help)
            Confirm.help
            exit 1
            ;;
        -v | --version)
            Config.version
            exit 1
            ;;
        --negative)
            mConfirmNegativeText=$2
            if [[ $mConfirmNegativeText == "" ]]; then
                Confirm.helpParams "--negative"
            fi
            shift
            ;;
        --affirmative)
            mConfirmAffirmativeText=$2
            if [[ $mConfirmAffirmativeText == "" ]]; then
                Confirm.helpParams "--height"
            fi
            shift
            ;;
        --message)
            mConfirmMessage=$2
            if [[ $mConfirmMessage == "" ]]; then
                Confirm.helpParams "--message"
            fi
            shift
            ;;
        --default)
            mConfirmChoice=$2
            if [[ $mConfirmChoice == "" ]]; then
                Confirm.helpParams "--default" "0: negative" "1: affirmative"
            fi
            if [[ $mConfirmChoice != 0 && $mConfirmChoice != 1 ]]; then
                Confirm.helpParams "--default" "0: negative" "1: affirmative"
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
