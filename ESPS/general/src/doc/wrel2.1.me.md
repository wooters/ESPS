*(x)waves*+ Version 2.1 Release Notes

Document version: 1.25 11/7/91

This document provides notes relevant to release 2.1 of *waves*+ and
*xwaves*+. This note documents changes to *waves*+ and *xwaves*+ since
the revision 2.0c. This document can be viewed conveniently using
*winfo* (1-ESPS) or *eversion* (1-ESPS).

Version 2.1 exploits various new items from the .wave_pro file.


          It is important that all users delete or move any .wave_pro 
          file from their home directory before using Version 2.1.
          Old .wave_pro files will not enable many of the new features
          now available in (x)waves.

Personal preferences from old .wave_pro files should be merged into a
fresh .wave_pro starting from a copy of \$ESPS_BASE/lib/waves/.wave_pro
(which is the profile obtained by default if none exists in the home
directory). This default profile file has comments which provide an
explanation of the semantics of each settable attribute.

This is the last release of Sunview *waves*+, and it does not contain
many of the improvements in *xwaves*+. In contrast to *xwaves*+ this
release of *waves*+ is not greatly improved over the previous one.
Version 2.1 of *xwaves*+ is greatly improved and we encourage users to
switch to it.

The major distinguishing feature of *xwaves*+ Version 2.1 is the X
Interface Generation (XIG) features for customizing and extending the
user-interface. By using a variety of simple ASCII configuration files,
it is easy to produce highly-customized *xwaves*+/ESPS packages that
meet personal or application-specific needs.

For a detailed example of this, look at the directory structure and
files that comprise the new demos (\$ESPS_BASE/newdemos). The sources
for one of these are provided in
\$ESPS_BASE/src_examples/xig/testsignal.

Here is a brief summary of the major changes that are in the release.

*xwaves*+ menus are fully-reconfigurable on startup, via command files,
and by direct input; menu items can have arbitrary names, can invoke
built-in (i.e., the original) functions, can invoke arbitrary *waves*+
commands or command scripts, and can invoke external programs;

A new item (*init_file*) in the .wave_pro specifies a command file to be
executed after *xwaves+* starts up (before loading any files or
executing a command file given on the command line); The default profile
invokes a standard default initialization file that provides a
convenient environment for certain changes to *xwaves*+ menus and
globals.

an arbitrary number of external ESPS calls (*add_espsX*) can be added to
*xwaves*+ menus;

*xwaves*+ supports user-defined screen-button panels, with buttons that
execute arbitrary commands or command files;

*waves* and *xwaves* will read NIST (Sphere) format sampled-data files
(e.g., the TIMIT database), and has improved support for files with
"foreign" headers.

*xspectrum* improvements: power/magnitude plots, harmonic cursors,
additional high-resolution spectral analysis methods (Burg, Modified
Burg, Fast Modified Burg, Structured Covariance, Fast Structured
Covariance), multiple reference spectra, display of ARB_FIXED FEA_SPEC
files, and more!

*(x)label* improvements: arbitrary fonts, "MOVE" label and "REPLACE"
label modes, invocation of external shell commands with nearest nearest
label and time arguments.

*xwaves*+ uses sockets to function as a "display server" for local or
remote scripts and programs;

*xwaves*+ spectrogram display improvements: complex spectrograms,
horizontal rescaling (in addition to the vertical rescaling that was
already implemented), interpolation disable (data displayed as
rectangles), bracket markers, zooming, display of spectrograms with
unequally spaced frequencies (ARB_FIXED).

X versions of *marks* and *cmap* are included;

(*x*)*waves*+ is now sensitive to various *unix* environment variables
that allow customized paths for menu files, command files, etc.

Various new demos and examples are available. Run "eman demos" to get
more information.

Sunview and XView versions of *waves*+ can be called from a uniform
cover script.

Source code for an example attachment is included.

This Section lists the various programs that are part of the Version
2.1release. Naturally, the release includes the *(x)waves*+ program
itself.

The following *waves*+ attachments are included:

      (x)spectrum -	interactive spectrum analysis
      (x)label -	interactive labeling 
      (x)marks -	interactive labeling of pre-defined events

The "auxiliary programs" comprise a subset of ESPS programs that are
used in conjunction with (*x*)*waves*+. Included are various programs
that provide documentation, file conversion, user-interface extension,
and limited signal processing functions. For changes to the auxiliary
programs and more information about the new ones, please see the ESPS
release notes.

In Version 2.1, the following are new auxiliary programs:

