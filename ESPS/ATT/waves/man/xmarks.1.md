# NAME

xmarks - assign times to previously labeled events (attachment for
xwaves)

# SYNOPSIS

**xmarks** \[ **-c** *host_X_registry* \] \[ **-n** *host_name* \] \[
**-w** *wave_pro* \]

# DESCRIPTION

*xmarks* is an *attachment* for the program *xwaves*(1-ESPS): a program
that runs in close cooperation with *xwaves* and provides additional
capabilities. *xmarks* facilitates aligning pre-defined label sequences
with waveforms displayed in *xwaves* windows. This manual entry briefly
describes *xmarks* but is not intended to be a complete *xmarks* manual.
For full details, see the chapter in *waves+ Manual* and the chapters
and in *waves+ Reference*. Also see *waves+ Manual* and *waves+
Reference* for information about *xwaves.*

## Introduction

An attachment is a program that extends the capabilities of *xwaves*
while running as a separate UNIX process. Attachments exchange
information with *xwaves* by communicating through the X server, using a
communication protocol that is compatible with Tcl/Tk.

*xmarks,* an *xwaves* attachment, is specialized for assigning times in
waveforms to pre-defined label sequences. It is specifically designed
for labeling speech in that it supports labeling of sentence-like
structures. Labels are supplied in a specific format in a file created
before running the attachment. *xmarks* allows you to place labels
quickly by clicking the middle mouse button in the signal window.
*xmarks* automatically selects the next label to be placed.

If the sequence of labels to be applied is not known in advance, the
attachment *xlabel*(1-ESPS) is a better choice.

*xmarks* creates two windows in addition to those that *xwaves* creates:
a control window and a label display window. These are described below.

## Starting xmarks

Most attachments are activated by selecting their names in the *xwaves*
control panel item **Attach:** or by using the *xwaves* command
*attach.* This can be done with *xmarks* as well, but it is not
recommended. *xmarks* is best used by running a shell script like the
one below.

If you use **Attach:** to start *xmarks,* keep in mind that *xmarks* is
sensitive to the order in which input files are specified, and files
must be specified by using the **COMMAND:** item in the *xwaves* control
panel or through a series of *send_xwaves* commands. First *xmarks* must
be attached to *xwaves,* then the input waveform displayed, then the
object name must be transmitted to the *xmarks* attachment, and finally
the input ASCII label-sequence file must be transmitted to *xmarks.*
When finished marking, you must tell *xmarks* to write the output file.
Failure to do these steps in the proper order results in unpredictable
results, and this is the reason that *xmarks* should be run by using a
shell script.

The script below is the *xmarks.sh* script. It can be found in
*\$ESPS_BASE/lib/waves/files .* It starts *xwaves,* attaches *xmarks,*
and displays the data file. To run this script, copy it to a directory
in which you have write permission, name it *xmarks.sh,* make sure it is
executable (*chmod u+x xmarks.sh*), and type its name followed by an
input waveform filename and an input ASCII label-sequence file to be
marked.

> #!/bin/sh
>     WAVEFORM=$1
>     LABELSEQ=$2
>     #
>     xwaves &
>     send_xwaves attach function xmarks
>     send_xwaves set middle_op "blow up; function"
>     send_xwaves make name $WAVEFORM file $WAVEFORM \
>     				loc_y 350 height 200 loc_x 0
>     send_xwaves send make name $WAVEFORM
>     send_xwaves send read file $LABELSEQ
>     send_xwaves pause
>     send_xwaves send write file $LABELSEQ.mark
>     send_xwaves quit
>     #

In the chapter of *waves+ Manual* is another shell script, which uses
*xmarks* for a real speech database segmenting task. The command
sequence is similar to the one above, but a spectrogram is also
displayed time-aligned with the waveform. The script will process
several files in sequence.

These scripts demonstrate some of the ways that *xwaves* and *xmarks*
can be controlled from UNIX shell scripts.

## The label file

*xmarks* reads an ASCII input file containing event labels and optional
times. It writes an ASCII file containing the input event labels with
times added or adjusted by user interaction. Here is an example of an
input file:

> ** This was easy for us.
>     This	"Dis
>     	D_release
>     	s_start
>     	s_end
>     was	"w^z
>     	z_start
>     	z_end
>     easy	"EzE
>     	z_start
>     	z_end
>     for	"f>r
>     	f_start
>     	f_end
>     	r_F3_min
>     us.	"^s
>     	s_start
>     	s_end

There are three levels of description:

1)  A "sentence level" description of the event sequence. In this case
    it corresponds to a sequence of English words. It is indicated by
    the line beginning with "\*\*".

2)  The "word level" description, indicated by a line beginning with
    anything other than "\*\*" or white space.

3)  The "segment level", or the level at which the actual boundary
    positioning is to occur. Any number of these segments, or
    sub-events, indicated by leading white-space, can comprise a "word".
    In this example, only selected events within the word are being
    labeled. The operator's task was to mark the time location of these
    selected events. The phonetic symbols (*w^z,* *EzE,* etc.) to the
    right of the words in this example are optional; they may be in the
    file, but they play no active part in the labeling process.

The output of *xmarks,* after marking the events, looks like the
following:

