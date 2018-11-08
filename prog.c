#include "config.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "prog.h"

#ifdef HAVE_ERR
#include <err.h>
#endif

extern const char* __progname;

static void
usage()
{
	warnx("usage: %s number", __progname);
}

int
main(int argc, char** argv)
{
	uint8_t i;
	const char *e = NULL;

/* FIXME: use everything we tested for.
have-gethostbyname.c
have-msgcontrol.c
have-reallocarray.c
have-sndfile.c
have-socket.c
have-strlcat.c
have-strlcpy.c
*/
	if (--argc < 1) {
		usage();
		return 1;
	}

	i = strtonum(*++argv, 0, 255, &e);
	if (e != NULL)
		warnx("%s is %s", *argv, e);

	return 0;
}
