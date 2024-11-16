#!/bin/bash

#Versión para notas en markdown: archivos.md

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
  noteName_checker="$(ls | grep -i "$noteName")" #Comprobamos si existe la nota.
  if [ "$noteName_checker" ]; then #Si existe avisamos al usuario.
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Esta nota ya existe, elige un nuevo nombre${endColour}\n"
  else # Si no existe, creamos una nueva nota y la inicizalizamos con nvim.
    touch "$noteName".md
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se ha creado la nota${endColour} ${blueColour}$noteName.txt${endColour}\n"
    echo -e "#Nombre de la nota: $noteName\n" > "$noteName".md
    sleep 2
    vim "$noteName".md
  fi
  tput cnorm 
}

# Función para listar las notas existentes
function showNotes(){
  #Lista todas las notas existentes en formato columna, elimina el texto ".txt" y las colorea.
  ls | grep -v "gestor_notas.sh" | sed 's/.md//' | awk '{sub($0, "\033[1;34m&\033[0m")}1' | sort | column
}

# Función para eliminar notas
function deleteNotes(){
  noteName="$1"
  noteName_checker="$(ls | grep "$noteName")" #Comprobamos si la nota existe
  if [ "$noteName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Seguro que quiere eliminar la nota${endColour} ${blueColour}$noteName${endColour} ${grayColour}y/n:${endColour}" #Pedimos confirmación para eliminar la nota
    read answer #Leemos la respuesta del usuario
    if [ "$answer" == "y" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se eliminará${endColour} ${blueColour}$noteName${endColour}"
      rm "$noteName".md #Se elimina la nota
      sleep 1
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Su nota se ha eliminado${endColour}"
    else
      echo -e "\n${redColour}[!] No se eliminó${endColour}"
    fi
  else
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}No existe la nota${endColour} ${redColour}$noteName${endColour}"
  fi
}

# Función para búsqueda entre notas
function noteSearch(){
  searchName="$1"

  file_checker="$(ls | grep -i "$searchName" | grep -v "gestor_notas")" #Comprobamos si hay notas con el nombre indicado
  declare -i archive_parameter=0 #Parámetro que nos dice si hay coincidencias en algún archivo

  if [ "$file_checker" ]; then #Si hay notas con el parámetro indicado dentro del título se muestran
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Las siguientes notas tienen el parámetro de búsqueda en su título:${endColour}\n"
    ls | grep -i "$searchName" | grep -v "gestor_notas" | sed 's/.md//' | sort |column | awk '{sub($0, "\033[1;35m&\033[0m")}1'
  else
    echo -e "\n${yellowColour}[+]${endColour} ${redColour}No hay ninguna nota con ese parámetro en su título${endColour}"
  fi

  for archivo in "$(pwd)"/*md; do #Buscamos en todos los archivos txt del directorio actual
    directory_checker=$(file "$archivo" | grep "directory") #Comprobamos que no sea un directorio, si lo es pasamos al siguiente
    if [ "$directory_checker" ]; then
      continue
    fi

    archiveName="$(echo basename "$archivo" | grep -o '[^/]*$' | sed 's/.md//')" #Extraemos el nombre del archivo
    content_checker="$(cat "$archivo" | grep -i -F "$searchName")" #Comprobamos si hay coincidencias dentro del archivo
    if [ "$content_checker" ]; then #Si hay coincidencias se muestran
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La nota${endColour} ${greenColour}"$archiveName"${endColour} ${grayColour}tiene la siguientes coincidencias:${endColour}"
      cat "$archivo" | grep --color=always -i -F "$searchName"
      let archive_parameter+=1
    fi
  done
  if [ $archive_parameter -eq 0 ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${redColour}No se han encontrado coincidencias en ningún archivo :(${endColour}"
  fi
}

# Condicional que permite al programa saber qué parametro ha sido colocado en el programa y lanza la función correspondiente.
if [ $parameter -eq 1 ];then
  noteCreation "$noteName"
elif [ $parameter -eq 2 ]; then
  showNotes
elif [ $parameter -eq 3 ]; then
  noteSearch "$searchName"
elif [ $parameter -eq 4 ]; then
  deleteNotes "$noteName"
else
  helpPanel
fi
