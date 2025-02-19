# Morse Assembly Translation

This project is an assembly program that translates text to Morse code and vice versa. The program reads input from the standard input, processes it, and outputs the corresponding Morse code or text.

## Files

- `morse.asm`: The main assembly source file containing the implementation of the translation logic.
- `Makefile`: A makefile to build the project using `nasm` and `ld`.

## Building the Project

To build the project, run the following command in the terminal:

```sh
make
```

This will assemble and link the `morse.asm` file to create an executable named `morse`.

## Running the Program

To run the program, use the following command:

```sh
./morse
```

The program will read input from the standard input and output the translated Morse code or text to the standard output.

## Cleaning Up

To clean up the build files, run:

```sh
make clean
```

This will remove the object file and the executable.

## Morse Code Reference

The program uses the following Morse code mappings:

- Letters: A-Z
- Numbers: 0-9
- Space: " "

## Example

Input:
```
HELLO WORLD
```

Output:
```
.... . .-.. .-.. ---  .-- --- .-. .-.. -..
```

## License

This project is licensed under the MIT License.