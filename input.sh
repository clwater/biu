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
    echo -n "|"
    echo -e -n "\033[0m"
    echo -n "$currentInput"
}

function inputAddkey(){
    case "$1" in
        $KeyBoard_LEFT)
            if [ $currentIndex -gt 0 ]; then
                currentIndex=$((currentIndex-1))
                echo -e -n "\033[1D"
            fi
            ;;
        $KeyBoard_RIGHT)
            if [ $currentIndex -lt ${#currentInput} ]; then
                currentIndex=$((currentIndex+1))
                echo -e -n "\033[1C"
            fi
            ;;
        **)
            currentInput="$currentInput$1"
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
