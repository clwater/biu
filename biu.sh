#!/bin/bash

source ./choose.sh

# coding in choose

Choose.setParma "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111" 
Choose.setParma "2" 
Choose.setParma "3 4"  
Choose.setParma "5\"6" 
Choose.setParma "7 \" 8" 

Choose.run > /dev/tty 


echo $(Utils.readTemp)