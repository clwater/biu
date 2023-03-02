#!/bin/bash

source ./choose.sh
source ./config.sh
source ./style.sh
source ./confirm.sh


# # get Biu type
optFirst=$1

Config.checkFirstParams $1

mCheckFirstParams=$?

if [[ $mCheckFirstParams == 1 ]]; then
    # check biu params 

    # use getopt to parse args
    # -q: disable getopt's own error message
    # -a: Make long options can use - or --
    # -o: short options  
    # -l: long options
    # --: other to show help.

    ARGS=$(getopt -q -a -o vh -l version,help -- "$@")
    [ $? -ne 0 ] && Config.help && exit 1
    eval set -- "${ARGS}"
    while true; do
        case "$1" in
        -h | --help)
            Config.help
            exit 1
            ;;
        -v | --version)
            Config.version
            exit 1
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
fi

if [[ $mCheckFirstParams == 2 ]]; then
    case "$1" in
        $ChooseKey)
            Choose.checkPmarm $@
            ;;
        $InputKey)
            Input.checkPmarm $@
            ;;
        $StyleKey)
            Style.checkPmarm $@
            ;;
        $ConfirmKey)
            Confirm.checkPmarm $@
            ;;
    esac
fi




# # check params can be used 
# checkBiuParams=$(Config.checkBiuParams $1)
# if [[ $checkBiuParams != 0 ]]; then
#     Config.help
#     exit
# fi




# get Biu params
params=()

# Is check Biu type?
mJumpBiuParams=0

# add Biu params
for i in "$@"; do
    if [[ $mJumpBiuParams == 0 ]]; then
        mJumpBiuParams=1
        continue
    fi
    params[${#params[@]}]=$i
done


# run Biu.Choose
function Biu.Choose(){
    for i in "${params[@]}"; do
        if [[ $i != -* ]]; then
            Choose.setParma "$i"
        fi
    done
    Choose.run > /dev/tty 
    Utils.readTemp
}

# run Biu.Input
function Biu.Input(){
    Input.run > /dev/tty
}


# run Biu.Style
function Biu.Style(){
    Style.run
}

# run Biu.confirm
function Biu.confirm(){
    for i in "${params[@]}"; do
        if [[ $i != -* ]]; then
            Confirm.setParma "$i"
        fi
    done
    Confirm.run  > /dev/tty
    Utils.readTemp
}


# run command
case "$optFirst" in
    $ChooseKey)
        Biu.Choose
        ;;
    $InputKey)
        Biu.Input
        ;;
    $StyleKey)
        Biu.Style
        ;;
    $ConfirmKey)
        Biu.confirm
        ;;
esac