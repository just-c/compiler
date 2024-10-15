`cproc` is a [C11] compiler using [QBE] as a backend.

Some [C23 features] and [GNU C extensions] are implemented.

It currently implements most of the
language and is capable of [building software] including itself, mcpp,
gcc 4.7, binutils, and more.

## Requirements

The compiler itself is written in C99 and can be built with any conforming C99 compiler.

The POSIX driver depends on POSIX.1-2008 interfaces, and the `Makefile`
requires a POSIX-compatible make(1).

At runtime, you will need QBE, an assembler, and a linker for the
target system. Since the preprocessor is not yet implemented, an
external one is currently required as well.

## Supported targets

All architectures supported by QBE should work (currently x86\_64,
aarch64, and riscv64).

The following targets are tested by the continuous build and known to
bootstrap and pass all tests:

- `x86_64-linux-musl`
- `x86_64-linux-gnu`
- `x86_64-freebsd`
- `aarch64-linux-musl`
- `aarch64-linux-gnu`
- `riscv64-linux-gnu`

## Building

Run `./configure` to create a `config.h` and `config.mk` appropriate for
your system. If your system is not supported by the configure script,
you can create these files manually. `config.h` should define several
string arrays (`static char *[]`):

- **`startfiles`**: Objects to pass to the linker at the beginning of
  the link command.
- **`endfiles`**: Objects to pass to the linker at the end of the link
  command (including libc).
- **`preprocesscmd`**: The preprocessor command, and any necessary flags
  for the target system.
- **`codegencmd`**: The QBE command, and possibly explicit target flags.
- **`assemblecmd`**: The assembler command.
- **`linkcmd`**: The linker command.

You may also want to customize your environment or `config.mk` with the
appropriate `CC`, `CFLAGS` and `LDFLAGS`.

Once this is done, you can build with

	make

### Bootstrap

The `Makefile` includes several other targets that can be used for
bootstrapping. These targets require the ability to run the tools
specified in `config.h`.

- **`stage2`**: Build the compiler with the initial (`stage1`) output.
- **`stage3`**: Build the compiler with the `stage2` output.
- **`bootstrap`**: Build the `stage2` and `stage3` compilers, and verify
  that they are byte-wise identical.

## What's missing

- Digraph sequences ([6.4.6p3], will not be implemented).
- Variable-length arrays ([#1]).
- `volatile`-qualified types ([#7]).
- `long double` type ([#3]).
- Inline assembly ([#5]).
- Preprocessor ([#6]).
- Generation of position independent code (i.e. shared libraries,
  modules, PIEs).

[QBE]: https://c9x.me/compile/
[C11]: http://port70.net/~nsz/c/c11/n1570.html
[C23 features]: https://man.sr.ht/~mcf/cproc/doc/c23.md
[GNU C extensions]: https://man.sr.ht/~mcf/cproc/doc/extensions.md
[building software]: https://man.sr.ht/~mcf/cproc/doc/software.md
[6.4.6p3]: http://port70.net/~nsz/c/c11/n1570.html#6.4.6p3
[#1]: https://todo.sr.ht/~mcf/cproc/1
[#3]: https://todo.sr.ht/~mcf/cproc/3
[#5]: https://todo.sr.ht/~mcf/cproc/5
[#6]: https://todo.sr.ht/~mcf/cproc/6
[#7]: https://todo.sr.ht/~mcf/cproc/7