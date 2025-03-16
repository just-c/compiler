.POSIX:
.PHONY: all check install clean

BINDIR=/usr/local/bin
MANDIR=/usr/local/share/man
BUILDDIR=build

CC=cc
CFLAGS=-std=c99 -Wall -Wpedantic -Wno-parentheses -Wno-switch -g -pipe
LDFLAGS=

all: cproc cproc-qbe

DRIVER_SRC=\
	driver.c\
	util.c
DRIVER_OBJ=$(DRIVER_SRC:%.c=$(BUILDDIR)/%.o)

cproc: $(DRIVER_OBJ)
	$(CC) $(LDFLAGS) -o $@ $(DRIVER_OBJ)

SRC=\
	attr.c\
	decl.c\
	eval.c\
	expr.c\
	init.c\
	main.c\
	map.c\
	pp.c\
	scan.c\
	scope.c\
	stmt.c\
	targ.c\
	token.c\
	tree.c\
	type.c\
	utf.c\
	util.c\
	qbe.c
OBJ=$(SRC:%.c=$(BUILDDIR)/%.o)

cproc-qbe: $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ)

$(BUILDDIR)/%.o: %.c
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

check: all
	@CCQBE=./cproc-qbe ./runtests

install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	cp cproc cproc-qbe $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp cproc.1 $(DESTDIR)$(MANDIR)/man1

clean:
	rm -rf cproc cproc-qbe $(BUILDDIR)
