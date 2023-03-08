#!/bin/bash

ConfigFirst=0
if [[ $ConfigFirst == 0 ]]; then
    source ./config.sh
    source ./style.sh
    source ./utils.sh
    ConfigFirst=1
fi




# default config
_CONFIRM_DEFAULT_NEGATIVE_TEXT="No"
_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT="Yes"
_CONFIRM_DEFAULT_MESSAGE="Are you sure?"
_CONFIRM_DEFAULT_CHOICE=1
_DEFAULT_CHOOSE_WIDTH=20


# default config
mConfirmNegativeText=$_CONFIRM_DEFAULT_NEGATIVE_TEXT
mConfirmAffirmativeText=$_CONFIRM_DEFAULT_AFFIRMATIVE_TEXT
mConfirmMessage=$_CONFIRM_DEFAULT_MESSAGE
mConfirmChoice=$_CONFIRM_DEFAULT_CHOICE
mConfirmWidth=$_DEFAULT_CHOOSE_WIDTH

# default style
mConfirmStyleDialogBackground=$(Color.getFormatColor)
mConfirmStyleItemSelectColor=$(Color.getFormatColor)
mConfirmStyleItemUnSelectColor="\033[0m"

# show button in choose
function showChoice(){
    echo -e -n "$mConfirmStyleItemSelectColor"
    echo -e -n "\033[4m$1"
    echo -e -n "\033[0m"
}

# show button in no choose
function showChoiceCommon(){
    echo -e -n "$mConfirmStyleItemUnSelectColor$1$ColorReset"
    echo -e -n "\033[0m"
}

function clear(){
    echo -e -n "\r\033[3A"
    tput ed
}

# show choose button
function showChoiceButton(){
    local negativeLen=${#mConfirmNegativeText}
    local affirmativeLen=${#mConfirmAffirmativeText}
    # move to left and cacluate index of negative
    echo -e -n "\r"
    local index=$((mConfirmWidth/4 - negativeLen/2)) 
    echo -e -n "\033[${index}C"
    # check choose
    if [ $mConfirmChoice -eq 0 ]; then
        showChoice "$mConfirmNegativeText"
    else
        showChoiceCommon "$mConfirmNegativeText"
    fi
    
    # move to left and cacluate index of affirmative
    echo -e -n "\r"
    local index=$((mConfirmWidth/2 + mConfirmWidth/4 - affirmativeLen/2))
    echo -e -n "\033[${index}C"

    # check choose
    if [ $mConfirmChoice -eq 1 ]; then
        showChoice "$mConfirmAffirmativeText"
    else
        showChoiceCommon "$mConfirmAffirmativeText"
    fi
}

# check user input
function checkInput() {
    while true; do
        key=$(KeyBoard.input)
        # run command
        case "$key" in
            $KeyBoard_LEFT)
                if [ $mConfirmChoice -eq 1 ]; then
                    mConfirmChoice=0
                    showChoiceButton
                fi
                ;;
            $KeyBoard_RIGHT)
                if [ $mConfirmChoice -eq 0 ]; then
                    mConfirmChoice=1
                    showChoiceButton
                fi
                ;;
            $KeyBoard_ENTER)
                clear
                echo -e -n "\033[0m"
                Utils.writeTemp "$mConfirmChoice"
                Utils.showCursor
                break
                ;;
        esac

    done
}



function mConfirmshow() {
    # show dialog 
    Utils.hideCursor
    local colorReverse=$mConfirmStyleDialogBackground
    local colorReset="\033[0m"
    local emptyLine=$(printf "%${mConfirmWidth}s" "")
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"
    echo -e "$colorReverse$(printf "$emptyLine" "")$colorReset"

    local messageLen=${#mConfirmMessage}

    # move to base line
    echo -e -n "\033[4A"
    local index=$((mConfirmWidth/2 - messageLen/2)) 
    echo -e -n "\033[${index}C"
    echo "$mConfirmMessage"

    echo -e -n "\033[1B"

    showChoiceButton

}

function Confirm.run() {
    mConfirmshow
    checkInput
}

# show helps
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

# show helps
function Confirm.help(){
    echo "biu confirm [options]"
    echo "options:"
    echo "  -h, --help"
    echo "  -v, --version"
    echo "  --negative <text>"
    echo "  --affirmative <text>"
    echo "  --message <text>"
    echo "  --default <number>"
    echo ""
    exit 1
}

function Confirm.helpParamsColor(){
    if [[ $1 == "" ]]; then
        echo "you not set color"
    else
        echo "you set color[$1] is not support"
    fi
    
    echo "support color is in:"
    for key in ${!Colors[*]}; do
        local color=${Colors[$key]}
        echo -e "    $key: \033[${color}m$key\033[0m"
    done
    Confirm.help
}

function Confirm.setParma(){
    if [[ $1 != "" ]]; then
        mConfirmMessage=$1
    fi
}


# check params
function Confirm.checkPmarm(){
    # echo "Confirm.checkPmarm"
    ARGS=$(getopt -q -a -o vh -l version,help,affirmative::,negative::,default::,select-color::,un-select-color::, -- "$@")
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
        --select-color)
            local color=$2
            if [[ $color == "" ]]; then
                Confirm.helpParamsColor ""
            fi 
            if [[ ${Colors[$color]} == "" ]]; then
                Confirm.helpParamsColor $2
            fi
            mConfirmStyleItemSelectColor=$(Color.getColorFormat $color)
            shift
            ;;
        --un-select-color)
            local color=$2
            if [[ $color == "" ]]; then
                Confirm.helpParamsColor ""
            fi 
            if [[ ${Colors[$color]} == "" ]]; then
                Confirm.helpParamsColor $2
            fi
            mConfirmStyleItemUnSelectColor=$(Color.getColorFormat $color)
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
