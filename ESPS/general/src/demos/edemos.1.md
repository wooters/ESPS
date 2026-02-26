# NAME

edemos - put up a button control panel for various Entropic demos

# SYNOPSIS

**edemos** \[ *tmp_directory* \]

# DESCRIPTION

*edemos* (1-ESPS) pops up a push-button control panel containing a
*QUIT* button and pull-down menu buttons for each demo. The various
demos may create temporary output files. By default, *edemos* creates a
temporary directory for these on /usr/tmp. The optional argument
*tmp_directory* may be used to override the default and specify a
directory for temporary files. If it exists, this directory must be
writable by the demo user; if not, *edemos* will try to create it.
Pressing the QUIT button on the *edemos* control panel. If a temp
directory was selected by *edemos* (i.e., if *tmp_directory* was not
specified), *edemos* will remove the temporary directory provided that
none of the demos is running. If a demo is running, a pop-up window
appears with a message stating that the temporary directory was not
removed. If *tmp_directory* was specified, no such removal or notice
takes place.

A crude locking scheme is implemented to stop individual demos from
interfering with each other, and to indicate whether it is safe to
remove the temporary directory. You may need to manually remove a lock
file and start again under some circumstances. A pop-up window will
report the location of the lock file.

*edemos* (1-ESPS) is intended to present some interesting displays, show
some applications of ESPS and *waves*+(1-ESPS), and provide examples of
how to configured ESPS and *waves*+ (1-ESPS) for different tasks.

*edemos* (1-ESPS) invokes a shell script that runs *mbuttons* (1-ESPS)
and presents a button panel. Under each button is a shell script. These
shell scripts run ESPS and *waves*+ (1-ESPS) commands. If you do not
have both ESPS and *waves+*, *edemos* (1-ESPS) will not work.

If an ESPS license is not checked out to the current host, *edemos* will
check one out. No direct indication is given if the checkout fails (but
various programs will report that a license has not been checkout out).

Some of the demos provide audio output, if available, and try detect and
setup for support options (SPARCStation codec, AT&T Fab2 board, Ariel
S-32C/Proport). In these cases, a "Setup Audio" button-menu is provided
to permit manual selection. One of the choices is always "generic
audio"; this is the option to choose if there is a program called "play"
somewhere on your path that "does the right thing" (accepts an ESPS
range option and file and plays the data).

# OPTIONS

There are none.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

The common file is not used.

# BUGS

None known.

# EXPECTED CHANGES

# SEE ALSO

# AUTHOR

Shore and Burton.
