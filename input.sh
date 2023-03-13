#!/bin/bash

InputFirst=0

if [[ $InputFirst == 0 ]]; then
    source ./keyBoard.sh
    source ./config.sh
    source ./utils.sh
    InputFirst=1
fi


function showHeader() {
    echo -e -n "\e[2mHeader: \033[0m"
}

function showInput() {
    echo -n "[placeholder]"

}

currentIndex=0
currentInput=""
function showInputText(){
    echo -e -n "\033[u"
    echo -e -n "\033[K"
    echo -e -n "\033[5m" 
    echo -e -n "\033[0m"
    stText=${currentInput: 0 :$currentIndex}
    endText=${currentInput: $currentIndex}
    echo -n "$stText"
    echo -e -n "\033[5m" 
    echo -n "|"
    echo -e -n "\033[0m"
    echo -n "$endText"
    # echo -n "$currentInput"
}

function returnInput(){
    Utils.writeTemp $currentInput
}

function inputAddkey(){
    case "$1" in
        $KeyBoard_LEFT)
            ((currentIndex--))
            if [ $currentIndex -lt 0 ]; then
                currentIndex=0
            fi
            ;;
        $KeyBoard_RIGHT)
            ((currentIndex++))
            if [ $currentIndex -gt ${#currentInput} ]; then
                currentIndex=${#currentInput}
            fi
            ;;
        $KeyBoard_ENTER)
            returnInput
            ;;
        **)
            # ((currentIndex++))
            # currentInput="$currentInput$1"
            stText=${currentInput: 0 :$currentIndex}
            endText=${currentInput: $currentIndex}
            currentInput="$stText$1$endText"
            ((currentIndex++))
            ;;
    esac
    showInputText
}

function showShell() {
    showHeader
    Utils.hideCursor
    echo -e -n "\033[s"
    while true; do
        key=$(KeyBoard.input)
        inputAddkey $key
    done
}

# run input
function Input.run() {
    showShell
}

function Input.checkPmarm() {
    echo "checkPmarm"
}
