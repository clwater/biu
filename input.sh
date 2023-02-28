#!/bin/bash

InputFirst=0

if [[ $InputFirst == 0 ]]; then
    source ./keyBoard.sh
    InputFirst=1
fi


function showHeader() {
    echo -e "\e[2mHeader\033[0m"
}

function showInput() {
    echo -n "[placeholder]"

}

function showShell() {
    showHeader
    while true; do
        key=$(KeyBoard.input)
        echo -n $key
    done
}

# run input
function Input.run() {
    showShell
}

function Input.checkPmarm() {
    echo "checkPmarm"
}
