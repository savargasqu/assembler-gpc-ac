**Sergio Alejandro Vargas Q.\
Arquitectura de Computadores 2016697-2\
2020-I\
Universidad Nacional de Colombia**

# Assembler

Implementación en el lenguaje de programación Lua de un ensamblador
para el computador de propósito general propuesto en clase.


## Uso

El programa se puede ejecutar desde un emulador de terminal y recibe dos argumentos:

- El primer argumento debe ser un archivo csv con el código _assembly_.
  La primera columna del archivo está reservada para las etiquetas y nombres
  de variables. La segunda columna lleva los nombres mnemotécnicos de las instrucciones.
  La tercera columna lleva el operando de la instrucción.

- El segundo argumento será el archivo de texto en el que se quiere guardar
  los códigos hexadecimales de las instrucciones de maquina. Si el archivo no
  existe, el programa creará uno. Este argumento es opcional, si no hay segundo
  argumento, el programa imprime a la salida de la terminal (_stdout_).

Es importante que las instrucciones estén bien escritas (tal como están en la tabla del ISA),
si una instrucción está mal escrita, el programa _no_ fallará, solo omitirá la instrucción.
Si alguna linea de las instrucciones de maquina solo tiene dos dígitos,
la instrucción está mal escrita.
El programa _no_ distingue mayúsculas y minúsculas.


# Ejemplo:

Lua es un lenguaje interpretado, por lo que no es necesario compilar el código.
En el directorio `example01/` de este repositorio hay dos archivos:
`ex01_input.csv` y `ex01_output.txt`.

Ejecutando el archivo como:

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

| Machine language       | mnemonic    | Long name          | action                 | ciclos  |
| ---------------------- | ----------- | ------------------ | ---------------------- | ------- |
| `0000 0000 xxxx xxxx`  | `LODD`      | Load direct        | `AC M[x]`              | 7       |
| `0001 0000 xxxx xxxx`  | `STOD`      | Store direct       | `M[x] AC`              | 7       |
| `0010 0000 xxxx xxxx`  | `ADDD`      | Add direct         | `AC AC + M[x]`         | 7       |
| `0011 0000 xxxx xxxx`  | `SUBD`      | Substract direct   | `AC AC - M[x]`         | 5       |
| `0100 0000 xxxx xxxx`  | `LOCO`      | Load constant      | `AC x, x unsigned`     | 5       |
| `0101 0000 xxxx xxxx`  | `JPOS`      | Jump if positive   | `If AC >= 0 then PC x` | 5       |
| `0110 0000 xxxx xxxx`  | `JNEG`      | Jump if negative   | `If AC < 0 then PC x`  | 5       |
| `0111 0000 xxxx xxxx`  | `JZER`      | Jump if zero       | `If AC = 0 then PC x`  | 5       |
| `1000 0000 xxxx xxxx`  | `JNZE`      | Jump if nonzero    | `If AC != 0 then PC x` | 5       |
| `1001 0000 xxxx xxxx`  | `JUMP`      | Jump               | `PC x`                 | 5       |
| `1010 0000 0000 0000`  | `INPAC`     | Input AC           | `AC Din`               | 5       |
| `1011 0000 0000 0000`  | `OUTAC`     | Output AC          | `Dout AC`              | 5       |
| `1100 0000 0000 0000`  | `HALT`      | Halt program       |                        | 5       |


## Instalación de Lua

En Windows, la página oficial de [Lua](https://www.lua.org/start.html) recomienda
usar [LuaDist](http://luadist.org/)

Lua viene por defecto en algunas distribuciones de Linux.
También puede ser instalado con su package manager de preferencia.

