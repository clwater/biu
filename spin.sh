#!/bin/bash

# use example from https://github.com/charmbracelet/bubbles/blob/master/spinner/spinner.go


declare -A Spins

Spins["moon"]="🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘"
Spins["dot"]="⣾ ⣽  ⣻  ⢿  ⡿  ⣟  ⣯  ⣷"
Spins["line"]="| / - \\"
Spins["mini"]="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏"
Spins["jump"]="⢄ ⢂ ⢁ ⡁ ⡈ ⡐ ⡠"
Spins["pluse"]="█ ▓ ▒ ░"
Spins["points"]="∙∙∙ ●∙∙ ∙●∙ ∙∙●"
Spins["glove"]="🌍 🌎 🌏"
Spins["monkey"]="🙈 🙉 🙊"
Spins["meter"]="▱▱▱ ▰▱▱ ▰▰▱ ▰▰▰ ▰▰▱ ▰▱▱ ▱▱▱"
Spins["hamburger"]="☱ ☲ ☴ ☲"


function showSpin(){
    echo "showSpin"
    local spin=(`echo ${Spins[$1]}`)  
    local spinNum=${#spin[@]}
    local sleepTime=$(awk "BEGIN{print 1/$spinNum}")
    local index=0

    
    while true; do
        echo -n ${spin[$index]}
        index=$((index+1))
        echo -e "\r\c"
        if [ $index -eq $spinNum ]; then
            index=0
        fi
        sleep $sleepTime
    done
}

function show(){
    showSpin "moon"
}

# run choose
function Spin.run() {
    echo "Spin run"
    Utils.hideCursor
    show
}

function Spin.help(){
    echo "help"
}

function Spin.checkPmarm(){
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