# NAME

xprompt - interactive ESPS parameter entry in a pop-up window

# SYNOPSIS

**xprompt** \[ **-P** *param_file* \] \[ **-n** \] \[ **-c** *checkfile*
\] \[ **-h** *help_name* \] \[ **-z** \] \[ **-x** *debug_level* \]
param_out

# DESCRIPTION

*Xprompt* is an X Windows program that displays an interactive form for
entering ESPS parameters and produces a new parameter file (for use in
subsequent processing) based on the user's entries. For a version that
also runs an ESPS program (after prompting for parameters), see
*xpromptrun* (1-ESPS).

*Xprompt* processes the ESPS parameter file *param_file* and
(optionally) ESPS Common. It then pops up a window containing an entry
for each of the indefinite paramaters in *param_file* (parameters with
values assigned using the "?=" operator). Each such entry has the name
of the parameter and a space for filling in the desired value. Default
values from the parameter file are filled in initially. If a prompt
string was included in the parameter file, the string is displayed above
the corresponding parameter entry.

If the parameter definition in the parameter file includes the optional
set of discrete choices, the window entry for the parameter contains a
set of screen buttons, one for each choice - the user selects the
parameter value by clicking with the mouse on the desired choice. If
discrete choices were not provided in the parameter file, the window
entry for the parameter contains space in which the user can type the
desired value.

Before displaying the interactive window, *xprompt* creates the output
parameter file *param_out*, and fills it with definitions for all of the
parameters in *param_file* and ESPS Common (if Common is processed). The
initial values in *param_out* are the default values from *param_file*,
perhaps modified by Common processing.

Whenever the user enters a valid new value for a parameter in the
*xprompt* window, the output file *param_file* is updated. Note that
that data entry requires that a RETURN by typed at the end of the entry
string (See "BUGS"). Input parameters are checked for data type format.
If limits are provided for numeric parameters in the parameter file, the
limits are checked.

Two or three screen buttons are provided in a panel at the top of the
*xprompt* window. The button DEFAULTS reverts all parameter values to
the defaults that were in the parameter file (as updated by Common). The
button DONE causes *xprompt* to exit. Use this when you have finished
entering values. The state of the output parameter file will correspond
to the state of the window when DONE is selected (assuming that RETURNs
have been typed as appropriate).

If the **-h** option was used, a HELP button is also provided. Selecting
it causes a help file to be displayed in a text window. If the
*help_name* specified with **-h** has a leading "." or "/", it is
interpreted as the path to a pure ASCII file containing help
information. If there is no leading "." or "/", *help_name* is
interpreted as the name of an ESPS program for which the parameters are
intended. In this case, HELP presents a copy of the corresponding ESPS
manual page in a text window. (To obtain it, *eman* is run and the
output is stripped of format control strings.) In both cases, the text
window includes a FIND button to facilitate string searching.

# OPTIONS

The following options are supported:

**-P** *param_file* **\[params\]**  
Specifies the name of the ESPS parameter file to process. If you want to
force the parameter to come only from ESPS common, use "**-P**
/dev/null".

**-n**  
Do not process ESPS Common (i.e., always get the parameter value from
the file specified by the **-P** option). (Within *xprompt*, the effect
of **-n** is to have *read_params* (3-ESPS) called with the SC_NOCOMMON
flag.) Note also that Common processing can also be disabled by setting
the unix environment variable USE_ESPS_COMMON to "off". It is an error
to specify both **-n** and **-c**.

**-c** *checkfile*  
If the ESPS Common file exists, this option specifies that the Common
file should be processed only if the *checkfile* matches the value of
the *filename* in the Common file. This option will have no effect if
the unix environment variable USE_ESPS_COMMON is "off". It is an error
to specify both **-n** and **-c**.

