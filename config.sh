#! /bin/bash

source ./choose.sh

# show version info
function config.version() {
    echo "version 0.0.1"
}

# show help info
function config.help() {
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

declare -A ConfigParams
ConfigParams[$ChooseKey]=1

function config.checkBiuParams() {
    if [ "${ConfigParams[$1]}" ] ; then
        echo 0
    else
        echo 1
    fi
}
