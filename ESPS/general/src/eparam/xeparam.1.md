# NAME

xeparam - run an ESPS program generating the Parameter file using
exprompt(1)

# SYNOPSIS

**xeparam** *program_name* *program_options*

# DESCRIPTION

*Xeparam* runs the ESPS program *program_name* using a default parameter
file for that program. The user is prompted for all parameter values via
xprompt(1), an X-Window interface tool that allows editing of parameter
files. All *program_options,* which should include any required file
names, are passed directly on to *program_name.*

*Xeparam* may be used with any ESPS program that processes a parameter
file, i.e., with any ESPS program that has the -P option. For example,
the effect of running


        %xeparam refcof input.sd output.fana

    is the same as the direct call

        %refcof -P esps_params/Prefcof input.sd output.fana

where *esps_params* is the directory containing the default parameter
files, and where Prefcof is the name of the default parameter file for
refcof (1-ESPS). The directory *esps_params* is chosen during ESPS
installation and is known to *xeparam.*

If you use *xeparam* with an ESPS program that does not process a
parameter file, you will get a usage message issued by *program_name.*

Since the default parameter files read form standard input, xeparam
cannot in a case where the called ESPS program will read data from
standard input (Ie.g. the input file-name is given as "-"). Output to
standard output is not affected.

# OPTIONS

No options to *xeparam* are supported currently. All *program_options*
are passed on to *program_name.*

# ESPS PARAMETERS

The ESPS Parameter file is not processed by *xeparam.* It is processed
by xprompt(1) and the ESPS programs invoked by *xeparam.* For details in
each case, see the manual page for *program_name.*

# ESPS COMMON

ESPS Common processing is temporarily disabled by *xeparam* while
*program_name* is executed.

# ESPS HEADERS

See the manual page for *program_name*

# FUTURE CHANGES

# SEE ALSO

eparam (1-ESPS), exprompt (1-ESPS), expromptrun (1-ESPS)

In each case, see the manual page for *program_name.*

# BUGS

# FILES

The default parameter files are located in the directory
\$ESPS_BASE/lib/params. Within this directory, the individual parameter
files are named as "Pprogram_name".

# REFERENCES

# AUTHOR

manual page and program by John Shore