A convenience function that automates filling out and e-mailing a bug
report or support request

This program is used to send *xwaves*+ commands (including @\<filename\>
to a running *xwaves*+ that is operating in display server mode.

This program converts NIST Sphere (e.g., TIMIT) label files into
*waves*+ label files.

These convert between MATLAB .mat files and ESPS FEA files.

Here's the full list of Auxiliary programs:


      addfea -	adds a new FEA file field based  on ASCII data
      addfeahd -	adds an ESPS feature file header to non-ESPS binary data
      addgen -	adds a generic header item to an existing  nor new ESPS file header
      bhd -	behead an ESPS file
      btosps -	convert binary sampled data file to an ESPS FEA_SD file
      cmap -	generate or edit a waves+ colormap
      cnvlab -	 convert NIST label file (e.g., TIMIT) to waves+ label file
      comment -	displays or appends to comment field in ESPS file headers
      erlsupport -	send a bug report or support request to ERL.
      eman -	displays or prints ESPS manual pages
      eparam -	run an ESPS program with parameter prompts
      epsps -	(synonym for psps -- avoids openwin path problems)
      epsps2mu -	converts ESPS FEA_SD file to headerless mu-encoded data
      espsenv -	display relevant UNIX environment variables
      eversion -	displays current version of ESPS and waves+
      fea2mat -	converts FEA to MATLAB .mat 
      fea_element -	prints binary format table for ESPS FEA files
      featosd -	convert ESPS FEA_SD file to old-style SD file
      formant -	compute formant frequencies,  formant bandwidths, and voicing
      find_esps_file - finds full path to an ESPS or waves+ file
      get_esps_base - returns the name of the esps base directory
      hditem -	print an item from an ESPS header
      hdshrink -	remove embedded headers from an ESPS file
      ils_esps -	convert an ILS sampled data file to an ESPS file
      lwb2esps -	convert a Laboratory Work Bench data file to ESPS FEA_SD
      mat2fea -	converts from MATLAB .mat to FEA
      pplain -	print values from ESPS file in "plain format"
      mu2esps -	converts mu-encoded data to ESPS FEA_SD file
      psps -	print headers and data from ESPS file in "pretty format"
      pspsdiff -	differential ESPS file comparator
      sdtofea -	convert old-style ESPS SD file to FEA_SD
      send_xwaves -	open connection to xwaves+ server and send commands
      sgram -	compute FFT-based narrow- or wide-band spectrogram
      sigtosd -	convert SIGnal sampled data file to ESPS
      splay -	play sampled data using SPARCStation codec
      testsd -	make test signal (sine wave, square wave, noise, pulses, ASCII input, etc.)
      tofeasd -	converts data from arbitrary FEA field to FEA_SD (sampled data) file
      tofspec -	converts FEA data to FEA_SPEC file (for spectrogram-style displays)
      wcheckout -	checks out a waves+ license
      winfo -	X-based tool for reading waves+ technical and release notes
      wfree -	frees a waves+ license
      wsystem -	detects window system being run by user
      xcmap -	generate or edit a waves+ colormap (X Versions)
      xtext - 	popup X window containing text file or output of any
    			text producing command.

*waves*+ can exploit several DSP boards that provide speech I/O and fast
computation of spectrograms. DSP Support Kits are now available for
three boards:

AT&T DSP32 VME board (Fab 2 Board)

AT&T DSP32C VME board ("Surfboard")

Ariel S32C (S Bus Board)

The support kits all include a UNIX driver (with installation
instructions), as well as standalone programs for D/A conversion, A/D
conversion, and spectrogram computations.

While we will continue maintenance of *waves*+ (i.e., the SunView
version) with bug fixes and a few enhancements, major evolution of the
system is now restricted to the X Version (*xwaves*+). Thus, unless we
specifically mention that a change applies to *waves*+ in these release
notes, it applies only to *xwaves*+.

Both *waves*+ and *xwaves*+ now read all NIST (Sphere) format sampled
data files. This is also the case for all ESPS programs that process
sampled data. Thus, (x)waves+ and ESPS can now be used directly on the
following NIST databases: TIMIT, Air Travel Information System (ATIS),
Extended Resource Management, TIDIGITS, and Resource Management. Note
that files *produced* by (x)*waves*+ and ESPS continue to be in ESPS
format.

*xwaves*+ and ESPS also have improved support for dealing with files
that have foreign headers. For more information, see the ESPS release
notes and the section "LOADING NON-ESPS FILES" in the *xwaves*+ man
page.

The programs *waves*, *waves*+, *xwaves*, and *xwaves*+ are just links
to a new cover script waves.*cover* (1-ESPS) that checks the current
window system and then invokes the right Sunview or XView version and
puts it into the background. The actual binaries are *svwaves* (for
Sunview) and *xvwaves* (for X). If you choose to invoke *xvwaves*
directly, you should make sure to put it in the background.

Those who use *waves*+ as a display server in the "old style" (reading a
pseudo-tty input rather than exploiting the *send_xwaves* facilities)
should make sure to invoke the *waves*+ binaries directly.

In the previous version, external calls (non-DSP spectrogram
computations and calls resulting from *add_espsf* or *add_espst*) were
implemented by executing *system*(3) and waiting for completion. In
Version 2.1 of *xwaves*+, a new mechanism has been implemented -
*xwaves*+ forks a process to run the external program and goes on its
merry way. When the forked process terminates, *xwaves*+ is signaled in
those cases where a pending display action was waiting (e.g., the
display of a spectrogram file). The main advantage is that users can
continue to interact with *xwaves*+ while the external program or
programs are running.

These two operations provide for display movement within a signal by an
amount equal to the current window size. In contrast, the existing
operations "page ahead" and "page back" provide for movement by an
amount specified by a display-independent global *ref_step*. The new
operations are particularly convenient for informal scrolling through
signals. The operations are available for both waveform and spectrogram
menus.

This operations causes the entire signal to be displayed in the current
window. If the buffer size is too small to hold the signal, the full
buffer is displayed. (The buffer size is determined by the global
*max_buff_size*.)

This is a selection that is now available as one of the bindings for the
middle-mouse button on both waveform and spectrogram displays; when
enabled, pressing the middle mouse button repeats the operation that was
most-recently selected from the (right mouse) menu. Once a menu
operation has been selected in a window, it can thus be repeated rapidly
without bringing up a menu each time. For example, this feature provides
a convenient means to obtain rapid, sequential zooming or panning.

The add_espsf, add_espst, and add_espsn commands can now each be used to
add multiple items to a menu. Previously there could be at most one
*espsf* item, one *espst* item, and one *espsn* item at any one time;
after being used once, an "add\_" command would replace the menu item it
had added before. The commands now accept a new keyword "menu" to add an
item selectively to the waveform window menu or the spectrogram window
menu. Items added by add_espsf can now produce multiple output files.
The names of the added items can now be arbitrary strings (previously
they couldn't contain blanks).

This is used to add new menu items - both menu items that invoke
"built-in" commands (the functions on the default menus) and menu items
that invoke arbitrary *waves*+ commands or command files.

Used to delete specific menu items.

Deletes all menu items (the first step in building a completely custom
menu).

This creates a new window containing screen buttons. A simple ASCII file
is used to define the button labels and the waves+ command (or command
file) to be executed if the buttons are pressed. Articulation is
provided for location, geometry, title, and icon title.

Used to iconize a specific button panel.

Used to open a specific button panel that has been iconized.

Destroys a specific button panel.

New operation zooms out to full buffer.

If *xwaves*+ is not operating as display server, it begins doing so.

If *xwaves*+ is operating as display server, it stops doing so.

In previous releases, the existing "get attributes" command was
restricted to obtaining display parameters. The new keyword "global"
supports output of *waves*+ globals. Output of all or a named set of
globals can be directed to a named file (as well as stdout), and is
produced in a format suitable for inclusion in a .wave_pro file. The
menus-\>globals buttons in the default startup environment produce a
button panel that exploits the new feature to display and write the full
set of globals. This feature is available for both *waves*+ and
*xwaves*+.

The behavior of the keywords "height" and "width" in the command "make"
has changed. They now affect spectrogram displays as well as waveform
displays, and they no longer have the side effect of setting the global
variables "wave_height" and wave_width". You can still set "wave_height"
and wave_width" in the make command by using the full names; these
globals still affect only waveform windows.

The new keyword "number" has been added to *add_espsf* (default 1). This
specifies the number of output files expected from the external program.
Appropriate file names are generated for the command string and are all
displayed when the external command terminates.

These iconize and open the *xwaves*+ control panel.

Resets the globals *plot_max* and *plot_min* so that automatic scaling
(the default) takes place.

This names an *xwaves*+ command file. If *init_file* is present in the
startup profile, the corresponding file is executed before any
command-line files are processed. When combined with the new features
that provide user-defined menus and screen-button panels, the
*init_file* provides a mechanism for creating highly-customized
*xwaves*+/ESPS packages that meet personal or application-specific
needs. The default *init_file* is
\$ESPS_BASE/lib/waves/commands/xw_init.WC.

The name of a writable directory to be used for all *xwaves*+ output
files. Do not define this global unless you want it used, and make sure
that the named directory exists and is writable. If *output_dir* is
defined, all output files from *xwaves*+, *xspectrum*, and *xlabel* will
go into this directory (including edited files, saved file segments,
spectrogram output files, outputs from add_espsf, etc.). It is OK to
include environment variables in the path. This global makes it possible
to produce *xwaves* output when working in read-only directories.

The semantics of *remote_path* has changed. It is now prefixed to the
basename of files rather than to their full names (which might have
included path specifications). The semantics are extended by the
existence of additional globals. If *remote_input_path* is defined, it
is prefixed to the basename of all input file names in external calls.
It overrides any definition of *remote_path*. Similarly, if
remote_output_path is defined, it is prefixed to the basename of all
output file names in external calls. It overrides definitions of
*remote_path* and *output_dir*.

This is the INET domain socket port number to be used when xwaves+ is
operating as a display server (as the result of the *xwaves*+ **-s**
option or the enable_server command). If set, socket_port overrides the
WAVES_PORT environment variable or the value given by the **-p** option.

middle_op text string corresponding to desired middle button operation
for spectrogram menus. must be one of: "up/down move", "move contour",
"modify intensity", "play between marks", "repeat previous". This and
the *spec_left_op* global are provided (by analogy with the waveform
menu's *left_op* and *middle_op*) so that the mouse bindings can be set
under *xwaves*+ command control.

text corresponding to desired left button opera- tion for spectrogram
menus; must be one of: "up/down move", "move closest", "mark formants",
"repeat previous"

1 to cause linear interpolation in rescaled spectrogram displays; 0 to
disable interpolation so that each discreet value is shown as a uniform
rectangle.

1 to cause horizontal rescaling of spectrogram displays; 0 to cause
fixed displays with 1-pixel per data record. If data are interpolated,
then the range of the interpolated data computed together is determined
by *spect_rescale_scope*.

1 to cause vertical rescaling of spectrogram displays; 0 to cause fixed
displays with 1-pixel per data record.

determines whether horizontal rescaling of interpolated data is computed
for the entire xwaves+ buffer (value is "buffer") or for just the
current window width (value is "view"). Rescaling for the entire buffer
can be quite slow if the ratio of the current view to the entire buffer
is large, but has the advantage that horizontal scrolling is very fast
once the new image is computed (since it is stored). Rescaling just the
current view is faster (and is the default), but has the disadvantage
that the rescaling takes place every time the viewpoint is moved (i.e.,
scrolling is slower). In later releases, this global will also affect
the rescaling of non-interpolated data.

This controls plotting of the part of the spectrogram-window reticle
that lies within the spectrogram plotting area. (The numbers around the
edges are not affected.) Set the value to 0 to disable plotting;
non-zero (the default) gives the old behavior.

These new globals provide a limited means of overriding the automatic
vertical scaling of plot data. If they are zero (the default), for each
trace *xwaves*+ finds the max and min in the entire buffer, and scales
the plot so that the max and min appear at the top and bottom of the
window (or window region, if there are multiple traces). If *plot_max*
(*plot_min*) is non-zero, *xwaves*+ will scale every new or refreshed
plot so that the top (bottom) of the window or region corresponds to the
fixed value. Values outside of the range are simply clipped by the top
or the bottom of the display window (extending into the scrollbar).
(That is the plots for multiple traces are not limited to a region of
the window as they are in the case of auto-scaling. Yes, it can get very
ugly! But it provides some capability where none existed. A new
*xwaves*+ command -- *auto_plot_limits* -- was added as a convenient
means for restoring xwaves+ to the mode in which all plot limits are set
automatically. Note that the new ESPS program *clip* (1-ESPS) can be
added to the *xwaves*+ menu to achieve a similar effect.

1 to cause *xwaves*+ to start up with its control window iconized; 0 to
come up open.

Control the initial position of the *xlabel* control panel.

Control the initial position of the *xspectrum* control panel.

Control the initial position and size of the *xspectrum* spectral
display.

A startup global that determines whether or not the *xspectrum* plot
window will be brought forward each time a new spectrum is computed.

A startup global that sets the maximum xspectrum LPC (maximum entropy)
order.

The previous version of *xwaves*+ would always automatically rescale
spectrograms in the vertical dimension to accommodate changes in the
height, but the horizontal scale was fixed at one pixel per data record,
so that each vertical column of pixels always corresponded to one
spectral slice computed by a DSP board or an ESPS program.

The vertical rescaling code was revised to run 2-3 times faster than in
the previous release.

In the current version, rescaling works in the horizontal dimension as
well, and the program can automatically stretch or expand spectrograms
in both dimensions when the window is resized, much as it does with
waveform displays. The operations "zoom in", "zoom out", "zoom full
out", and "bracket markers" are on the default spectrogram menu; when
horizontal rescaling is turned on, these operations and "align and
rescale" work in the same way with spectrograms as with waveform
displays.

Four global variables, *h_spect_rescale*, *v_spect_rescale*,
*spect_rescale_scope*, and *spect_interp*, provide control over the
rendering of *xwaves*+ spectrogram displays.

The global *h_spect_rescale* controls horizontal rescaling of
spectrograms. In particular,


    	set h_spect_rescale 0

yields the behavior of the previous version of *xwaves*+, fixed
1-pixel-per-record horizontal scaling, and


    	set h_spect_rescale 1

yields automatic horizontal rescaling.

Similarly, the global *v_spect_rescale* controls vertical rescaling of
spectrograms;


    	set v_spect_rescale 0

turns off vertical rescaling and fixes the vertical scale at one pixel
for each frequency point computed by a DSP board or ESPS program, and


    	set v_spect_rescale 1

restores automatic vertical rescaling. When vertical rescaling is turned
off, the tops of spectrograms are cut off in windows that are not high
enough to hold them, and extra background is added above spectrograms in
windows that are higher than necessary.

Normally, when horizontal or vertical rescaling is turned on, *xwaves*+
rescales by linearly interpolating values for pixels that do not
correspond exactly to computed data points. In the new version of
*xwaves*+, a non-interpolated mode of rescaling is available as well;


    	set spect_interp 0

turns interpolation off, and


    	set spect_interp 1

restores interpolation. The non-interpolated mode is a style similar to
that selected by the -D option of *image* (1-ESPS). Each computed
spectral value is represented by a rectangle of uniform color or
brightness; the edges of the rectangles are sharp, and there is no
gradual gradation from one data point to another.

When interpolation has been turned on, rescaling in either dimension can
create a rescaled image of the entire spectrogram data buffer or just
the visible part. This choice is determined by *spect_rescale_scope*;


    	set spect_rescale_scope buffer

selects the entire buffer, and


    	set spect_rescale_scope view

selects just the visible part. If "buffer" is selected, paging and
scrolling operations are very rapid once the data have been computed,
since the image resides on the X server and each operation uses a single
X Window System library call to map a new portion of the image to the
window. However, the rescaling and interpolation calculation itself can
be very expensive in terms of both time and server memory. Zooming in on
a part of a spectrogram that is much shorter than the full buffer can
initiate a lengthy operation that ties up the window system for several
minutes and cannot be easily interrupted because the mouse becomes
unresponsive. It is quite possible to exceed the capacity of the server
and crash the window system.

Selecting "view" for *spect_rescale_scope* provides an alternative
tradeoff between scrolling speed and image compute time. In this mode,
only the viewable data are interpolated and rescaled. Since these are
computed as the spectrogram is scrolled, scrolling is slower than in the
case of "buffer". But the time to compute the interpolated and rescaled
data becomes less and less the more "zoomed in" you are. To avoid nasty
surprises, it is a good idea to keep "view" as the default for
*spect_rescale_scope*. It is likewise safer to set the global
*zoom_ganged* to 0.

With interpolation turned off, a different rescaling process is used: no
backup image is created, and the entire rescaling operation is repeated
whenever the window is repainted. This can be slow at small scales, but
is reasonably fast at scales at which individual rectangles are easy to
pick out, since the time required depends more strongly on the number of
rectangles than on their sizes. With interpolation turned off, it is
easy to zoom in on small portions of large spectrograms. However, beware
of then turning interpolation on without first zooming back out to a
smaller scale, since anything that causes a refresh (uncovering an
obscured part of a window, for example) can trigger an expensive
interpolated rescaling.

The compiled in defaults (which also correspond to values in the default
.wave_pro) are:


    	spect_interp = 1
    	v_spect_rescale = 0
    	h_spect_rescale = 0
    	spect_rescale_scope = view

These produce the fastest painting behavior, with one bit in the image
for each point in the spectrogram file. The default *xwaves*+
initialization command file (*init_file* in the .wave_pro) provides a
screen button ("Images") that brings up a panel with screen buttons that
toggle the three globals that control scaling and interpolation.

Another significant change to the spectrogram display capability is that
*xwaves*+ can now display spectrograms with nonlinear frequency scales
(FEA_SPEC files in ARB_FIXED format). The plots are made with linear
record spacing, but a nonlinear vertical reticle scale, so if your files
have more detail at, say, the lower frequencies, the plot will have an
expanded scale at the lower frequencies. Cursors are properly
coordinated with other spectrograms with different vertical scales, the
"Value" readout at the top gives the proper values, and overlays on such
displays work properly.

*xwaves*+ can operate as a "display server", a term we use to describe a
mode of operation in which xwaves+, in addition to operating under local
control, listens on a network socket for xwaves+ commands (including the
invocation of command files). Such commands can be sent by arbitrary
external shell scripts or C programs. This feature, new with Version
2.1, blurs the distinction between external programs and xwaves+
attachments.

Operation as a display server is initiated on startup by means of the
**-s** option, or after startup by means of the *enable_server* command.
When in display server mode, *xwaves+* listens on an INET domain socket
port for commands to execute. The port number used is determined in the
following order: (a) the global *socket_port* as specified in the

effect if *xwaves+* is already operating as a display server (e.g., if
it was started with **-s**), but it determines the socket number used
the next time server mode is started by *enable_server*; (b) the port
specified by the command line option **-p**; (c) the contents of the the
unix environment variable WAVES_PORT at the time *xwaves+* starts; (d) a
compiled in default.

When in display server mode, *xwaves+* continues to operate normally via
keyboard and mouse interactions. Operation in display server mode can be
terminated by means of the command *disable_server*.

External scripts can exploit an *xwaves+* display server by using
*send_xwaves*. (One can also enter *send_xwaves* commands directly in a
shell window). External C programs can exploit the display server by
using the utility functions *open_xwaves* (3-ESPS), *send_xwaves*
(3-ESPS), *close_xwaves* (3-ESPS), and *send_xwaves2*. For example, the
*plot3d* (1-ESPS) included in ESPS Version 4.1 has an option that uses
these functions to send cursor-coordination commands to an *xwaves*+
display, thereby providing coordinated 3D- and spectrogram-style
displays. (3-ESPS).

ESPS and *(x)waves*+ have been made "position independent". In practice,
this means that the system (or a link) no longer has to be at /usr/esps.
Thus, root access is no longer required, and it is easy to switch
between different versions (e.g., between old and new release).

To support position independence, and to support customization of
ESPS/*(x)waves*+ packages, various environment variables have been
defined. The main ones are listed below (for details see *espsenv*
(1-ESPS)). The ones with names ending in "\_PATH" are search paths for
various types of files and have the same syntax as a Unix PATH variable:
a list of directory pathnames separated by colons. The general rule is
that if a required file is specified by a full pathname (beginning with
"/" or "./"), the name is simply used unchanged; otherwise *xwaves+*
looks for the file in the directories listed in the appropriate
environment variable, if it is defined, or else in the directories in a
default search path. For example (see WAVES_INPUT_PATH below) if a user
calls on *xwaves+* to display a signal by a name such as
"/usr/myname/speech.sd" or "./speech.sd", precisely that name is used.
If the name is given simply as "speech.sd", the result depends on the
search path. Suppose the value of the environment variable
WAVES_INPUT_PATH is, say, "/usr/abc:./data:.". Then waves looks first
for "/usr/abc/speech.sd"; if that doesn't exist, it looks for
"./data/speech.sd"; as the final resort, it looks for "./speech.sd". If
WAVES_INPUT_PATH is undefined, the search path is the default,
".:\$ESPS_BASE/lib/waves/files", so *xwaves+* looks first for
"./speech.sd" and then for "\$ESPS_BASE/lib/waves/files/speech.sd". For
more information, see *find_esps_file* (1-ESPS), *find_esps_file*
(3-ESPSu), and the macros in the include file
\$ESPS_BASE/include/esps/epaths.h. Here is the list of environment
variables.

This should be set to the root of the ESPS (and *waves*+) install tree.
If not defined, programs all use /usr/esps as a default.

This is the path used by *waves+* and *xwaves+* to find all input signal
files, label files, and label menu files. If WAVES_INPUT_PATH is not
defined, the default path used is ".:\$ESPS_BASE/lib/waves/files".

This is the path used by *waves+* and *xwaves+* to find certain library
files. If WAVES_LIB_PATH is not defined, the default path used is
"\$ESPS_BASE/lib/waves".

This is the path used by *xwaves+* to find menu files used with the
*xwaves+* command *make_panel*. If WAVES_MENU_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/waves/menus".

This is the path used by *waves*+ and *xwaves+* to find command files.
If WAVES_COMMAND_PATH is not defined, the default path used is
".:\$ESPS_BASE/lib/waves/commands".

This is the path used by *waves+* and *xwaves+* to find colormaps. If
WAVES_COLORMAP_PATH is not defined, the default path used is
".:\$ESPS_BASE/lib/waves/colormaps".

This is the path used by *waves+* and *xwaves+* to find the startup
profile. IF WAVES_PROFILE_PATH is not defined, the default path used is
"\$HOME:\$ESPS_BASE/lib/waves".

This is the hostname of an *xwaves+* display server. That is,
*send_xwaves* (1-ESPS) *send_xwaves* (3-ESPS) attempt to send messages
to an *xwaves+* process running on WAVES_HOST. If WAVES_HOST is not
defined, the local host is assumed.

This is the INET domain socket port number used by *send_xwaves*
(1-ESPS) and *send_xwaves* (3-ESPS) when sending messages to an
*xwaves+* display server. It is also used by *xwaves+* in determining
the port on which to listen. If WAVES_PORT is not defined, than a
compiled-in default is used. This is the default socket that *xwaves+*
listens on when started in server mode (**-s**). If a non-default socket
is to be used, it is specified to *xwaves+*, *send_xwaves* (1-ESPS), and
*send_xwaves* (3-ESPS) by means of WAVES_PORT. Note that *send_xwaves*
(1-ESPS) and *xwaves+* also have a **-p** option that can be used to
override WAVES_PORT.

If this variable is defined, it forces a "QUIT" button to be included at
the top of every button panel created via *exv_bbox* (3-ESPS). This
includes button panels created by *mbuttons* (1-ESPS), *fbuttons*
(1-ESPS), and the *xwaves+* command *make_panel*. The variable has no
effect if a quit button was specified directly using the **-q** option
to *mbuttons* or the *quit_button* keyword of the *xwaves+* command
*make_panel*.

If this environment variable is defined when *waves*+ or *xwaves*+
starts up, it specifies a default header to be used for headerless files
(non-ESPS and non-SIGnal) files. The global *def_header* is effectively
disabled. If you want to set def_header dynamically (changing it while
(*x*)*waves*+ is running), don't set DEF_HEADER.

If set, disables locking of the DSP by *waves*+, *xwaves*+, and the
record and play programs.

Unlike the previous version, the environment variable **ELM_HOST** must
now always be defined. It must always contain the hostname of the host
running the Entropic License Manager (*elmd*). It is best to have all
users define this in their *.cshrc* (or equivalent). One other
environment variable affects the license manager system:

controls the length of time *xwaves*+ and ESPS programs wait while
trying to contact the license server. The default is 10 seconds. Some
adjustment may be required depending upon the nature of your network.

In addition to the digital time and frequency readouts in spectrogram
windows, there is now a readout for the data value at the cursor
position. The digital readouts associated with overlays have been moved
to avoid overlapping other readouts.

*xwaves*+ and *xspectrum* attachment now properly handle ESPS spectrum
files (FEA_SPEC files) in the ASYM_EDGE format, which allows displaying
spectrograms with negative-frequency parts that result from analysis of
complex time series. (Formerly *xwaves*+ would display such
spectrograms, but with an incorrect frequency scale.)

The label for an iconized waveform or spectrogram window is now the
signal name rather than "waves+".

Startup messages about the profile and DSP boards are now suppressed if
*verbose* is set to 0 in the .wave_pro.

The range option used in calling external programs had a bug that could
result in one-too-many records. This has been fixed.

Many but (alas) not all of the multiple repaints have been suppressed.

Although attachments are now much less important given the new
capabilities of *send_xwaves* (1-ESPS) and *xwaves*+ operating as a
display server, a number of customers have asked for a source example of
an attachment. In this release we have included sources for *xspectrum*;
see \$ESPS_BASE/src_examples/waves/spectrum.

There is now a choice of units for the ordinate of spectrum plots.
Control-panel buttons allow switching between dB, magnitude, or power.

Harmonic cursors are now available in the spectrum plot. They are
enabled/disabled via buttons on the control panel.

Six additional autoregressive (LPC, maximum entropy) spectrum analysis
methods have been added to the choices in *xspectrum*. The full eight
methods are as follows (references are to the corresponding ESPS signal
processing library routine):


        Autocorrelation Method (AUTOC) - see get_auto (3-ESPS)

        Covariance Method (COV) - see covar (3-ESPS)

        Burg Method (BURG) - see get_burg (3-ESPS)

        Modified Burg Method (MBURG) - see get_burg (3-ESPS)

        Fast Modified Burg Method (FBURG) - get_fburg (3-ESPS)

        Structured Covariance Method (STRCOV and STRCOV1) - see bestauto (3-ESPS), 
        struct_cov (3-ESPS), and genburg (3-ESPS)

        Vector Burg Method (VBURG) (fast approximation to structured 
        covariance)  - see get_vburg (3-ESPS)

    Maximum order for LPC (maximum entropy) routines has been increased 
    from 30 to 200. 
    xspectrum now uses the signal (or object) name, rather than the
    string "spectrum", as the icon label for the spectrum plot window.
    xspectrum now works on FEA_SD files with FLOAT or DOUBLE data. 
    Global parameters are now inherited from xwaves+ rather than
    read from the user's profile. 
    Startup globals allow control over the position of the control window,
    position of the plot window, and size of the plot window.  
    xspectrum will now accept and display slices of spectrograms in
    ARB_FIXED format (unequally spaced frequencies).
    The user-interface in the plot window was improved by the 
    addition of a right button menu (left button is now a shortcut
    for save reference spectrum)  
    Up to 4 different reference spectra can be saved and kept in view 
    with separate cursors and readouts (up from 1).  Menu items are 
    available to erase the reference spectra and erase all spectra.  
    All of the xspectrum control parameters can be changed remotely
    from xwaves+ via a "send set" command.  Values shown in the
    control panel are changed accordingly.  
    Remote commands now include setting left and right frame limits 
    (host mode).  
    The default window type now depends on the analysis method - Hanning
    for FFT methods, and rectangular for all LPC (maximum entropy)
    methods.  If a window type is changed, the change affects only the
    current analysis method.  When a different analysis method is 
    selected, the window type reverts to what was used the last time
    the analysis method was used.  
    By default, the xspectrum plot window is brought to the
    foreground every time a new spectrum is displayed.  This behavior can
    be changed by means of the new startup global
    xspectrum_datwin_forward.  
    No plot window is displayed until the first spectrum computation
    takes place.   
    xlabel now uses the object name instead of "label" as
    the icon label when a label window (not the control panel) is
    iconized.
    An arbitrary font can now be used in the label window for both
    label and xlabel.  In the case of label, the font is
    also used in the label menu.  
    Arbitrary shell commands can be added to the label menu.  The 
    commands are invoked with three arguments: (1) text string in the
    first label field of the closest label; (2) the name of the label file
    displayed under the cursor; (3) the time location of the label
    closest to the cursor.  This feature is available in both label
    and xlabel.  
    New MOVE and REPLACE commands make it easy to move and replace
    existing labels.  This feature is available in both label and
    xlabel.  
    Global parameters are now inherited from xwaves+ rather than
    read from the user's profile. 
    Startup globals allow control over the position of the control window. 
    A bug was fixed that prevented formant from working on ESPS 
    FEA_SD files that were not SHORTS.  Formant still assumes 
    SHORT data, but the ESPS files are now converted on input.  
    The xwaves+ display of "f0.sig" files from formant was 
    fixed so that the connect-the-dots mode operates correctly.  
    A new unix environment variable DSP_NO_LOCK can be set to disable 
    the DSP file-locking mechanism. The set_lock() and
    rem_lock() functions that implement the locking were 
    documented.  
    The graphics problems with (Sunview) waves+ (random dots) under 
    Sun OS 4.1 have been fixed.  
    Many X bugs were fixed (yeah, everyone says that).
    Certain scheduled features didn't make it into the release.  The most 
    important of these is multiple attachments.  We are still committed
    to doing this, it should be available before the end of the year.  
    If your application depends on it, please let us know and we will 
    schedule you for a maintenance update as soon as the feature is
    available.  
    Here are a few known problems related to the new features:
    If an attachment is started when another is running, the one running
    will be detached.  However, if the time between starting the two
    attachments is very short, the detach can fail and xwaves 
    can hang. 
    If a font is defined in a label menu, xwaves+ uses it in the 
    label window but not on the label menu. 
    Our fixes for "too many repaint operations" sometimes leaves portions
    of display windows blank.  This is easily fixed by a manual refresh.
