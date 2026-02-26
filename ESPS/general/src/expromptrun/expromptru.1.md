# NAME

expromptrun - run ESPS program after interactive parameter entry in a
pop-up window

# SYNOPSIS

**expromptrun** \[ **-P** *param_file* \] \[ **-n** \] \[ **-c**
*checkfile* \] \[ **-h** *help_name* \] \[ **-z** \] \[ **-X** *x_pos*
\] \[ **-Y** *y_pos* \] \[ **-x** *debug_level* \] command_line

# DESCRIPTION

*Expromptrun* is an X Windows program that displays an interactive form
for entering ESPS parameters, and then runs the corresponding ESPS
program. It is closely related to *exprompt* (1-ESPS), which just
prompts for parameters and produces a parameter file for subsequent use.

It is assumed that *command_line* is a full command line for an ESPS
program (including command line options and file names), with the
exception that the standard ESPS **-P** option is *not* included. A
suitable **-P** option will be inserted by *expromptrun*.

*Expromptrun* processes the ESPS parameter file *param_file* and
(optionally) ESPS Common. It then pops up a window containing an entry
for each of the indefinite parameters in *param_file* (parameters with
values assigned using the "?=" operator). Each such entry has the name
of the parameter and a space for filling in the desired value. Default
values from the parameter file are filled in initially. If a prompt
string was included in the parameter file, the string is displayed above
the corresponding parameter entry.

If the parameter definition in *param_file* includes the optional set of
discrete choices, the window entry for the parameter contains a set of
screen buttons, one for each choice - the user selects the parameter
value by clicking with the mouse on the desired choice. If discrete
choices were not provided in the parameter file, the window entry for
the parameter contains space in which the user can type the desired
value.

Before displaying the interactive window, *expromptrun* creates a
temporary parameter file to record the user's parameter entries; this
temporary parameter file will be used subsequently in running
*command_line*. If the environment variable ESPS_TEMP_PATH is defined,
it will be used as the location for the temporary parameter file.
Otherwise, a compiled in default (usually /usr/tmp) will be used. When
*expromptrun* first creates the temporary parameter file, it fills it
with definitions for all of the parameters in *param_file* and ESPS
Common (if Common is processed). The initial values are the default
values from *param_file*, perhaps modified by Common processing.

Whenever the user enters a valid new value for a parameter in the
*expromptrun* window, the temporary parameter file is updated. Note that
that data entry requires that a RETURN by typed at the end of the entry
string. Input parameters are checked for data type format. If limits are
provided for numeric parameters in the parameter file, the limits are
checked.

Two or three screen buttons are provided in a panel at the top of the
*expromptrun* window. The button DEFAULTS reverts all parameter values
to the defaults that were in the *param_file* (as updated by Common).
The button DONE causes *expromptrun* to exit. Use this when you have
finished entering values. The state of the temporary output parameter
file will correspond to the state of the window when DONE is selected
(assuming that RETURNs have been typed as appropriate).

If the **-h** option was used, a HELP button is also provided in the
parameter prompting window. Selecting it causes a help file to be
displayed in a text window. If the *help_name* specified with **-h** has
a leading "." or "/", it is interpreted as the path to a pure ASCII file
containing help information. If there is no leading "." or "/",
*help_name* is interpreted as the name of an ESPS program for which the
parameters are intended. In this case, HELP presents a copy of the
corresponding ESPS manual page in a text window. (To obtain it, *eman*
is run and the output is stripped of format control strings.) In both
cases, the text window includes a FIND button to facilitate string
searching.

After the user exits the parameter prompt window (by clicking on DONE),
*expromptrun* builds a new command line from *command_line* by inserting
a **-P** after the first item in *command_line* (which is assumed to be
a program name). The temporary parameter file created by *expromptrun*
is used as the argument for the new **-P** option. The new command line
is then executed via *system*(3). When *expromptrun* terminates in this
case, the exit status is that of the command run.

Note that *expromptrun* does not terminate until after the command
generated from *command_line* has completed running. This makes
*expromptrun* more useful in scripts and as a command tied to *xwaves*+
menus. The temporary parameter file is deleted before a normal exit from
*expromptrun*.

