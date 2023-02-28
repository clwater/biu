#!/bin/bash

KeyBoard_UP="KeyBoard_UP"
KeyBoard_DOWN="KeyBoard_DOWN"
KeyBoard_LEFT="KeyBoard_LEFT"
KeyBoard_RIGHT="KeyBoard_RIGHT"
KeyBoard_SPACE="KeyBoard_SPACE"
KeyBoard_ENTER="KeyBoard_ENTER"

function Input.input(){

    unset K1 K2 K3
    read -s -N1 -p ""
    K1="$REPLY"
    read -s -N2 -t 0.001
    K2="$REPLY"
    read -s -N1 -t 0.001
    K3="$REPLY"
    key="$K1$K2$K3"

    # 将独立的Home键值转换为数字7上的Home键值：
    if [ "$key" = $'\x1b\x4f\x48' ]; then
        key=$'\x1b\x5b\x31\x7e'
        #   引用字符扩展结构。
    fi

    # 将独立的End键值转换为数字1上的End键值：
    if [ "$key" = $'\x1b\x4f\x46' ]; then
        key=$'\x1b\x5b\x34\x7e'
    fi

    case "$key" in
        $'\x1b\x5b\x32\x7e') # 插入
            echo Insert Key
            ;;
        $'\x1b\x5b\x33\x7e') # 删除
            echo Delete Key
            ;;
        $'\x1b\x5b\x31\x7e') # 数字7上的Home键
            echo Home Key
            ;;
        $'\x1b\x5b\x34\x7e') # 数字1上的End键
            echo End Key
            ;;
        $'\x1b\x5b\x35\x7e') # 上翻页
            echo Page_Up
            ;;
        $'\x1b\x5b\x36\x7e') # 下翻页
            echo Page_Down
            ;;
        $'\x1b\x5b\x41') # 上箭头
            echo $KeyBoard_UP
            ;;
        $'\x1b\x5b\x42') # 下箭头
            echo $KeyBoard_DOWN
            ;;
        $'\x1b\x5b\x43') # 右箭头
            echo $KeyBoard_RIGHT
            ;;
        $'\x1b\x5b\x44') # 左箭头
            echo $KeyBoard_LEFT
            ;;
        $'\x09') # 制表符
            echo Tab Key
            ;;
        $'\x0a') # 回车
            echo $KeyBoard_ENTER
            ;;
        $'\x1b') # ESC
            echo Escape Key
            ;;
        $'\x20') # 空格
            echo $KeyBoard_SPACE
            ;;
    esac

}
