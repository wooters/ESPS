# NAME

erldemo - X-Windows control panel for waves+ and ESPS demos

# SYNOPSIS

**erldemo** \[ **-m** *io_type* \] \[ **-s** \] \[ **-W** *wavesintro*
\] \[ **-S** *slideshow* \] \[ **-T** *trywaves* \] \[ **-I**
*more_info_file* \] \[ **-A** *about_file* \] \[ **-t** *window_title*
\] \[ **-X** *x_loc* \] \[ **-Y** *y_loc* \] \[ **-x** *debug_level* \]

# DESCRIPTION

*erldemo* puts up an X-Windows control panel from which one can run
various demos of ESPS and *waves*+. The panel is divided into two areas.
In the top area there are three screen buttons: one causes the display
of a text file describing the demos, another causes the display of a
text file providing some general information about ESPS and *waves*+
(including information about how to contact ERL), and the third causes
*erldemo* to exit.

The bottom area of the control panel has controls the demos themselves.
There are two basic choices: an automated demo of *waves*+ and ESPS
(often referred to as the "demo"), and a limited but interactive test of
*waves*+ itself (often called the "*waves*+ tryout".

The automated demo is started by the screen button "Start demo". Whether
it runs once or continuously is determined by the state of push-buttons
on the right side of the control panel (under "Demo options:"). The demo
consists of one or both of two parts. The first part is an an
introduction to *waves*+, and it consists of *waves*+ itself running
"live" on a series of command files. The second part is a series of
static images (the "slide show") that illustrate various aspects of ESPS
and *waves*+. Two "check boxes" under the "Demo options:" portion of the
control panel determine whether the demo consists of the *waves*+
introduction, the slide show, or both. The commands called by *erldemo*
to implement these two parts are determined by the **-W** and **-S**
options. At least one of these must be provided, and in most cases both
are. If one or the other is not provided, *erldemo* will disable the
corresponding choice (e.g., for a demo on a monochrome display, the
slide show may be disabled).

All of the controls under "Demo Options:" and "Audio Output:" can be
operated while the demo is running. For example, switching from
"continuous" to "single" while the demo is running, will cause the demo
to stop after the current loop (the label of the "single" button changes
in this context). If the exit button is "pressed" while a demo is
running, *erldemo* will exit immediately and the demo will exit as soon
as practicable. In particular, the demo will exit at the end of the
*waves*+ portion or slide show portion (whichever comes first). If it is
the *waves*+ that is running, the user can achieve a faster exit by
clicking on QUIT from the *waves*+ command window.

The *waves*+ tryout is started by the screen button "Interactive waves".
It causes *waves*+ to run on a command file that opens various display
windows and then pauses to allow the user to interact. Interactions are
limited (for example, no files can be written), but the user should be
able to explore basic *waves*+ capabilities. The *waves*+ is terminated
by the user when desired, by clicking on QUIT in the *waves*+ command
window. The command run by *erldemo* to implement the *waves*+ tryout is
determined by the **-T** option. If it isn't supplied, the corresponding
screen button is disabled (pressing it yields a suitable message).

Both the demo and tryout provide explanatory audio output if the
supported by the machine hardware. The relevant output options are
controlled by the "Audio Output" push buttons.

The contents of the demo and *waves*+ tryout are not determined by
*erldemo*, rather *erldemo* accepts via the **-W**, **-S**, and **-T**
options the names of three shell scripts that respectively are assumed
to implement the live *waves*+ introduction, the slide show, and the
*waves*+ tryout. These scripts are not invoked directly by *erldemo*.
Rather, they are invoked indirectly by means of the following three
fixed shell scripts that *erldemo* uses for demo control:

**one_demo.sh**  
This implements a single run of the demo consisting of one or both of
the *waves*+ introduction and the slide show. It runs one or both of the
scripts passed via **-W** and **-S**.

**erldemo.sh**  
This top level demo script invokes one_demo.sh once or continuously
(until the single demo mode is set).

**erlwtry.sh**  
This script runs the *waves*+ tryout by running a copy of the script
passed via **-T** (if that option is supplied).

These three scripts should not be edited or replaced (except as part of
maintenance of *erldemo*). Customization of the demo is intended to take
place via the three scripts passed via the **-W**, **-S**, and **-T**
options.

*erldemo* does not assume that the user has write-permission anywhere
other than in /tmp. Demo control is implemented by means of lock files,
indicator (flag) files, and script links that are placed in /tmp.
Logging information (including stdout and stderr output) is directed to
/tmp/erldemo.log; this log file is cleared at the start of each demo
loop. If you would like the log output to appear in the window from
which *erldemo* was called, temporarily edit erldemo.sh and erlwtry.sh
(see the comments in these scripts).

# OPTIONS

The following options are supported:

**-m** *io_type \[sun_sparc\]*  
Causes slightly different options to come up under the "Audio Output:"
portion of the control panel. Possible (case-insensitive) values are
"sun_sparc", "sun_vme", "masscomp", "sony", "network", and "none". For
example, "**-m** sun_sparc" results in control panel choices for
SPARCstation internal speaker, SPARCstation external speaker, or no
output (silent demo). Each time one of these is pressed, *erldemo* links
an appropriate command to /tmp/play, which is the actual play command
used by all the demos. The mosts generic choice is "network", which
should be used if the other cases do not apply. In this case, *erldemo*
uses the script play_script/play.net, which can be adjusted as
appropriate. See also **-s**.

**-s**  
Forces silent demos. In this case *erldemo* refuses to allow any other
button but "None" to be pressed under "Output Options:". Note that this
behavior is different from that obtained with "**-m** none", which
inhibits the "Output Options:" list entirely.

**-W** *wavesintro*  
Specifies the command to be run for the introductory *waves*+ demo. At
least one of **-W** and **-S** must be supplied.

**-S** *slideshow*  
Specifies the command to be run for the slide show. At least one of
**-W** and **-S** must be supplied.

**-T** *wavestry*  
Specifies the command to be run for the interactive *waves*+ tryout.
This option must be supplied.

**-I** *more_info_file \[edemo.info\]*  
Specifies the text file to be associated with the screen button "For
more information...".

**-A** *about_file \[edemo.about\]*  
Specifies the text file to be associated with the screen button "About
this demo...".

**-t** *window_title \[Entropic Demo\]*  
Specifies a title for the *erldemo* command window.  
**-X** *x_loc \[670\]*  
Specifies the x-coordinate (in pixels) of the upper left corner of the
command window.

**-Y** *y_loc \[0\]*  
Specifies the y-coordinate (in pixels) of the upper left corner of the
command window.

**-x** *debug_level \[0\]*  
Values other than 0 result in debugging output; higher values provide
more output.

# ESPS PARAMETERS

The ESPS parameter file is not read by *erldemo*.

# ESPS HEADERS

No ESPS files are processed by *erldemo*.

# ESPS COMMON

ESPS Common is neither read nor written by *erldemo*.

# SEE ALSO

*xwaves+* (1-ESPS), *xloadimage* (1-ESPS)

# FILES

Besides the commands passed via the options, *erldemo* requires the
presence of the three scripts: erldemo.sh, one_demo.sh, and erlwtry.sh.
Various files are placed in /tmp to control the operation of the demo.
Logging info is sent to /tmp/erldemo.log; this log file is cleared at
the start of each demo loop.

# BUGS

Only one copy of erldemo can run at a time (if they share the same /tmp
file system). This is due to clashes in the temporary files. It should
be changed at some point.

# AUTHOR

Manual page and code by John Shore.
