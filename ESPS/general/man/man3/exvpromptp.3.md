# NAME

    exv_prompt_params - fill in a parameter file using X-Windows prompting form

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/exview.h>

    extern int debug_level;

    exv_prompt_params(param_file, flag, check_file, outfile, program, x_pos, y_pos)
    char *param_file;	
    int flag;		
    char *check_file;
    char *outfile;		
    char *program;		
    int x_pos, y_pos;	

# DESCRIPTION

*exv_prompt_params* provides for the interactive specification of
parameter files used by ESPS programs.

*exv_prompt_params* processes an input parameter file *param_file*, and
produces an output parameter file *outfile*. The definite parameters in
*param_file* are copied to *outfile*. An X-Windows prompt form is
displayed containing items for each of the indefinite parameters in
*param_file*. For each item, the prompt string, name, and default value
are shown. Users can change any of the values. When the "Done" button is
pressed, the current set of values are added to *outfile* and
*exv_prompt_params* returns.

IF numerical limits are included in *param_file*, these limits are
enforced by *exv_prompt_params*. If string choices are included in
*param_file* for string items, the interactive display for that item
consists of mutually-exclusive push-buttons labelled with the string
choices (otherwise, there's just a text entry item). See *read_params*
(3-ESPS) for details about the *param_file* format.

*exv_prompt_params* uses *read_params* (3-ESPS) to read in *param_file*.
The parameters *flag* and *check_file* are passed directly to
*read_params*; thus, if flag is SC_CHECK_FILE, if an ESPS Common file
exists, and if Common processing is enabled (see ESPS COMMON, below),
then the Common file is processed if *check_file* matches the value of
the filename entry in the Common file or if *check_file* is NULL. If a
Common file is processed, *read_params* compares the last modification
time of the ESPS Common and *param_file*. The parameter values in the
younger of the two files takes precedence. Parameter values not
occurring in the ESPS Common file are read from *param_file*. Note that,
in the case of indefinite assignment ("?=" or "=?" used as the
assignment operator in the parameter file), Common processing will still
occur for the assigned default value. If the value from Common takes
precedence, it will be this value that is shown as the default in the
*exv_prompt_params*

If *program* is not NULL, a "Help" button is included in the display
window. If *program* doesn't contain a path specification (i.e., doesn't
contain a "/"), it is assumed to name an ESPS program corresponding to
*param_file*. In this case, pressing "Help" brings up a window with the
output of "eman program" - see *eman* (1-ESPS). If *program* contains a
"/", pressing "Help" just brings up the contents of the file *program*.

If *x_pos* and *y_pos* are not zero, they are used to hints to the
window manager for the position the prompt window. Otherwise, the
position is left to the window manager. Whether or not the window
manager follows the hints varies with window managers. For example,
*olwm* does so by default, but *twm* will only do so if


    	UsePPosition "on"   # use program-specified size hints

is contained in the user's .twmrc (Otherwise, window placement requires
user-interation.)

The display window contains a "Defaults" button which, if pressed,
restores all parameter values to the defaults in *param_file* or ESPS
Common.

*exv_prompt_params* returns 0 if the parameter file was read
successfully, the user exited via the "DONE" button, and all parameters
were written successfully. If there was trouble processing the input
parameter file, *exv_prompt_params* returns 1. If the user exits via the
"DONE" button but the parameters were not written successfully,
*exv_prompt_params* returns 2. If *exv_prompt_params* exits for other
reasons, it returns 3; the most common reasons reasons are inability to
create a window in the first place, a window-manager quit operation, or
an explicit kill signal.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. If ESPS_VERBOSE is
set to 1 or greater, *read_params* will report the values of any
parameters take from Common.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

Suitable error messages are printed if the return value is -1. If
*debug_level* \> 0, various debugging messages are printed. More details
are printed as *debug_level* increases (maximum is 3).

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

*exv_make_text_window* (3-ESPSxu), *exv_helpfile* (3-ESPSxu),
*exv_make_text_window* (3-ESPSxu), *exv_bbox* (3-ESPSxu), *exprompt*
(1-ESPSxu), *expromptrun* (1-ESPS)

# AUTHOR

Program and documentation by John Shore
