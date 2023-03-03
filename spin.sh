#!/bin/bash

# use example from https://github.com/charmbracelet/bubbles/blob/master/spinner/spinner.go

function showMoon(){
    local spin=(🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘)
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

function ShowDot(){
    local spin=(⣾ ⣽  ⣻  ⢿  ⡿  ⣟  ⣯  ⣷)
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

# run choose
function Spin.run() {
    echo "Spin run"
    showMoon
}

function Spin.help(){
    echo "help"
}

function Spin.checkPmarm(){
    echo "checkPmarm"
}