# NAME

open_xwaves - open a socket connection to an *xwaves+* server\
send_xwaves - send a command to an *xwaves+* server\
close_xwaves - close a socket connection to an *xwaves+* server\
send_xwaves2 - send a single command to an *xwaves+* server without a
separate open and close

# SYNOPSIS

\#include \<esps/esps.h\> \#include \<esps/ss.h\>

    SOCKET *
    open_xwaves(host, port, verbose)
    char *host;
    int port, verbose;

    int
    send_xwaves(sp, str)
    SOCKET *sp;
    char *str;

    void
    close_xwaves(sp)
    SOCKET *sp;

    int
    send_xwaves2(host, port, str, verbose)
    open_xwaves(host, port, verbose)
    char *host, *str;
    int port, verbose;

# DESCRIPTION

These functions are used to communicate with an *xwaves+* program
running in server mode. For more details on this mode of *xwaves+* see
*xwaves+*�1ESPS).

The functions *open_xwaves*, *send_xwaves*, and *close_xwaves* are used
in cases where a program is going to send more than one command to an
*xwaves+* server. In this case, a socket connection is maintained open,
so that an arbitrary number of commands can be sent over it. When the
connection is no longer needed, it is closed.

The function *send_xwaves2* is used in cases where only a single command
is going to be sent. It combines the open and close function into a
single call. It should not be used to send a large number of commands,
however, due to the overhead of opening and closing the connection.

*open_xwaves* attempts to open a socket connection to an *xwaves+*
server. If *host* is non-NULL, then the connection is attempted on the
machine with the hostname of *host*. If *host* is NULL and the
environment variable **WAVES_HOST** is defined, then the connection is
attempted to a server on the hostname specified by **WAVES_HOST**. If
**WAVES_HOST** is not defined, then the connection is attempted to a
server on the same has as is running this function (i.e. *localhost*).
If *port* is non-zero, then its value is used as the socket port for the
connection attempt. If *port* is zero and the environment variable
**WAVES_PORT** is defined, then the port specified in **WAVES_PORT** is
used for the attempt. If **WAVES_PORT** is not defined then an ESPS
default value (given in *esps.h* is used instead). If *verbose* is
non-zero, then a message is printed if the connection cannot be opened,
mentioning the hostname and port number. If *verbose* is zero, no
message is printed and only a status value is returned. The return value
of the function is the SOCKET pointer value for success and NULL for
failure.

*send_xwaves* sends a command to an *xwaves+* running in server mode.
The value for *sp* must be a socket pointer previously returned by
*open_xwaves*. *str* is a pointer to the command to send and must be
non-NULL and terminated with a newline character. The function returns
zero for success and -1 for failure to communicate.

*close_xwaves* closes an existing socket connection to an *xwaves+*
server. The value of *sp* is a socket pointer to a previously opened
*xwaves+* server.

*send_xwaves2* combines the above functions into a single function, to
open a server connection, send a command, and then close a connection.
This is convienent when only a single command is being sent. The
arguments *host*, *port*, *str*, and *verbose* have the same meaning as
with the above functions. *str* is a pointer to the command to send and
must be non-NULL and terminated with a newline character.

# EXAMPLE

    /* Open a connection */
    SOCKET *sp;
    char buffer[100];

    sp = open_xwaves(host, port, 1);
    if (sp == NULL)
     error...

    sprintf(buffer,"make file %s,filename);
    if (send_xwaves(sp, buffer) == -1)
     error...

    close_xwaves(sp);

# DIAGNOSTICS

An assertion failure occurs if *str* or *sp* is NULL.

# SEE ALSO

send_xwaves(1-ESPS), waves_show_sd(3-ESPS)

# AUTHOR

Alan Parker, based upon the Simple Socket Library by Mat Watson and
Hubert Bartels. Used with permission.
