/* syslog.c */
#include "erl_nif.h"
#include <syslog.h>

#define ENIF_OK "ok\0"

static ERL_NIF_TERM slog(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{

  int priority = LOG_DEBUG;
  enif_get_int(env, argv[0], &priority);

  unsigned int length = 0;
  enif_get_list_length(env, argv[1], &length);

  char *buf = (char *)enif_alloc(++length);
  enif_get_string(env,argv[1], buf, length, ERL_NIF_LATIN1);
  syslog(priority,"%s",buf);
  enif_free(buf);

  return enif_make_atom(env, ENIF_OK);
}
static ErlNifFunc nif_funcs[] =
{
    {"slog", 2, slog}
};

ERL_NIF_INIT(syslog,nif_funcs,NULL,NULL,NULL,NULL)

