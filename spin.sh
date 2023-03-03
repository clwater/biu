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

# run choose
function Spin.run() {
    echo "Spin run"
    Utils.hideCursor
    showSpin "moon"
}

function Spin.help(){
    echo "help"
}

function Spin.checkPmarm(){
    echo "checkPmarm"
}