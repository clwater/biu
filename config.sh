#! /bin/bash

ChooseKey="choose"
InputKey="input"
StyleKey="style"
ConfirmKey="confirm"

ConfigFirst=0
if [[ $ConfigFirst == 0 ]]; then
    source ./input.sh
    ConfigFirst=1
fi







# show version info
function Config.version() {
    echo "version 0.0.1"
}



# show help info
function Config.help() {
    echo "Usage: biu.exe <command>"
    echo ""
    echo "A tool of Shell."
    echo ""
    echo "Flags: "
    echo "    -h, --help      Show help information"
    echo "    -v, --version   Show version information"
    echo ""
    echo "Commands: "
    echo "    choose          Choose an option from a list of choices"
    echo ""
    echo "Run \"biu.exe <command> --help\" for more information about a command."
    exit 1
}


function Config.helpTypeError() {
    echo "biu: '$1' is not a biu command. See 'biu --help'."
    echo ""
    Config.help
}




badReturn="get"

declare -A ConfigParams
ConfigParams[$ChooseKey]=1
ConfigParams[$InputKey]=1
ConfigParams[$StyleKey]=1
ConfigParams[$ConfirmKey]=1


function Config.checkBiuParams() {
    if [ "${ConfigParams[$1]}" ] ; then
        echo 0
    else
        echo 1
    fi
}


# return 1: bergin with - or --, need check again
# return 2: not begin with - or --, but is usefull params(in ConfigParams)
function Config.checkFirstParams() {
    
    if [ "$1" == "" ]; then
        Config.help
    fi

    if [[ $1 == -* ]]; then
        return 1
    fi

    # check params can be used 
    local checkBiuParams=$(Config.checkBiuParams $1)
    if [[ $checkBiuParams == 0 ]]; then
        return 2
    else
        Config.helpTypeError
    fi


}