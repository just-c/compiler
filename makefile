.POSIX:
.PHONY: all check install clean

BINDIR=/usr/local/bin
MANDIR=/usr/local/share/man
BUILDDIR=build

CC=cc
CFLAGS=-std=c99 -Wall -Wpedantic -Wno-parentheses -Wno-switch -g -pipe
LDFLAGS=

all: cproc cproc-qbe

SRC=\
	attr.c\
	decl.c\
	eval.c\
	expr.c\
	init.c\
	main.c\
	map.c\
	pp.c\
	qbe.c\
	scan.c\
	scope.c\
	stmt.c\
	targ.c\
	token.c\
	tree.c\
	type.c\
	utf.c\
	util.c
OBJ=$(SRC:%.c=$(BUILDDIR)/%.o)

cproc: $(BUILDDIR)/driver.o $(BUILDDIR)/util.o
	$(CC) $(LDFLAGS) -o $@ $^

cproc-qbe: $(filter-out $(BUILDDIR)/driver.o, $(OBJ))
	$(CC) $(LDFLAGS) -o $@ $^

$(BUILDDIR)/%.o: %.c
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

check: all
	@CCQBE=./cproc-qbe ./runtests

install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	cp cproc cproc-qbe $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp ./docs/cproc.1 $(DESTDIR)$(MANDIR)/man1

clean:
	rm -rf cproc cproc-qbe $(BUILDDIR)
