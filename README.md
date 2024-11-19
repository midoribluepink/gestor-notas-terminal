# Gestor de notas escrito en bash

El propósito de este programa es ayudarte a gestionar tus notas. Simplemente coloca el programa en el directorio donde tengas tus notas y úsalo como mejor te convenga.

## Uso

### Función de listar notas

Con el comando

```bash
./gestor-notas.sh -l
```
podemos listar las notas existentes en el directorio actual. La versión para notas *.txt* eliminará la extensión automáticamente para que los títulos sean más legibles.

### Función de creación de notas

El comando

```bash
./gestor_notas.sh -c "title"
```
creará una nota automáticamente con el nombre indicado más la extensión *.txt*; además, dentro de la nota colocará el título en la prmera línea y la abrirá de forma automática con Vim.

### Función de eliminación de notas

Para eliminar notas usamos el comando

```bash
./gestor_notas.sh -d "title"
```
El programa pedirá una confirmación y procederá a eliminar la nota indicada.

Finalmente, la mejor opción de todas: **búsqueda entre notas**. Para utilizarla hay ejecutar el comando

```bash
./gestor_notas.sh -b "search parameter"
```
El programa primero buscará una nota con el parámetro de búsqueda en el título y, en caso de que haya coincidencias las mostrará. Después buscará una coincidencia en todas las notas del directorio actual,
y en caso de encontrar alguna, imprimirá la línea donde se encuentra la coincidencia y la nota de donde proviene.
