#/!bin/bash

StyleFirst=0
if [[ $StyleFirst == 0 ]]; then
    source ./config.sh
    StyleFirst=1
fi


Color_Background="default"
Color_Foreground="sky"

declare -A Colors

Colors["default"]="0"
Colors["black"]="30"
Colors["red"]="31"
Colors["green"]="2"
Colors["yellow"]="33"
Colors["blue"]="34"
Colors["purple"]="35"
Colors["sky"]="36"
Colors["white"]="37"



function Color.setBackground() {
    Color_Background=$1
}

function Color.setForeground() {
    Color_Foreground=$1
}

function Color.getBackground() {
    echo "${Colors[$Color_Background]}"
}

function Color.getForeground() {
    echo "${Colors[$Color_Foreground]}"
}




# run choose
function Style.run() {
    echo "run run"
}

function Style.help(){
    echo "help"
    exit
}

function resetStyle(){
    rm style.config 
    cp style.config.default style.config
    # todo load config from style.config
}

function Style.helpParamsColor(){
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
    Style.help
}

function Style.helpParams(){
    if [ $# -gt 1 ]; then
        local _params="$@"
        local _param_len=${#1}
        ((_param_len++))
        _params=${_params:$_param_len}
        _params=${_params// /, }
        echo "biu style $1 param need in [$_params]"
    else
        echo "biu style $1 need a param"
    fi
    echo ""
    Style.help
    exit 1
}



function Style.checkPmarm(){
    ARGS=$(getopt -q -a -o vh -l version,help,background::,foreground::,save:,reset -- "$@")
    [ $? -ne 0 ] && Style.help && exit 1
    eval set -- "${ARGS}"
    while true; do
        case "$1" in
        -h | --help)
            Style.help
            exit 1
            ;;
        -v | --version)
            Config.version
            exit 1
            ;;
        --background)
            local backgroundColor=$2
            if [[ $backgroundColor == "" ]]; then
                Style.helpParamsColor ""
            fi 
            if [[ ${Colors[$backgroundColor]} == "" ]]; then
                Style.helpParamsColor $2
            fi
            Color_Background=$backgroundColor
            shift
            ;;
        --foreground)
            local foregroundColor=$2
            if [[ $foregroundColor == "" ]]; then
                Style.helpParamsColor ""
            fi 
            if [[ ${Colors[$foregroundColor]} == "" ]]; then
                Style.helpParamsColor $2
            fi
            Color_Foreground=$foregroundColor
            shift
            ;;
        --reset)
            resetStyle
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
}

