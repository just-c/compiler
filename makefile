.POSIX:

BINDIR=/usr/local/bin
MANDIR=/usr/local/share/man

CC=cc
CFLAGS=-std=c99 -Wall -Wpedantic -Wno-parentheses -Wno-switch -g -pipe
LDFLAGS=

.PHONY: all
all: cproc cproc-qbe

DRIVER_SRC=\
	driver.c\
	util.c
DRIVER_OBJ=$(DRIVER_SRC:%.c=%.o)

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
OBJ=$(SRC:%.c=%.o)

cproc-qbe: $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ)

attr.o   : attr.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ attr.c
decl.o   : decl.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ decl.c
driver.o : driver.c util.h config.h   ; $(CC) $(CFLAGS) -c -o $@ driver.c
eval.o   : eval.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ eval.c
expr.o   : expr.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ expr.c
init.o   : init.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ init.c
main.o   : main.c   util.h cc.h arg.h ; $(CC) $(CFLAGS) -c -o $@ main.c
map.o    : map.c    util.h            ; $(CC) $(CFLAGS) -c -o $@ map.c
pp.o     : pp.c     util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ pp.c
qbe.o    : qbe.c    util.h cc.h ops.h ; $(CC) $(CFLAGS) -c -o $@ qbe.c
scan.o   : scan.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ scan.c
scope.o  : scope.c  util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ scope.c
stmt.o   : stmt.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ stmt.c
targ.o   : targ.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ targ.c
token.o  : token.c  util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ token.c
tree.o   : tree.c   util.h            ; $(CC) $(CFLAGS) -c -o $@ tree.c
type.o   : type.c   util.h cc.h       ; $(CC) $(CFLAGS) -c -o $@ type.c
utf.o    : utf.c    utf.h             ; $(CC) $(CFLAGS) -c -o $@ utf.c
util.o   : util.c   util.h            ; $(CC) $(CFLAGS) -c -o $@ util.c

.PHONY: check
check: all
	@CCQBE=./cproc-qbe ./runtests

.PHONY: install
install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	cp cproc cproc-qbe $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp cproc.1 $(DESTDIR)$(MANDIR)/man1

.PHONY: clean
clean:
	rm -rf cproc $(DRIVER_OBJ) cproc-qbe $(OBJ)
