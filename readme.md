# a cproc fork

`cproc` is a [C11] compiler. It uses the [QBE] backend.

It implements most of the c language and is capable of building software including itself, gcc 4.7, binutils, and more.

One of the goals of cproc is to compile the entire oasis linux system (excluding kernel and libc).

Many packages have patches to fix various ISO C conformance issues, enabling them to be built.

See the [oasis #13] for the current status of this effort, and the
patch directories in the [oasis package tree] for any patches used.

# Requirements

The compiler itself is written in C99.

At runtime, you need QBE, an assembler, and a linker for the target system. The preprocessor is not yet implemented; an external one is required.

# Targets

- `x86_64-linux-musl`

# Building

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

Once this is done, you can build with `make`.

# What's missing

- Digraph sequences ([6.4.6p3], will not be implemented).
- Variable-length arrays ([#1]).
- `volatile`-qualified types ([#7]).
- `long double` type ([#3]).
- Inline assembly ([#5]).
- Preprocessor ([#6]).
- Generation of position independent code (i.e. shared libraries,
  modules, PIEs).
  
# Implemented C23 features

## [N2265]: `_Static_assert` without message
## [N2418]: UTF-8 character constants
## [N2508]: Free positioning of labels inside compound statements
## [N2510]: Allow unnamed parameters in a function definition
## [N2549]: Binary integer constants
## [N2900]: Consistent, warningless, and intuitive initialization with {}
## [N2927]: Not-so-magic typeof for C
## [N2975]: Relax requirements for variadic parameter lists
## [N3029]: Improved Normal Enumerations
## [N3030]: Enhancements to Enumerations

# Implemented [GNU extensions]

## `__asm__` labels

A declarator can be followed by `__asm__("somelabel")` to specify the
assembler name of the object or function. This name is taken literally, so the resulting symbol will not be mangled according to the target's usual rules.

## Built-in functions and types

- **`__builtin_alloca`**: Allocate memory on the stack.
- **`__builtin_constant_p`**: Test whether the argument is a constant expression.
- **`__builtin_inff`**: `float` positive infinity value.
- **`__builtin_nanf`**: `float` quiet NaN value.
- **`__builtin_offsetof`**: Return the offset of a member in a struct or union.
- **`__builtin_types_compatible_p`**: Test whether the two types are compatible.
- **`__builtin_va_arg`**: Built-in suitable for implementing the `va_arg` macro.
- **`__builtin_va_copy`**: Built-in suitible for implementing the `va_copy` macro.
- **`__builtin_va_end`**: Built-in suitible for implementing the `va_end` macro.
- **`__builtin_va_list`**: Built-in suitable for implementing the `va_list` type.
- **`__builtin_va_start`**: Built-in suitable for implementing the `va_start` macro.

[QBE]: https://c9x.me/compile/
[C11]: http://port70.net/~nsz/c/c11/n1570.html

[6.4.6p3]: http://port70.net/~nsz/c/c11/n1570.html#6.4.6p3
[#1]: https://todo.sr.ht/~mcf/cproc/1
[#3]: https://todo.sr.ht/~mcf/cproc/3
[#5]: https://todo.sr.ht/~mcf/cproc/5
[#6]: https://todo.sr.ht/~mcf/cproc/6
[#7]: https://todo.sr.ht/~mcf/cproc/7

[oasis #13]: https://github.com/oasislinux/oasis/issues/13
[oasis package tree]: https://github.com/oasislinux/oasis/tree/master/pkg

[N2265]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2265.pdf
[N2418]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2418.pdf
[N2508]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2508.pdf
[N2510]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2510.pdf
[N2549]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2549.pdf
[N2900]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2900.htm
[N2927]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2927.htm
[N2975]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2975.pdf
[N3029]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3029.htm
[N3030]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3030.htm

[GNU extensions]: https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
