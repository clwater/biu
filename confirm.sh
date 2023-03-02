#!/bin/bash

ConfigFirst=0
if [[ $ConfigFirst == 0 ]]; then
    source ./config.sh
    source ./style.sh
    source ./utils.sh
    ConfigFirst=1
fi

_CONFIRM_DEFAULT_NEGATIVE_TEXT="No"
_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT="Yes"
_CONFIRM_DEFAULT_MESSAGE="Are you sure?"
_CONFIRM_DEFAULT_CHOICE=1

_DEFAULT_CHOOSE_WIDTH=20

mConfirmNegativeText=$_CONFIRM_DEFAULT_NEGATIVE_TEXT
mConfirmAffirmativeText=$_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT
mConfirmMessage=$_CONFIRM_DEFAULT_MESSAGE
mConfirmChoice=$_CONFIRM_DEFAULT_CHOICE
mConfirmWidth=$_DEFAULT_CHOOSE_WIDTH



# function checkInput() {
#     while true; do
#         key=$(KeyBoard.input)
#         # run command
#         case "$key" in
#             $KeyBoard_LEFT)
#                 ((mChooseIndex-=$chooseParamsHeight))
#                 if [ $mChooseIndex -lt 0 ]; then
#                     mChooseIndex=0
#                 fi
#                 ;;
#             $KeyBoard_RIGHT)
#                 ((mChooseIndex+=$chooseParamsHeight))
#                 if [ $mChooseIndex -gt $mChooseMaxIndex ]; then
#                     mChooseIndex=$mChooseMaxIndex
#                 fi
#                 ;;
#             $KeyBoard_ENTER)
#                 if [[ $chooseParamsLimit == 1 || $chooseParamsStrict == $ConfigOff ]]; then
#                     returnChooseItem
#                     break
#                 else
#                     if [ $chooseItemCount -lt $chooseParamsLimit ]; then
#                         if [[ $chooseParamsErrorInfo == $ConfigOn ]]; then
#                             showError 2
#                         fi
#                     else 
#                         returnChooseItem
#                         break
#                     fi
#                 fi
#                 ;;
#         esac

#         if [[ $mChooseIndex -lt 0 ]]; then
#             mChooseIndex=$mChooseMaxIndex
#         fi

#         if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
#             mChooseIndex=0
#         fi

#         showChoose
#     done
# }

function showChoice(){
    local colorReset="\033[0m"
    local color=$(Color.getFormatColor)
    echo -e -n "$color$1$ColorReset"
}

function showChoiceCommon(){
    echo -e -n "$colorReset$1$ColorReset"
}

function show() {
    local colorReverse=$(Color.getBackgroundReverse)
    local colorReset="\033[0m"
    local emptyLine=$(printf "%${mConfirmWidth}s" "")
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"

    # Utils.hideCursor
    # get mConfirmMessage length
    local messageLen=${#mConfirmMessage}
    local negativeLen=${#mConfirmNegativeText}
    local affirmativeLen=${#mConfirmAffirmativeText}


    echo -e -n "\033[4A"
    local index=$((mConfirmWidth/2 - messageLen/2)) 
    echo -e -n "\033[${index}C"
    echo "$mConfirmMessage"

    echo -e -n "\033[1B"

    local index=$((mConfirmWidth/4 - negativeLen/2)) 
    echo -e -n "\033[${index}C"
    echo -n "$mConfirmNegativeText"
    echo -e -n "\r"

    local index=$((mConfirmWidth/2 + mConfirmWidth/4 - affirmativeLen/2))
    echo -e -n "\033[${index}C"
    
    showChoice "$mConfirmAffirmativeText"
    # echo "$mConfirmAffirmativeText"

    Utils.showCursor

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
    # echo "Confirm.checkPmarm"


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
