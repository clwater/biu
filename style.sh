#/!bin/bash

_BIU_STYLE_BACKGROUND="default"
_BIU_STYLE_FOREGROUND="sky"

StyleFirst=0


configFile="style.config"


BiuColorBackground=$_BIU_STYLE_BACKGROUND
BiuColorForeground=$_BIU_STYLE_FOREGROUND


function saveConfig(){
    sed -i "s/$1=.*/$1=$2/g" $configFile

}

function readConfig(){
    local _config=`cat $configFile | grep $1`
    local _config_len=${#1}
    ((_config_len++))
    _config=${_config:$_config_len}
    echo $_config
}

if [[ $StyleFirst == 0 ]]; then
    source ./config.sh
    StyleFirst=1

    BiuColorBackground=$(readConfig BiuColorBackground)
    BiuColorForeground=$(readConfig BiuColorForeground)

fi



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




function setBackground() {
    BiuColorBackground=$1
    saveConfig BiuColorBackground $1
}

function setForeground() {
    BiuColorForeground=$1
    saveConfig BiuColorForeground $1
}

function Color.getBackground() {
    echo "${Colors[$BiuColorBackground]}"
}

function Color.getForeground() {
    echo "${Colors[$BiuColorForeground]}"
}




# run choose
function Style.run() {
    echo "Style run"
}

function Style.help(){
    echo "help"
    exit
}

function resetStyle(){
    setBackground $_BIU_STYLE_BACKGROUND
    setForeground $_BIU_STYLE_FOREGROUND
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
            setBackground $backgroundColor
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
            setForeground $foregroundColor
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

