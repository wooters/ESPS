# NAME

    meter - a control panel for ESPS A/D recording programs

# SYNOPSIS

**meter** \[ **-i** *update_time* \] \[ **-c** *RC_const* \] \[ **-s**
\] \[ **-m** \] \[ **-r** \] \[ *-* \] *outfile*

# DESCRIPTION

*Meter* is a front-end program to be used with any ESPS recording
program to control its recording process and to visually monitor input
signal amplitude in decibels. Input to *meter* is always the standard
input which may be optionally specified on the command line as "-"
before the output file name *outfile*. If *outfile* is "-", standard
output is written.

*Meter* is a X-window based program compiled for the Motif version 1.1.3
and X11R4. When executed, the program pops up a panel with the following
control and monitoring featurers:

A "Start/Restart" pushbutton to start and restart the recording. Input
to *meter* will not be written out to *outfile* unless the "Start" push
button is activated. Activating the button after the first time will
cause the file stream pointer to rewind and rewrite to *outfile*, thus
restarting the recording process. A message of "Recording...." is shown
on the panel while writing to *outfile* is in progress.

A "Pause/Resume" pushbutton to pause and resume the recording. A message
of "Recording...." is shown on the panel while writing to *outfile* is
in progress.

Two input dB-level meters representing channel 1 and channel 2. Each
meter gives a visual indication of input dB level by means of a rising
and falling green bar with grey background along with its numerical
readout. If the input dB level exceeds 90 dB, then the top region of
meter, normally black, turns into red color to indicate that signal
clipping has occured and input signal amplitude should be turned down.
An additional falling thin green line indicates the decay of the last
maximum input value with an exponential rate of *-RC_const*. By default,
the meter display updates every 0.1 second, but changeable by the **-i**
option. Input is always assumed to be the data type SHORT. The top
region of the meter become red in the event of clipping.

Three toggle buttons: A "DC-offset" toggle button to remove DC component
of input signal before writing to *outfile*, a "meter" toggle button to
disable the meter display, and a "meter db readout" toggle button to
disable the numerical dB value readout.

A "Stop/Quit" button to exit the program. When this button is pressed,
*meter* closes input and output file stream pointers, this may cause
ESPS recording program to display a write-error message since it can no
longer write to standard output. Ignore the message in such case.

The success of executing the program depends on the CPU load of the
machine. If *meter* can not keep up with the input, an error message
from the recording program is displayed to standard error, and the
recording process halts. In such cases, decrease the CPU load by killing
other jobs on the machine, increasing the time interval between meter
display updates by the **-i** option, or turning "DC-offset", "meter",
or "meter db readout" toggle button to off.

# OPTIONS

The following options are supported:

**-i** *update_time \[0.1\]*  
*Meter* updates its display every *update_time* second. *update_time* is
in increment of 0.1 seconds. The smallest value is 0.1.

**-c** *RC_const \[0.1\]*  
The falling exponential rate of the thin green line. This must be a
non-negative number. At each display update, the green line has the dB
value of the previous maximum input level times *exp(RC_const\*time)*,
where *time* is the elapsed time since the last maximum occured.

**-s**  
To set the default state of "DC-offset" toggle button from OFF to ON.
*Rem_dc (1-ESPS)* may also be used to remove the DC component in the
signal after the recording is done.

**-m**  
To set the default state of "meter" toggle button from ON to OFF.

**-r**  
To set the default state of "meter db readout" toggle button from ON to
OFF.

# ESPS PARAMETERS

No ESPS parameter file processing is supported.

# ESPS COMMON

No ESPS common parameter processing is supported.

# ESPS HEADERS

ESPS header from the standard input is copied to *outfile* without
change.

# EXAMPLES

The following monitors signal input level of Sun Sparc 8-bit mu-law A/D
converter.

srecord - \|Meter /dev/null  

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

# SEE ALSO

rem_dc (1-ESPS), v32record (1-ESPS), c30record (1-ESPS), s32crecord
(1-ESPS), srecord (1-ESPS), sgrecord (1-ESPS)

# AUTHOR

Derek Lin