> ** This was easy for us.
>     This	"Dis
>     		D_release	0.35825
>     		s_start	0.431
>     		s_end	0.56925
>     was	"w^z
>     		z_start	0.644875
>     		z_end	0.716125
>     easy	"EzE
>     		z_start	0.843375
>     		z_end	0.931625
>     for	"f>r
>     		f_start	0.999
>     		f_end	1.115
>     		r_F3_min	1.1965
>     us.	"^s
>     		s_start	1.35125
>     		s_end	1.5945

The output file resembles the input file with the time (in seconds)
added to each event that was processed by the operator. An "output"
file, like the one above, could also serve as an input file for
*xmarks,* should it be necessary to adjust time boundaries, rather than
create them. Assuming the script *xmarks.sh* (described above) was used,
the name of the output file is the input file name with a ".mark"
extension added to it.

When things are set up right, *xmarks* requires only one
mouse-button-press per event; a skilled user can achieve average rates
of 10-20 events per minute, making it possible to segment fairly large
data bases in moderate time.

## The control window

The *xmarks* control window shows the current "sentence", the current
"word", and the names of the segment marks for that word. It can be
moved to any convenient location on the screen. The current mark is
shown in boldface print.

The control window has a number of buttons that give the user additional
control over the marking operation. Most are self-explanatory.

**Quit**  
Terminates execution (without writing an output file).

**NextWord**  
Makes the next word the current word.

**LastWord**  
Makes the previous word the current word.

**NextMark**  
Makes the next mark the current mark.

**LastMark**  
Makes the previous mark the current mark.

**ChangeMark**  
Lets you edit the string that is the current mark.

**Where?**  
Selects whether a mark added with the button **AddMark** will be added
before or after the current mark.

**AddMark**  
Splices a new mark into the list, either *before* or *after* the current
mark, as indicated by the **Where?** item.

**UnSet**  
Removes the time assignment from the current mark.

**Delete**  
Excises the current mark from the list.

Setting a time twice on one label simply replaces any previous time.

## The label display window

The *xmarks* label window is time-aligned with the newest *xwaves*
window. Marks are displayed in it as vertical bars, and the names,
corresponding to the segment labels from the input file, are printed
just to the left of the bars. If the *xwaves* window is moved or zoomed,
this window adjusts itself accordingly. A mark is only visible if it has
been assigned a time. The current mark has a different color from the
others.

## Placing marks

Event marks can be set in two ways: by selecting the *xmarks* menu item
in the *xwaves* main menu, or by using the middle button option **blow
up; function** on a waveform type of display. (This middle-button
operation magnifies the region in time while the button is depressed.
This allows more accurate placement of the cursor. The mark is actually
placed when the middle mouse button is released.) In either case, the
current mark is assigned the indicated time, and the next mark becomes
current.

After marking all the data using the *xmarks.sh* script, left
mouse-click on the **CONTINUE** button in the *xwaves* panel. This
closes the marker display file, writes the ASCII output file, and exits
*xwaves.* The marked output file has the same name as the ASCII input
file, but with a ".mark" extension added. Note that the *xwaves* command
*detach* will also cause the output file to be written before *xmarks*
exits.

## xmarks symbols

*xmarks* has no specific symbols.

## xmarks commands

*xmarks* has a limited command set. The specific commands are described
in the chapter of *waves+ Reference*.

# OPTIONS

*xmarks* is usually started as a subordinate program by *xwaves.* In
this case, you need not be concerned with the command-line options
presented below, and you may skip this section. You need to know about
the options only when you want to run *xmarks* directly from the command
line. We don't recommend that you do this, however.

**-c** *host_X_registry*  
This is the name that the host program is registered under for X
server-based communications. This option is intended to be supplied by
*xwaves* when it runs *xmarks.*

**-n** *host_name*  
This is the name of the program object with which *xmarks* will be
communicating. When the host program is *xwaves,* this name is always
the default value, "waves".

**-w** *wave_pro*  
Specifies the startup profile to read. This option is always used when
*xmarks* is invoked by *xwaves,* in which case the specified profile is
a temporary file written by *xwaves* and containing the current state of
the *xwaves* globals. If **-w** is not used (only possible if *xmarks*
is run from the shell), *xmarks* attempts to read the file *.wave_pro.*
In both cases the search path *\$HOME:\$ESPS_BASE/lib/waves* is used.
The search path used can be overridden by setting the UNIX environment
variable WAVES_PROFILE_PATH before starting *xwaves.*

# BUGS

*xmarks* is not robust to extreme string lengths, bad file formats, etc.
If used carefully, it works very well, but it dumps core if not treated
with respect.

# SEE ALSO

*waves+ Manual*,\
*waves+ Reference*,\
*Introducing waves+*,\
*formant*(1-ESPS), *select*(1-ESPS), *xcmap*(1-ESPS),\
*xlabel*(1-ESPS), *xspectrum*(1-ESPS), *xwaves*(1-ESPS)

# AUTHOR

Original program by Mark Liberman and Mark Beutnagel at AT&T Bell
Laboratories. Later revisions by David Burton, Rod Johnson, Alan Parker,
David Talkin, and others at Entropic. Cover script by David Burton. This
manual page largely extracted by Rod Johnson from *waves+ Manual*, based
on Mark Liberman's documentation, with edits and additions by David
Burton, Joop Jansen, David Talkin, and others at Entropic.
