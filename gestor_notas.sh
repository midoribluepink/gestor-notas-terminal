#!/bin/bash

# Códigos de colores para la salida de la terminal.
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Función para parar el programa con Ctrl+C.
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Función que despliega el panel de ayuda del programa.
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso${endColour}"
  echo -e "\t${purpleColour}c)${endColour} ${grayColour}Crear una nueva nota${endColour}"
  echo -e "\t${purpleColour}l)${endColour} ${grayColour}Listar las notas existentes${endColour}"
  echo -e "\t${purpleColour}b)${endColour} ${grayColour}Buscar en las notas una coincidencia${endColour}"
  echo -e "\t${purpleColour}d)${endColour} ${grayColour}Eliminar una nota${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar el panel de ayuda${endColour}\n"
}

# Creación del menú de parámetros que se le pueden pasar al programa.
declare -i parameter=0 #Parametro de opción que cambiará según la opción elegida.

while getopts "c:lb:d:h" arg; do #Capturamos las opciones colocadas en el programa desde la terminal
  case $arg in #Los parámetros c y h no recibe argumentos. Los parámetros c,d y b sí reciben un argumento.
    c) noteName="$OPTARG"; let parameter+=1;;
    l) let parameter+=2;;
    b) searchName="$OPTARG"; let parameter+=3;;
    d) noteName="$OPTARG"; let parameter+=4;;
    h) ;;
  esac
done


# Función de creación de la nota en el sistema
function noteCreation(){
  tput civis
  noteName="$1"
  noteName_checker="$(ls | grep $noteName)" #Comprobamos si existe la nota.
  if [ "$noteName_checker" ]; then #Si existe avisamos al usuario.
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Esta nota ya existe, elige un nuevo nombre${endColour}\n"
  else # Si no existe, creamos una nueva nota y la inicizalizamos con nvim.
    touch "$noteName".txt
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se ha creado la nota${endColour} ${blueColour}$noteName.txt${endColour}\n"
    echo -e "#Nombre de la nota: $noteName\n" > "$noteName".txt
    sleep 2
    nvim "$noteName".txt
  fi
  tput cnorm 
}

# Función para listar las notas existentes
function showNotes(){
  #Lista todas las notas existentes en formato columna, elimina el texto ".txt" y las colorea.
  ls $(pwd) | grep -v "gestor_notas.sh" | tr -d '.txt' | column | awk '{sub($0, "\033[1;34m&\033[0m")}1'
}

# Función para eliminar notas
function deleteNotes(){
  noteName="$1"
  noteName_checker="$(ls | grep $noteName)" #Comprobamos si la nota existe
  if [ "$noteName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Seguro que quiere eliminar la nota${endColour} ${blueColour}$noteName${endColour} ${grayColour}y/n:${endColour}" #Pedimos confirmación para eliminar la nota
    read answer #Leemos la respuesta del usuario
    if [ "$answer" == "y" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se eliminará${endColour} ${blueColour}$noteName${endColour}"
      rm "$noteName".txt #Se elimina la nota
      sleep 1
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Su nota se ha eliminado${endColour}"
    else
      echo -e "\n${redColour}[!] No se eliminó${endColour}"
    fi
  else
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}No existe la nota${endColour} ${redColour}$noteName${endColour}"
  fi
}

# Condicional que permite al programa saber qué parametro ha sido colocado en el programa y lanza la función correspondiente.
if [ $parameter -eq 1 ];then
  noteCreation $noteName
elif [ $parameter -eq 2 ]; then
  showNotes
elif [ $parameter -eq 3 ]; then
  echo "Función -b"
elif [ $parameter -eq 4 ]; then
  deleteNotes $noteName
else
  helpPanel
fi
