#!/bin/bash


test=(0 1 2 3 4 5 6 7 8 9 )

# run choose
function Spin.run() {
    echo "Spin run"
    local index=0
    while true; do
        echo ${test[$index]}
        index=$((index+1))
        sleep 0.1
    done
}

function Spin.help(){
    echo "help"
}

function Spin.checkPmarm(){
    echo "checkPmarm"
}