If the temporary file was not created properly, *expromptrun* exits
without attempting to run the *command_line*. In this case, if there was
trouble processing the input parameter file, *expromptrun* exits with
status 1. If the user exits via the "DONE" button but the parameters
were not written successfully, *expromptrun* exits with status 2. If the
parameter prompt window exits for other reasons, the exit status is 3;
the most common reasons are inability to create a window in the first
place, a window-manager quit operation, or an explicit kill signal.

# OPTIONS

The following options are supported:

**-P** *param_file* **\[params\]**  
Specifies the name of the ESPS parameter file to process. If you want to
force the parameter to come only from ESPS common, use "**-P**
/dev/null".

**-n**  
Do not process ESPS Common (i.e., always get the parameter value from
the file specified by the **-P** option). (Within *expromptrun*, the
effect of **-n** is to have *read_params* (3-ESPS) called with the
SC_NOCOMMON flag.) Note also that Common processing can also be disabled
by setting the unix environment variable USE_ESPS_COMMON to "off". It is
an error to specify both **-n** and **-c**.

**-c** *checkfile*  
If the ESPS Common file exists, this option specifies that the Common
file should be processed only if the *checkfile* matches the value of
the *filename* in the Common file. This option will have no effect if
the unix environment variable USE_ESPS_COMMON is "off". It is an error
to specify both **-n** and **-c**.

**-h** *help_name*  
Causes a HELP button to be provided in the *expromptrun* window.
Selecting this button brings up a help file in a text window. If
*help_name* has a leading "." or "/", it is interpreted as the path to a
pure ASCII file containing help information. If there is no leading "."
or "/", *help_name* is interpreted as the name of an ESPS program for
which the parameters are intended. In this case, HELP presents a copy of
the corresponding ESPS manual page in a text window. (To obtain it,
*eman* is run and the output is stripped of format control strings.) In
both cases, the text window includes a FIND button to facilitate string
searching.

**-z**  
Specifies that *expromptrun* operate silently; conditions such as "no
parameters" or "no indefinite parameters" are not reported.

**-X** *x_pos*  
Specifies the x-position (in the root window) of the frame displayed by
*expromptrun*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-Y** *y_pos*  
Specifies the y-position (in the root window) of the frame displayed by
*expromptrun*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *expromptrun* outputs debugging messages.
The messages proliferate as *debug_level* increases. For level 0, there
is no output.

# ESPS PARAMETERS

The ESPS parameter file specified by the **-P** option is processed only
to obtain parameter specifications. In this respect, *xpromptrun* is
quite different from most other ESPS programs, which use the parameter
file to pass parameter values that control the operation of the program.

# ESPS HEADERS

No ESPS files are processed by *expromptrun*.

# ESPS COMMON

Parameter processing by *expromptrun* follows standard ESPS conventions:
Unless the parameter value is overridden by the value in ESPS Common,
the default value displayed by *expromptrun* is the value from the
parameter file *param_file*. This default value will be overridden by
the value in Common (if the Common file exists and contains a value for
the parameter), provided that ESPS Common processing is enabled and that
the Common file is younger than the parameter file. If a *checkfile* is
specified by means of the **-c** option, the parameter file value for
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

This computes a spectrogram after prompting for all parameters but
*start* and *nan*:


    	expromptrun -h sgram -P$ESPS_BASE/lib/params/PWsgram \
    	     sgram -r1:2000 speech.sd speech.sd.fspec

# FUTURE CHANGES

# SEE ALSO

*xeparam* (1-ESPS), *eparam* (1-ESPS),\
*exprompt* (1-ESPS), *getparam* (1-ESPS),\
*espsenv* (1-ESPS), *read_params* (3-ESPS),\
*exv_prompt_params* (3-ESPSxu)

# REFERENCE

"Parameter and Common Files in ESPS", ETM-S-86-12

# BUGS

Array parameters (float and int arrays) are not supported yet.

Vertical and horizontal scrollbars are provided (their use may be
necessary in the case of large parameter files). Owing to bugs in the
current version of the xview library, however, their behavior is not
reliable. For example, joining a split vertical scrollbar can cause a
core dump.

# AUTHOR

Manual page and code by John Shore.
