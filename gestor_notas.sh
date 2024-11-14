#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Creación del menú de opciones
declare -i parameter=0 #Parametro de opción

while getopts "clb:d:h" arg; do
  case $arg in
    c) let parameter+=1;;
    l) let parameter+=2;;
    b) searchName="$OPTARG"; let parameter+=3;;
    d) searchID="$OPTARG"; let parameter+=4;;
    h) ;;
  esac
done

if [ $parameter -eq 1 ];then
  echo "Función -c"
elif [ $parameter -eq 2 ]; then
  echo "Función -l"
elif [ $parameter -eq 3 ]; then
  echo "Función -b"
elif [ $parameter -eq 4 ]; then
  echo "Función -d"
else
  echo "Panel de ayuda"
fi
