# NAME

xtext - popup X window containing text file or output of any
text-producing command

# SYNOPSIS

**xtext** \[ **-t** *window_title* \] \[ **-i** *icon_title* \] \[
**-F** *file_name* \] \[ **-L** \] \[ **-x** *debug_level* \]
*command_line*

# DESCRIPTION

*xtext* assumes that *command_line* is a full unix command line for any
program that produces ASCII text output. *xtext* runs the
*command_line*, puts the output into a temporary file, and pops up an X
Window containing the file contents. The resulting window is scrollable
and includes a "find" button to facilitate browsing. The window can be
split horizontally (with independent scrollbars). Unless the **-L**
option is used, *xtext* will delete the temporary file when it exits.
The temporary file is by default located in /usr/tmp, but this location
can be changed by setting the *unix* environment variable
ESPS_TEMP_PATH.

The **-F** option permits the display of an existing text file (rather
than of the output from *command_line*. If this option is used, the
*command_line* cannot be given, and the **-L** option has no effect
(i.e., the file is never deleted).

The window and icon titles can be set directly via the **-t** and **-i**
options. The default titles depend on on whether or not the **-F**
option is used; if **-F** is used, the default window and icon titles
are both set to *file_name*; if **-F** is not used, the default window
title is set to the *command_line* followed by the temporary file name
(in parentheses), and the default icon title title is set to the first
item in the *command_line* (usually the name of the program being run
from within *xtext*).

Window position can be specified by means of the the standard XView
**-Wp** and standard X11 **-geometry** options.

*xtext* can be used in shell scripts to provide window-oriented displays
to the user.

# OPTIONS

The following options are supported:

**-t** *window_title*  
Specifies that the string *window_title* be used in the title bar of the
displayed window.

**-i** *icon_title*  
Specifies the title to use for the window icon.

**-F** *file_name*  
Specifies that the contents of the existing file *file_name* should be
displayed (rather than of the output from *command_line*). If this
option is used, the *command_line* cannot be given. The *file_name* may
be a full path or a partial path relative to the current directory. If
*unix* environment variables are contained in the path (e.g., \$HOME),
they are expanded properly. If \$ESPS_BASE appears in the path and is
not defined as an environment variable, it is expanded automatically to
the to base ESPS directory (same one as found by *get_esps_base*
(1-ESPS)).

**-L**  
Specifies that the temporary file (containing the *command_line* output)
be left in place. (Note that the file name is given in the default
window title.) This option has no effect if **-F** is used.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *xtext* outputs debugging messages. The
messages proliferate as *debug_level* increases. For level 0, there is
no output.

# ESPS PARAMETERS

The ESPS parameter file is not read by *xtext*.

# ESPS HEADERS

No ESPS files are processed by *xtext*.

# ESPS COMMON

ESPS Common is neither read nor written by *xtext*.

# EXAMPLES

The command


    	%xtext psps -lD foo.fea

will run *psps* (1-ESPS) on the file foo.fea and put up a long listing
of the header in a text window. Similarly,


    	%xtext -t foo.fea fea_stats foo.fea

will pop up the results of running *fea_stats* (1-ESPS). The file name
is used in this case as the icon title. The command


    	%xtext psps -F $HOME/.wave_pro

will pop up the *waves* profile from the user's home directory.

Note that aliases provide a convenient means of providing versions of
ESPS text-producing programs psps that always pops up the results in a
window, for example:


    	%alias pspstool xtext psps 
    	%pspstool foo.fea

If you are running under Sun\`s OpenWindows and the *filemgr*, it can be
convenient to use the *binder* so that "xtext psps -lD" is bound to
certain file name patterns. This yields the header in a pop-up window
when you double click on the file's icon.

# SEE ALSO

*exprompt* (1-ESPS), *xwaves* (1-ESPS), *psps* (1-ESPS), *fea_stats*
(1-ESPS)

# AUTHOR

Manual page and code by John Shore.
