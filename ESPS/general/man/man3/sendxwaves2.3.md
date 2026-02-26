# NAME

OpenXwaves - open a connection to an *xwaves+* server\
SendXwavesNoReply - send a command to an *xwaves+* server and do not
wait for reply\
SendXwavesReply - send a command to an *xwaves+* server and wait for
reply\
CloseXwaves - close a connection to an *xwaves+* server

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/xwaves_ipc.h>

    Sxptr *
    OpenXwaves(display_name, destination, my_name)
    char *display_name;
    char *destination;
    char *my_name;

    int
    SendXwavesNoReply(display_name, destination, sxarg, message)
    char *display_name;
    char *destination;
    Sxptr *sxarg;
    char *message;

    char *
    SendXwavesReply(display_name, destination, sxarg, message, timeout)
    char *display_name;
    char *destination;
    Sxptr *sxarg;
    char *message;
    unsigned int timeout;

    void
    CloseXwaves(sxarg)
    Sxptr *sxarg;

# DESCRIPTION

*Xwaves* has an interprocess communications capability, based on
communicating through the X server. This communications method is
compatible with Tcl/Tk (version 4). When *xwaves* starts, it registers
itself with the X server that it is using for display. Programs using
these functions can send commands to *xwaves* and get the results of
those commands back.

In addition to this man page, see the Application Note, "Communicating
with *xwaves* from Tcl/Tk, C, and the Unix shell". This application note
gives details about how this communications works. The function
*SendXwavesReply* cannot be used from within an X program. See the above
mentioned application note for an example of how to work around this
limitation.

*OpenXwaves* attempts to setup a communications path to the *xwaves*
that has previously registered itself under the name *dest*, on either
the default X server, or one specified by *display_name*. The argument
*my_name* can be set to the name that the calling application is to be
registered as, or it can be NULL and a default name will be supplied. If
successful, then the function returns a pointer to a structure of type
**Sxptr**, which contains information needed by subsequent calls to
*SendXwavesReply* and *SendXwavesNoReply*. If the function fails, then
NULL is returned. The name that the application registers as must be
unique to all applications registered for communications, so the actual
name used might be different than the name supplied through *my_name*.
The actual name used is stored in the *Sxptr* structure returned as
*Sxptr.my_name*.

In most cases, the registered name of an *xwaves* application is
*xwaves*, but it might be different if it had to be changed in order to
be unique. This is rarely the case, however, since it would be unusual
to run two or more *xwaves* on the same X display. However, you might
need to provide a way for an application program to be given the name of
the correct *xwaves*. Note that the registered name of an *xwaves* is
given in parenthesis in the title bar of the control panel and is
exported into the environment under the variable name **XWAVES_NAME**.
This environment variable can be used by an application that is launched
by *xwaves* (from a menu addop for example).

If *display_name* is NULL, then the default X server is used (the one
specified by the environment variable **DISPLAY**. If *display_name* is
not NULL, then it should point to a character string that specifies an X
server in the usual format, *host:display.screen*. Of course, the
application using this function must have access permission to the X
server.

*SendXwavesNoReply* attempts to send a message to an *xwaves*
application and does not wait for a reply. There are two forms of usage
of this function. One is to use *OpenXwaves* first, and pass its return
value in as *sxarg*. This form should be used when frequent messages are
sent to *xwaves*. Since the communications is setup only once, overhead
is kept to a minimum. The other form of usage, is to specify the
destination *xwaves* with *display_name* and *dest*, just as is done
with *OpenXwaves*, but in this case the communications is setup inside
of *SendXwavesNoReply* and is closed after the message is sent. In this
case, the argument *sxarg* must be NULL. This form is simply provided
for convenience and eliminates two additional calls (*OpenXwaves* and
*CloseXwaves*). This function returns zero if an error occurred and the
message was not sent. Otherwise, the return value is non-zero. However,
a non-zero return value does not guarantee that the message was received
by *xwaves* or correctly processed by it.

*SendXwavesReply* attempts to send a message to an *xwaves* application
and waits for a response. The return is a character pointer to the
response, or NULL if the function was not able to send the message. A
timeout in milliseconds is specified by the *timeout* argument. If this
timeout expires before a response is received, then NULL is returned.
The minimum timeout (if zero is specified) is 1 ms. An appropriate
timeout is much larger, usually tens of seconds, but it could be more
depending upon the nature of the data and the operations being
performed. A typical use of this function would be to return the value
of an *xwaves* global, or to return attributes of views.

*CloseXwaves* is used to close a connection to an *xwaves*. It is only
used when a connection has been opened with *OpenXwaves*. The function
removes the calling application from the communications registry and
frees memory associated with the connection.

# DIAGNOSTICS

*OpenXwaves* returns NULL if it fails. The reasons for failure include,
failure to connect to the X server, failure to create a simple window to
be used for communications, failure to allocate memory when required,
and failure to find the application specified by *dest*.

*SendXwavesNoReply* returns 0 if it fails and non-zero upon success.
Reasons for failure are the same as above.

*SendXwavesNoReply* returns 0 if it fails and non-zero upon success. In
addition to the above reasons why it might fail, it will return 0 if the
timeout expires before a response is received from *xwaves*.

*CloseXwaves* does not return a value. It quietly does nothing if
*sxarg* is NULL. If passed garbage it (and most other Unix functions)
could cause a program failure (core dump).

# SEE ALSO

send_xwaves(1-ESPS)

# AUTHOR

Alan Parker, based on the idea and some code from Tk by John Ousterhout.
