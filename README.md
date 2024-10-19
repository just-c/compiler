
`cproc` is a [C11] compiler. It uses the [QBE] backend.

Some C23 features and GNU C extensions are implemented.

It implements most of the c language and is capable of building software including itself, gcc 4.7, binutils, and more.

# Requirements

The compiler itself is written in C99 and can be built with any conforming C99 compiler.

The POSIX driver depends on POSIX.1-2008 interfaces, and the `Makefile` requires a POSIX-compatible make(1).

At runtime, you need QBE, an assembler, and a linker for the target system. Since the preprocessor is not yet implemented, an external one is required.

# Supported targets

All architectures supported by QBE should work (x86\_64, aarch64, and riscv64).

These targets are known to bootstrap and pass all tests:
- `x86_64-linux-musl`
- `x86_64-linux-gnu`
- `x86_64-freebsd`
- `aarch64-linux-musl`
- `aarch64-linux-gnu`
- `riscv64-linux-gnu`

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

# Bootstrap

The `Makefile` includes several other targets that can be used for
bootstrapping. These targets require the ability to run the tools
specified in `config.h`.

- **`stage2`**: Build the compiler with the initial (`stage1`) output.
- **`stage3`**: Build the compiler with the `stage2` output.
- **`bootstrap`**: Build the `stage2` and `stage3` compilers, and verify
  that they are byte-wise identical.

# What's missing

- Digraph sequences ([6.4.6p3], will not be implemented).
- Variable-length arrays ([#1]).
- `volatile`-qualified types ([#7]).
- `long double` type ([#3]).
- Inline assembly ([#5]).
- Preprocessor ([#6]).
- Generation of position independent code (i.e. shared libraries,
  modules, PIEs).
  
# Oasis

One of the main goals of cproc is to compile the entire oasis linux
system (excluding kernel and libc). This is a work in progress, but many
packages have patches to fix various ISO C conformance issues, enabling
them to be built.

See the [oasis #13] for the current status of this effort, and the
patch directories in the [oasis package tree] for any patches used.

# C23 status

cproc implements some C23 features applied to the latest drafts.

## [N2265]: `_Static_assert` without message

C11 required that static assertions always contained a message. C23
now allows `_Static_assert` with just an expression.

## [N2418]: UTF-8 character constants

C23 introduces UTF-8 character constants using the syntax `u8'a'`.
Compared to an unprefixed character constant, they have type `unsigned
char` instead of `int`, and are guaranteed to use UTF-8 encoding
rather than the execution character set. Since the character in a
UTF-8 character constant must have a single-byte UTF-8 encoding,
this type of character constant could be useful when you need the
ASCII value of a character, but do not want to depend on any
particular execution character set.

## [N2508]: Free positioning of labels inside compound statements

In previous revisions of C, labels like `foo:`, `case 123:`, or
`default:` could only precede statements. This was relaxed in C23,
and they can now appear intermixed with declarations in compound
statements.

## [N2510]: Allow unnamed parameters in a function definition

C23 allows you to omit the name of a parameter in the prototype of
a function definition that does not use that parameter.

## [N2549]: Binary integer constants

C23 allows binary integer constants in addition to octal, decimal,
and hexadecimal, using syntax like `0b01101011`.

## [N2900]: Consistent, warningless, and intuitive initialization with {}

C23 allows empty initializers to initialize an object as if it had
static storage duration.

## [N2927]: Not-so-magic typeof for C

C23 adds the `typeof(E)` type specifier to specify type of expression
`E`. Arrays and function designator expressions do not decay into
pointers, just like when used with `sizeof`. You can use a typename
with `typeof` to specify that same type.

C23 also introduces `typeof_unqual`, which behaves the same as
`typeof` except that the specified type is unqualified.

## [N2975]: Relax requirements for variadic parameter lists

C23 allows variadic functions with no named parameters. The second
argument to the va_arg macro is now optional and is only used for
backwards compatibility.

## [N3029]: Improved Normal Enumerations

C23 allows enumerators outside the range of `int`. When an enum
type contains such an enumerator, its type during processing of the
enum is the type of the initializing expression, or the type of the
previous enumerator if there is no initializing expression. In the
latter case, if the type of the previous enumerator can't represent
the current value, an integer type with the same signedness capable
of representing the value is chosen. Outside of an enum containing
a large enumerator, the types of all enumerators are changed to the
the enum type.

## [N3030]: Enhancements to Enumerations

C23 allows enum types with fixed underlying types using syntax like
`enum E : unsigned long`. These enum types are compatible with the
underlying type, and all enumerator constants have the enum type.

Enum types with fixed underlying types are complete by the end of
the underlying type specifier, so they can be forward-declared and
used inside the enum.

# Extensions

In addition to C11, several [GNU extensions] are implemented. The extensions below are implemented.

## `__asm__` labels

A declarator can be followed by `__asm__("somelabel")` to specify the
assembler name of the object or function. This name is taken literally, so
the resulting symbol will not be mangled according to the target's usual
rules. The name may contain characters not allowed in regular identifiers.

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
