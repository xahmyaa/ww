# ww: a mini x86_64 runtime

A minimal, lightweight runtime for Linux x86_64, written in assembly.

It acts as a **replacement for the standard C runtime (crt0)**, making it perfect for:

- Writing **C** code without the standard library (libc).
- Writing **Assembly** applications.
- Providing a **runtime for your own custom programming language**, avoiding the complexity of implementing your own startup code.

## Features

- **Tiny Footprint**: minimal assembly code.
- **Entry Point (`_start`)**:
  - Initializes `_ARGC`, `_ARGV`, and `_ENV` globals.
  - Aligns the stack to 16 bytes.
  - Calls hooks: `__ww_init`, `main`, `__ww_fini`.
    - `__ww_init`: Called before `main` for initialization.
    - `__ww_fini`: Called after `main` for cleanup.
    - **Note**: These are **optional**. If you don't define them, the runtime simply skips them without error.
- **Utilities**:
  - `_exit`: Cleanly exit the program.
  - `_panic`: Print a red "panic: " message followed by your text, then exit.

## Usage

### 1. Build the Runtime

```bash
make
```

This produces `build/ww.o`.

### 2. Link with Your Code

**For C / Custom Languages:**

Instead of linking with `crt1.o` / `gcrt1.o`, simply link your object files with `build/ww.o`.

```bash
# Example for GCC (freestanding)
gcc -c my_code.c -o my_code.o
ld build/ww.o my_code.o -o my_program
```

## Structure

- `ww.s`: Core runtime entry point and utility functions.
- `macro.s`: System call helpers.
