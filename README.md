**Sergio Alejandro Vargas Q.\
Arquitectura de Computadores 2016697-2\
2020-I\
Universidad Nacional de Colombia**

# Assembler

Implementación en el lenguaje de programación Lua de un ensamblador
para el computador de propósito general propuesto en clase.
El computador tiene 18 instrucciones, presentadas en la siguiente tabla:


### ISA:

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


### Uso

`lua assembler.lua <input> <output>`

Donde `<input>` y `<output>` son argumentos opcionales que indican el nombre de
algún archivo.

Sin argumentos, el ensamblador lee _stdin_ (deja de leer con un EOF),
y escribe a _stdout_.

- `input`: Archivo csv con el código _assembly_.
  La primera columna está reservada para las etiquetas y nombres
  de variables; La segunda columna lleva los nombres mnemotécnicos de las instrucciones;
  La tercera columna (opcional) lleva el operando de la instrucción.

- `output`: Archivo de texto en el que se escriben los códigos hexadecimales
  de las instrucciones de maquina. Si el archivo no existe, el programa creará uno.

Es importante que las instrucciones estén bien escritas, tal como están en la tabla del ISA.
Si una instrucción está mal escrita, el programa _no_ fallará, solo omitirá la instrucción.
Si alguna linea de las instrucciones de maquina solo tiene dos dígitos,
la instrucción está mal escrita.
El programa _no_ distingue mayúsculas y minúsculas.


### Ejemplo:

En el directorio `example01/` de este repositorio hay dos archivos:
`input01.csv` y `output01.txt`.

Ejecutando el código con el archivo de entrada y un nuevo archivo de salida tenemos:

```
$ lua assembler.lua example01/input01.csv ./out.txt
> symbol table: {...}
```

Se debería obtener un archivo de texto `out.txt` con las instrucciones de maquina.
Para comprobar que el programa se está ejecutando correctamente,
este archivo se puede comparar con la salida esperada:

```
$ diff out.txt example01/output01.txt
$ echo $?
> 0
```
