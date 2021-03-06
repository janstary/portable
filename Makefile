NAME	= prog
VERSION	= 1.2.3
TARBALL = $(NAME)-$(VERSION).tar.gz

include Makefile.local

PROG_SRCS =	\
	prog.c	\
	prog.h	\
	util.c	\
	util.h

PROG_OBJS =	\
	prog.o	\
	util.o

HAVE_SRCS =			\
	have-err.c		\
	have-gethostbyname.c	\
	have-socket.c		\
	have-reallocarray.c	\
	have-strlcat.c		\
	have-strlcpy.c		\
	have-strtonum.c		\
	have-msgcontrol.c	\
	have-sndfile.c

COMPAT_SRCS =			\
	compat-err.c		\
	compat-reallocarray.c	\
	compat-strlcat.c	\
	compat-strlcpy.c	\
	compat-strtonum.c

COMPAT_OBJS =			\
	compat-err.o		\
	compat-reallocarray.o	\
	compat-strlcat.o	\
	compat-strlcpy.o	\
	compat-strtonum.o

EXT_SRCS = \
	sndfile.c

SRCS = $(PROG_SRCS) $(COMPAT_SRCS) $(EXT_SRCS) $(HAVE_SRCS)
OBJS = $(PROG_OBJS) $(COMPAT_OBJS) $(EXT_OBJS)

BINS = prog
MAN1 = prog.1
MANS = $(MAN1)

DIST = \
	LICENSE			\
	Makefile		\
	Makefile.depend		\
	configure		\
	$(SRCS)			\
	$(HDRS)			\
	$(MANS)

all: $(BINS) $(MANS) Makefile.local

prog: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LDADD)

include Makefile.depend

.SUFFIXES: .c .o

.c.o:
	$(CC) $(CFLAGS) -c $<

lint: $(MANS)
	mandoc -Tlint -Wstyle $(MANS)

install: all
	install -d $(BINDIR) && install -m 0555 $(BINS) $(BINDIR)
	install -d $(LIBDIR) && install -m 0444 $(LIBS) $(LIBDIR)
	install -d $(INCDIR) && install -m 0444 $(HDRS) $(INCDIR)
	install -d $(MANDIR)/man1 && install -m 0644 $(MAN1) $(MANDIR)/man1
	#install -d $(MANDIR)/man3 && install -m 0644 $(MAN3) $(MANDIR)/man3
	#install -d $(MANDIR)/man7 && install -m 0644 $(MAN7) $(MANDIR)/man7
	which makewhatis > /dev/null && makewhatis $(MANDIR)

uninstall:
	cd $(BINDIR)      && rm -f $(BINS)
	cd $(LIBDIR)      && rm -f $(LIBS)
	cd $(INCDIR)      && rm -f $(HDRS)
	cd $(MANDIR)/man1 && rm -f $(MAN1)
	#cd $(MANDIR)/man3 && rm -f $(MAN3)
	#cd $(MANDIR)/man7 && rm -f $(MAN7)

clean:
	rm -f $(BINS) $(OBJS)
	rm -rf $(TARBALL) $(NAME)-$(VERSION) .dist
	rm -rf depend _depend .depend
	rm -rf *.dSYM *.core *~ .*~

distclean: clean
	rm -f Makefile.local config.*

Makefile.local config.h: configure $(HAVE_SRCS)
	@echo "$@ is out of date; please run ./configure"
	@exit 1

depend: config.h
	mkdep -f depend $(CFLAGS) $(PROG_SRCS)
	perl -e 'undef $$/; $$_ = <>; s|/usr/include/\S+||g; \
		s|\\\n||g; s|  +| |g; s| $$||mg; print;' \
		depend > _depend
	mv _depend depend

dist: $(TARBALL)
$(TARBALL): $(DIST)
	rm -rf .dist
	mkdir -p .dist/$(NAME)-$(VERSION)/
	$(INSTALL) -m 0644 $(DIST) .dist/$(NAME)-$(VERSION)/
	( cd .dist/$(NAME)-$(VERSION) && chmod 755 configure )
	( cd .dist && tar czf ../$@ $(NAME)-$(VERSION) )
	rm -rf .dist/

distcheck: dist
	rm -rf $(NAME)-$(VERSION) && tar xzf $(TARBALL)
	( cd $(NAME)-$(VERSION) && ./configure && make all )

.PHONY: install uninstall
.PHONY: clean distclean
.PHONY: dist distcheck
.PHONY: lint
