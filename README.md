**Sergio Alejandro Vargas Q.\
Arquitectura de Computadores 2016697-2\
2020-I\
Universidad Nacional de Colombia**

# Assembler

Implementación en el lenguaje de programación Lua de un ensamblador
para el computador de propósito general propuesto en clase.

## Uso

El programa se puede ejecutar desde un emulador de terminal. Sin argumentos,
el programa lee _stdin_ (deja de leer con un EOF), y escribe a _stdout_.

También puede leer dos argumentos:

- El primer argumento debe ser un archivo csv con el código _assembly_.
  La primera columna del archivo está reservada para las etiquetas y nombres
  de variables. La segunda columna lleva los nombres mnemotécnicos de las instrucciones.
  La tercera columna (opcionalmente) lleva el operando de la instrucción.

- El segundo argumento será el archivo de texto en el que se quiere guardar
  los códigos hexadecimales de las instrucciones de maquina. Si el archivo no
  existe, el programa creará uno. Este argumento es opcional, si no hay segundo
  argumento, el programa imprime a la salida de la terminal (_stdout_).

Es importante que las instrucciones estén bien escritas, tal como están en la tabla del ISA).
Si una instrucción está mal escrita, el programa _no_ fallará, solo omitirá la instrucción.
Si alguna linea de las instrucciones de maquina solo tiene dos dígitos,
la instrucción está mal escrita.
El programa _no_ distingue mayúsculas y minúsculas.


## Ejemplo:

En el directorio `example01/` de este repositorio hay dos archivos:
`ex01_input.csv` y `ex01_output.txt`.

Ejecutando el código con el archivo de entrada y un nuevo archivo de salida tenemos:

```
$ lua assembler.lua example01/ex01_input.csv ./out.txt
> symbol table: {...}
```

Se debería obtener un archivo de texto `out.txt` con las instrucciones de maquina.
Para comprobar que el programa se está ejecutando correctamente,
este archivo se puede comparar con la salida esperada:

```
$ diff out.txt example01/ex01_output.txt
$ echo $?
> 0
```

## ISA:

| Machine language      | mnemonic   | Long name        | action                  | cycles |
| --------------------- | ---------- | ---------------- | ----------------------- | ------ |
| `0000 0000 xxxx xxxx` | `LODD`     | Load direct      | `  AC <- M[x]`          | 7      |
| `0001 0000 xxxx xxxx` | `STOD`     | Store direct     | `M[x] <- AC`            | 7      |
| `0010 0000 xxxx xxxx` | `ADDD`     | Add direct       | `  AC <- AC + M[x]`     | 7      |
| `0011 0000 xxxx xxxx` | `SUBD`     | Substract direct | `  AC <- AC - M[x]`     | 5      |
| `0100 0000 xxxx xxxx` | `LOCO`     | Load constant    | `  AC <- x`, x unsigned | 5      |
| `0101 0000 xxxx xxxx` | `JPOS`     | Jump if positive | `if AC >= 0, then PC x` | 5      |
| `0110 0000 xxxx xxxx` | `JNEG`     | Jump if negative | `if AC < 0, then PC x`  | 5      |
| `0111 0000 xxxx xxxx` | `JZER`     | Jump if zero     | `if AC = 0, then PC x`  | 5      |
| `1000 0000 xxxx xxxx` | `JNZE`     | Jump if nonzero  | `if AC != 0 then PC x`  | 5      |
| `1001 0000 xxxx xxxx` | `JUMP`     | Jump             | `  PC <- x`             | 5      |
| `1010 0000 0000 0000` | `INPAC`    | Input AC         | `  AC <- Din`           | 5      |
| `1011 0000 0000 0000` | `OUTAC`    | Output AC        | `Dout <- AC`            | 5      |
| `1100 0000 0000 0000` | `HALT`     | Halt program     |                         | 5      |
| `1101 0000 0000 0000` | `LDIX`     | LOAD IX          | `IX <- AC (7: 0)`       | 5      |
| `1110 0000 xxxx xxxx` | `LODI`     | Load indirect    | `AC <- M[IX + x]`       | 7      |
| `1111 0000 xxxx xxxx` | `STOI`     | Store indirect   | `M[IX + x] <- AC`       | 7      |
| `0000 0001 xxxx xxxx` | `ADDI`     | Add indirect     | `AC <- AC + M[IX + x]`  | 7      |
| `0000 0010 xxxx xxxx` | `SUBI`     | Sub indirect     | `AC <- AC - M[IX + x]`  | 7      |


## Instalación de Lua

**Windows**: la forma más conveniente de usar Lua es descargar
un interprete ya compilado. En 
[LuaBinaries.net](http://luabinaries.sourceforge.net/download.html)
hay binarios para Windows x86 y x64.

la página oficial de [Lua](https://www.lua.org/start.html) recomienda
usar [LuaDist](http://luadist.org/), pero esta distribución necesita CMake y WinGW
para ser compilada.

**linux**: Descargar con su package manager de preferencia (apt, rpm, pacman).
Algunas distribuciones ya tienen Lua instalado.

**macOS**: Descargar con su package manager de preferencia. (homebrew, macports).

