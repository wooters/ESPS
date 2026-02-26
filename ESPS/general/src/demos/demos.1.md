# NAME

demos - put up the button control panel for the demos

# SYNOPSIS

**demos** \[ *tmp_directory* \]

# DESCRIPTION

*demos* (1-ESPS) pops up a push-button control panel containing a *QUIT*
button and pull-down menu buttons for each demo. By default, *demos*
(1-ESPS) creates a directory on /usr/tmp. Any files created by the demos
go into this directory. *demos* (1-ESPS) has an optional argument to
allow the user to specify the location of any output files; this
directory must be writable by the demo user.

A crude locking scheme is implemented to stop individual demos from
interfering with each other. You may need to manually remove a lock
file, and start again under some circumstances. *demos*(1-ESPS) will
tell you the location of the lock file.

*demos* (1-ESPS) is intended to present some interesting displays, show
some applications of ESPS and *waves*+(1-ESPS), and provide some
examples of how to configured ESPS and *waves* (1-ESPS)+ for different
tasks.

*demos* (1-ESPS) is a shell script that runs *mbuttons* (1-ESPS) and
presents a button panel. Under each button is a shell script. These
shell scripts run ESPS and waves+ commands. If you do not have both ESPS
and *waves+*, *demos* (1-ESPS) will not work.

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
