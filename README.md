# portable

This is a skeleton `./configure` script and `Makefile`
to be used with software I try to write portably.
It is accompanied by a set of simple `have-*.c` programs autodetecting
the presence (or lack) of certain functions, structures and libraries,
and portable `compat-*.c` implementations for those not found.

The basic idea, structure, and a lot of code is taken from
the extremely portable [mandoc](http://mandoc.bsd.lv/).
The compatibility implementations are mostly taken from
[OpenBSD](http://cvsweb.openbsd.org/).

The main goal of this is to eliminate the use of GNU autotools,
which I find uneasy to work with, and which have the ability
to turn any given nice little project into a monster.

## systems

These are the systems where this is supposed to work.
If any of the autodetection fails or any of the compatibility
implementations does not work, please let me know.
please let us know.

* OpenBSD
* FreeBSD
* NetBSD
* MacOS
* Debian
* Solaris

## detection

### functions

* [`have-strtonum.c`](have-strtonum.c)

### structures

* [`have-msgcontrol.c`](have-msgcontrol.c)

### libraries

* [`have-gsm.c`](have-gsm.c)
* [`have-sndfile.c`](have-sndfile.c)

### audio drivers

* [`have-coreadio.c`](have-coreadio.c) (MacOS)
* [`have-sndio.c`](have-sndio.c) (OpenBSD)

## replacements

For C functions that might not be present in the system,
we provide portable `compat-*.c` implementations.
Please report any that turn out to be missing.

* [compat-strtonum.c](compat-strtonum.c)

## how is this used

### configuration

Run `./configure`. This will produce four files:

* `config.h` containing the `#include` and `HAVE_` lines
* `config.log` containing the details of autodetection
* `Makefile.local` which defines `CC`, `PREFIX` and the like
* `Makefile.external` which describes the detected libraries

Read the standard output and `Makefile.local`.
If these look different from what you expected,
read `configure.local.example`, create `configure.local`,
and run `./configure` again.

Read `config.h` and check that the `#define HAVE_*` lines
match your expectations.

Read `config.log`, which shows the compiler commands used to test
the presence of structures, functions and libraries in on your system,
and their standard output and standard error output.
Failures are most likely to happen
if headers or libraries are installed in unusual places
or interfaces defined in unusual headers.

### build

Run `make` to build the example software using these functions.
Either the system's native implementation will be used,
or the provided compatibility implementaton will be used.
Please report any that turn out to be missing.

For libraries, the example code will either perform some
trivial function using the library, or report that the library
is not available. We don't reimplement those of course.

### release

Run `make dist` to create a tarball for distribution,
named with the `VERSION` specified in the Makefile.
Run `make distcheck` to check that the entire suite
builds *from that tarball* (as opposed to the repository).
