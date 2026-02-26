# NAME

getparam - prints value of ESPS parameter from parameter file or ESPS
Common

# SYNOPSIS

**getparam** \[ **-p** *param_name* \] \[ **-P** *param_file* \] \[
**-n** \] \[ **-c** *checkfile* \] \[ **-x** *debug_level* \] \[ **-z**
\]

# DESCRIPTION

*Getparam* processes the ESPS parameter file *param_file* and ESPS
Common. It then obtains the value of the parameter *param_name* and
prints its value in ASCII to standard output.

The main purpose of *getparam* is to facilitate the writing of ESPS
shell scripts. With *getparam*, you can process a script command line
parameter file (**-P**) option in such a way to make the script conform
to the standard behavior of ESPS programs that accept **-P**. For
example, if the parameter file passed to *getparam* specifies run-time
prompts for parameter values ("?=" instead of "=" in the parameter
file), *getparam* will prompt for the values. This has no particular
value when running *getparam* interactively, but it does the right thing
when called from within a script (i.e., the caller of the script is
prompted).

*Getparam* is also useful if you want to find out the parameter values
that will be used by any ESPS program that is passed a given parameter
file, including the effects of ESPS Common (recall that the purpose of
ESPS Common is to allow programs to set parameter values for use by
programs that are run subsequently).

Parameter processing by *getparam* follows standard ESPS conventions:
Unless the parameter value is overridden by the value in ESPS Common,
the value printed by *getparam* is the value from the parameter file
*param_file*. This value will be overridden by the value in Common (if
the Common file exists and contains a value for *param_name*) provided
that ESPS Common processing is enabled and that the Common file is
younger than the parameter file. If a *checkfile* is specfied, the
parameter file value for *param_name* will be overridden by the value in
Common only if *checkfile* is identical to the *filename* entry in the
Common file.

ESPS Common processing is enabled unless the unix environment variable
USE_ESPS_COMMON is "off". The default ESPS Common file is .espscom in
the user's home directory. This may be overridden by setting the
environment variable ESPSCOM to the desired path. User feedback from
parameter and Common file processing (by the library *read_params* and
*getsym* functions) is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

The **-p** "option" giving the parameter name must be given. Other
command line options trully are optional. It is an error to give both
**-n** and **-c**. If *param_name* corresponds to an integer or float
array, a warning is issued if there is an inconsistency between the
*sym_size*(3-ESPS) returned value and *getsym_ia*(3-ESPS) or
*getsym_fa*(3-ESPS) (this should never happen).

*Getparam* returns values to the calling shell as follows: If a
parameter was obtained successfully, the value returned is 0. If a
user-interface error occurred, the value returned is 1. If the parameter
exists but is an array size inconsistency was found, the value returned
is 2. If the parameter does not exist or if *read_params* (3-ESPS)
returns with an error status, the value returned is 3.

# OPTIONS

The following options are supported:

**-p** *param_name*  
Specifies the name of the parameter whose value is desired. *Getparam*
exits with an error message if this option is not given.

**-P** *param_file* **\[params\]**  
Specifies the name of the ESPS parameter file to process. If you want to
force the parameter to come only from ESPS common, use "**-P**
/dev/null".

**-n**  
Do not process ESPS Common (i.e., always get the parameter value from
the file specified by the **-P** option). (Within *getparam*, the effect
of the **-n** is to have *read_params* (3-ESPS) called with the
SC_NOCOMMON flag.) Note also that Common processing can be disabled by
setting the unix environment variable USE_ESPS_COMMON to "off".

**-c** *checkfile*  
If the ESPS Common file exists, this option specifies that the Common
file should be processed only if the *checkfile* matches the value of
the *filename* in the Common file. This option cannot be given if the
**-n** is given. This option will have no effect if the unix environment
variable USE_ESPS_COMMON is "off".

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *getparam* outputs debugging messages. The
messages proliferate as *debug_level* increases. For level 0, there is
no output.

**-z**  
Specifies "silent" mode. In this mode, warnings are not printed
(parameter not found, parameter array size inconsistency). This mode is
most useful inside of shell scripts. For complete silence, note that the
environment variable ESPS_VERBOSE should be set to 0; otherwise, various
feedback messages will be issued by *read_params* (3-ESPS) and *getsym*
(3-ESPS).

# ESPS PARAMETERS

The ESPS parameter file specified by the **-P** option is processed only
to obtain the value of the parameter named by the **-p** option. In this
respect, *getparam* is quite different from other ESPS programs, which
use the parameter file to pass parameter values that control the
operation of the program.

# ESPS HEADERS

No ESPS files are processed by *getparam*.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled (no
**-n** option and environment variable USE_ESPS_COMMON not set to "off")
and that the Common file is younger than the ESPS parameter file. In
this case, parameters present in Common override values from the
parameter file. If the **-c** is given, the Common values override the
parameter file values only if the *checkfile* matches the value of the
*filename* in the Common file.

# SEE ALSO

*espsenv* (1-ESPS), *read_params* (3-ESPS), *getsym* (3-ESPS), *symtype*
(3-ESPS), *symsize* (3-ESPS)

# REFERENCE

"Parameter and Common Files in ESPS", ETM-S-86-12

# BUGS

None known.

# AUTHOR

Manual page and code by John Shore.
