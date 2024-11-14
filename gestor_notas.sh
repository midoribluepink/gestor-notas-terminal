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

#Función para parar el programa con Ctrl+C
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso${endColour}"
  echo -e "\t${purpleColour}c)${endColour} ${grayColour}Crear una nueva nota${endColour}"
  echo -e "\t${purpleColour}l)${endColour} ${grayColour}Listar las notas existentes${endColour}"
  echo -e "\t${purpleColour}b)${endColour} ${grayColour}Buscar en las notas una coincidencia${endColour}"
  echo -e "\t${purpleColour}d)${endColour} ${grayColour}Eliminar una nota${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar el panel de ayuda${endColour}\n"
}

# Creación del menú de opciones
declare -i parameter=0 #Parametro de opción

while getopts "c:lb:d:h" arg; do
  case $arg in
    c) noteName="$OPTARG"; let parameter+=1;;
    l) let parameter+=2;;
    b) searchName="$OPTARG"; let parameter+=3;;
    d) searchID="$OPTARG"; let parameter+=4;;
    h) ;;
  esac
done

function note_creation(){
  tput civis
  noteName="$1"
  noteName_checker="$(ls | grep $noteName)"
  if [ "$noteName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Esta nota ya existe, elige un nuevo nombre${endColour}\n"
  else
    touch "$noteName".txt
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se ha creado la nota${endColour} ${blueColour}$noteName.txt${endColour}\n"
    echo -e "#Nombre de la nota: $noteName\n" > "$noteName".txt
    sleep 2
    nvim "$noteName".txt
  fi
  tput cnorm 
}

if [ $parameter -eq 1 ];then
  note_creation $noteName
elif [ $parameter -eq 2 ]; then
  echo "Función -l"
elif [ $parameter -eq 3 ]; then
  echo "Función -b"
elif [ $parameter -eq 4 ]; then
  echo "Función -d"
else
  helpPanel
fi
