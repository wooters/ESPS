# NAME

eparam - run an ESPS program with parameter prompts

# SYNOPSIS

**eparam** *program_name* *program_options*

# DESCRIPTION

*Eparam* runs the ESPS program *program_name* using a default parameter
file for that program. The user is prompted for all parameter values.
Each prompt includes in brackets a default value. After each prompt, the
user may accept the default value by entering a carriage return or may
provide a new value followed by a carriage return. All
*program_options,* which should include any required file names, are
passed directly on to *program_name.*

*Eparam* may be used with any ESPS program that processes a parameter
file, i.e., with any ESPS program that has the **-P** option. For
example, the effect of running


        %eparam refcof input.sd output.fana

    is the same as the direct call

        %refcof -P esps_params/Prefcof input.sd output.fana

where *esps_params* is the directory containing the default parameter
files, and where Prefcof is the name of the default parameter file for
*refcof* (1-ESPS). The directory *esps_params* is chosen during ESPS
installation and is known to *eparam.*

If you use *eparam* with an ESPS program that does not process a
parameter file, you will get a usage message issued by *program_name.*

Since the default parameter files read form standard input, *eparam*
cannot in a case where the called ESPS program will read data from
standard input (*Ie.g.* the input file-name is given as "-"). Output to
standard output is not affected.

# OPTIONS

No options to *eparam* are supported currently. All *program_options*
are passed on to *program_name.*

# ESPS PARAMETERS

The ESPS Parameter file is not processed by *eparam.* It is processed by
ESPS programs invoked by *eparam.* For details in each case, see the
manual page for *program_name.*

# ESPS COMMON

ESPS Common processing is temporarily disabled by *eparam* while
*program_name* is executed.

# ESPS HEADERS

See the manual page for *program_name*

# FUTURE CHANGES

# SEE ALSO

In each case, see the manual page for *program_name.*

# BUGS

# FILES

The default parameter files are located in the directory
\$ESPS_BASE/lib/params Within this directory, the individual parameter
files are named as "P*program_name*".

# REFERENCES

# AUTHOR

manual page and program by John Shore