**-h** *help_name*  
Causes a HELP button to be provided in the *xprompt* window. Selecting
this button brings up a help file in a text window. If *help_name* has a
leading "." or "/", it is interpreted as the path to a pure ASCII file
containing help information. If there is no leading "." or "/",
*help_name* is interpreted as the name of an ESPS program for which the
parameters are intended. In this case, HELP presents a copy of the
corresponding ESPS manual page in a text window. (To obtain it, *eman*
is run and the output is stripped of format control strings.) In both
cases, the text window includes a FIND button to facilitate string
searching.

**-z**  
Specifies that *xprompt* operate silently; conditions such as "no
parameters" or "no indefinite paramters" are not reported.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *xprompt* outputs debugging messages. The
messages proliferate as *debug_level* increases. For level 0, there is
no output.

# ESPS PARAMETERS

The ESPS parameter file specified by the **-P** option is processed only
to obtain parameter specifications. In this respect, *xprompt* is quite
different from most other ESPS programs, which use the parameter file to
pass parameter values that control the operation of the program.

# ESPS HEADERS

No ESPS files are processed by *xprompt*.

# ESPS COMMON

Parameter processing by *xprompt* follows standard ESPS conventions:
Unless the parameter value is overridden by the value in ESPS Common,
the default value displayed by *xprompt* is the value from the parameter
file *param_file*. This default value will be overridden by the value in
Common (if the Common file exists and contains a value for the
parameter), provided that ESPS Common processing is enabled and that the
Common file is younger than the parameter file. If a *checkfile* is
specfied by means of the **-c** option, the parameter file value for
*param_name* will be overridden by the value in Common only if
*checkfile* is identical to the *filename* entry in the Common file.

ESPS Common processing is enabled unless the unix environment variable
USE_ESPS_COMMON is "off" or the **-n** is specified. The default ESPS
Common file is .espscom in the user's home directory. This may be
overridden by setting the environment variable ESPSCOM to the desired
path. User feedback from parameter and Common file processing (by the
library *read_params* and *getsym* functions) is determined by the
environment variable ESPS_VERBOSE, with 0 causing no feedback and
increasing levels causing increasingly detailed feedback. If
ESPS_VERBOSE is not defined, a default value of 3 is assumed.

It is an error to give both **-n** and **-c**.

# EXAMPLES

*Xprompt* is used to create parameter files interactively, with the
output file intended as the parameter file for some ESPS processing
program. This is particularly useful in writing shell scripts. For
example, the sequence


    	xprompt -h fft -P/usr/esps3/lib/Pfft fft.params
    	fft -P fft.params input.sd - | plotspec - 

will display a window in which the user fills in FFT parameters; after
the user clicks on DONE, the fft is performed and the results plotted.
Suppose the following script is called "xparam":


    	#! /bin/sh
    	xprompt -h $1 -P/usr/esps3/lib/P$1 temp.param
    	$1 -P temp.param $2 $3

    Then 

            xparam fft input.sd output.fspec

will result in the interactive execution of *fft* (1-ESPS). Thus,
"xparam" is the X Windows equivalent of *eparam* (1-ESPS). For an
alternative, see *xpromptrun* (1-ESPS).

# FUTURE CHANGES

*xprompt* will be modified to test whether or not it is being run under
X Windows; if not, the indefinite parameters will be determined by means
of prompts using stdin and stdout.

# SEE ALSO

*getparam* (1-ESPS), *espsenv* (1-ESPS), *read_params* (3-ESPS),
*xpromptrun* (1-ESPS)

# REFERENCE

"Parameter and Common Files in ESPS", ETM-S-86-12

# BUGS

Array parameters (float and int arrays) are not supported yet.

Data entry in any numeric or text field does not take effect until a
RETURN is typed; in a later version we will modify the action taken when
"Done" is selected to check and write all fields.

Vertical and horizontal scrollbars are provided (their use may be
necessary in the case of large parameter files). Owing to bugs in the
current version of the xview library, however, their behavior is not
reliable. For example, joining a split vertical scrollbar can cause a
core dump.

# AUTHOR

Manual page and code by John Shore.
