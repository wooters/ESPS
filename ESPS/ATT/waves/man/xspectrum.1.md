# NAME

xspectrum - spectrum estimation attachment for xwaves

# SYNOPSIS

**xspectrum** \[ **-c** *host_X_registry* \] \[ **-n** *host_name* \] \[
**-w** *wave_pro* \]

# DESCRIPTION

*xspectrum* is an *attachment* for the program *xwaves*(1-ESPS): a
program that runs in close cooperation with *xwaves* and provides
additional capabilities. *xspectrum* facilitates interactive
power-spectrum analysis of data displayed by *xwaves.* This manual entry
briefly describes *xspectrum* but is not intended to be a complete
*xspectrum* manual. For full details, see the chapter in *waves+ Manual*
and the chapters and in *waves+ Reference*. Also see *waves+ Manual* and
*waves+ Reference* for information about *xwaves.* In *Introducing
waves+*, a hands-on tutorial introduction to *xwaves,* there is a
demonstration of the use of *xspectrum*: see the section "Spectrum
estimation: *xspectrum*" in the chapter "Spectrum estimation, adding
labels".

## Introduction

An attachment is a program that extends the capabilities of *xwaves*
while running as a separate UNIX process. Attachments exchange
information with *xwaves* by communicating through the X server, using a
communication protocol that is compatible with Tcl/Tk.

*xspectrum,* an *xwaves* attachment, is a general-purpose
frequency-spectrum estimation program.

*xspectrum* will compute and display power-spectrum estimates from
segments of sampled data in *xwaves* waveform display windows.
Individual spectra displayed by *xspectrum* can be compared by
overlaying them on a common plot. The spectrum analysis method and
parameters can be varied by entering values in the *xspectrum* control
panel. If a linear-prediction (maximum-entropy) spectrum-analysis method
is used, *xspectrum* also supports inverse filtering of the selected
data and formant/bandwidth estimation. *xspectrum* will also display
"spectral slices"---single-frame power spectra---from data in *xwaves*
spectrogram windows.

## Starting xspectrum

You can start *xspectrum* in various ways. The commonest way is to click
the **xspectrum** button in the **Attach:** item of the main control
panel. Another way is to issue the *xwaves* command *attach.* The names
that appear in the **Attach:** item are determined by the global
variable *attachments,* which can be specified in the *.wave_pro* file.
If *xspectrum* has several distinct names (e.g. via symbolic links),
each one can be bound to a separate **Attach:** button and invoked as a
separate attachment. Thus multiple simultaneous invocations of
*xspectrum* are possible.

## Creating spectra

When *xspectrum* is attached to *xwaves,* the menu item **xspectrum** is
added to the *xwaves* waveform and spectrogram menus. Spectral analysis
is performed by selecting the menu item. This operation will only
succeed if performed either in a waveform window displaying a
one-dimensional signal or in a spectrogram window. If the operation is
performed in a waveform window, the spectrum is computed either on the
data in the currently marked segment or on the data in an analysis
window centered at the current cursor position---which of these occurs
depends on settings in the *xspectrum* control panel (see below). After
the spectrum is computed and displayed, the left and right *xwaves*
markers show the analysis window limits. The computed values can be
written to an ASCII output file.

When one of the analysis parameters is changed in the *xspectrum*
control panel, the active spectra are recomputed using the new
parameters.

When **xspectrum** is selected from a spectrogram window menu, no
computation is done; the analysis frame under the cursor is displayed in
the *xspectrum* window. Thus the parameters in the control panel have no
effect on the image.

## Spectrum display window

Spectral slices and spectra computed by *xspectrum* are displayed in a
window popped up by *xspectrum.* This display window has a
frequency/amplitude cursor or cross-hair, which can be moved with the
mouse, and an optional reticle. Moving the frequency cursor causes the
frequency cursors in *xwaves* spectrogram windows to move in
coordination. Numeric display of frequency and amplitude are available
in the upper-center part of the window. The time corresponding to the
center of the analysis window is printed in the display's frame. The
cursor can be left at a particular frequency by removing the mouse
pointer from the window with the middle button depressed.

The *xspectrum* display can be zoomed in frequency and amplitude to a
marked region. Vertical markers are moved using the "up/down move"
paradigm (press, drag, release) with the left mouse button. Horizontal
markers are moved in the same way with the shift key depressed. By
default, if a non-null region is delimited with the horizontal or
vertical markers, zooming takes place immediately to that region. If the
left and right (top and bottom) markers are coincident, the full
frequency (amplitude) range will be redisplayed. The right-button menu
permits enabling/disabling this feature.

The right mouse button brings up a menu with options for saving the
current spectrum as a reference, clearing saved (or all) spectra,
enabling/disabling the zooming feature, invoking inverse filtering, and
sending *xspectrum* plots to a printer or a plot file. Up to four
spectra can be saved as references. The reference spectra and the
current new spectrum are all displayed in different colors, with
separate cursors and digital readouts.

## Control panel

Some panel items allow you to select among wired-in alternatives. Other
items permit you to enter a numerical value from the keyboard. Mousing
menu selection items with the right mouse will display the available
alternatives. Menu selection items are indicated with the standard
down-pointer symbol; the current selection is always displayed. For
numerical inputs, just mouse the item and enter the value from the
keyboard, followed by a *RETURN.*

**Analysis Type:**  
This item selects the spectrum-analysis method. The available methods
are two Fourier-transform methods, a cepstrally smoothed FFT method, and
six maximum-entropy methods. The two Fourier methods are log magnitude
spectrum using a radix-2 FFT (**DFT**) and a O(n^2) discrete Fourier
transform (**DFTR**) where the transform size is exactly the analysis
window size. The cepstrally smoothed method (**CEPST**) expands on a
suggestion originally provided by the MIT-LCS group; high-pass and
low-pass liftering are provided, with control over the liftering
transition region. (See **Cep. cut (sec):**, **Cep. trans:**, and
**Liftering:** below.) The maximum-entropy methods are all based on the
LPC-style analysis methods supported by the functions
*compute_rc*(3-ESPS) and *refcof*(1-ESPS), namely autocorrelation method
(**AUTOC**), covariance method (**COV**), Burg method (**BURG**),
modified Burg method (**MBURG**), fast modified Burg method (**FBURG**),
structured covariance (**STRCOV** and **STRCOV1**), and vector Burg
(**VBURG**), a fast approximation to structured covariance. Of the two
structured covariance methods, the first (**STRCOV**) is considerably
faster and better behaved. In each of these LPC cases, a log-magnitude
(maximum-entropy) spectrum is created via a DFT of the filter
coefficients. For more information on the methods, see *refcof*(1-ESPS),
*compute_rc*(3-ESPS), and the man pages for functions that are mentioned
there.

All computations are performed using floating point arithmetic. The
minimum size FFT used is 512 points, zero-padded as necessary. For the
**DFT** function, the maximum size FFT is essentially unlimited, though
there is a soft limit of 2097152 which can be changed by resetting the
variable *xspectrum_max_fft_size* using the *xwaves* command *send.* The
maximum DFT size for the **DFTR** function is 1025 points. The latter
limit is imposed to prevent accidental computation of DFTs that would
take impractically long to compute.

**order:**  
This sets the order for LPC analysis underlying the maximum-entropy
methods (if specified by **Analysis type**). The maximum order available
is 200 (but may be less depending on the startup profile).

**Window type:**  
This selects the time weighting function to be applied before analysis.
The four supported types are **rectangular**, **Hamming**, **Cos^4**,
and **Hanning**. The default weighting type is specific to the analysis
method. In particular, **Hanning** is the default for **DFT**, **DFTR**,
**AUTOC**, and **COV**, while **rectangular** is the default for all of
the other (maximum-entropy) methods. Whenever the existing default
window method is changed via this item, the new method is retained by
*xspectrum* as a new default for the current analysis method (i.e., for
the **Analysis Type:** in effect when **Window type** is changed).

**size (sec):**  
This is the duration of the analysis window for input when the **Window
limits from:** item (see below) is set to **Cursor +- size/2**.

**Window limits from:**  
This determines how the size and location of the analysis window are
determined. When **Cursor +- size/2** is selected, the window is
centered at the cursor, and its total duration is given by the **size
(sec):** item. When **Markers** is selected, the window limits are
determined by the left and right marker positions in the *xwaves*
windows when the **xspectrum** item is selected from an *xwaves* menu.
The size of the FFT used to perform the computations is expanded (in
powers of 2) as necessary (up to *max_fft_size*) to accommodate the
data. *max_fft_size* defaults to 2097152, but can be increased
arbitrarily in the *.wave_pro* file or via the *xwaves* command *send.*

**Preemphasis coeff:**  
The coefficient *a* of the filter

H(z) = 1 - az-1.

This 1st-order prefilter is applied to all signals before spectrum
computation. When this preemphasis is applied, one extra sample is used
from the input sequence to initialize the filter memory and maintain the
requested window size.

**Inverse Filter Intvl. (sec):** - **Integration Coeff:**  
These affect inverse filtering. When any of the LPC (maximum-entropy)
analysis methods have been used, the linear-prediction coefficients can
be used to inverse-filter the original signal, yielding a residual
signal. This operation can be initiated by selecting the **inverse
filter** option from the menu brought up by pressing the right mouse
button in the spectrum window. The amount of the original signal
(centered on the analysis window) to be inverse filtered is determined
by the **Inverse Filter Intvl. (sec):** item. The inverse filtered
signal is integrated (e.g., to convert pressure to volume velocity)
using a leaky integrator with the coefficient determined by the
**Integration Coeff:** item; 0.0 implies no integration. The resultant
signal is then stored in a file, and a message is sent to cause *xwaves*
to display it in a regular waveform window. The file name is derived
from that of the original signal by appending a distinguishing number.
If the *xwaves* global *output_dir* (read by *xspectrum* on startup) is
defined, that location is used for the inverse filtered signals.
Otherwise the file is stored in the same directory as the original
signal.

**xspectrum manual**  
Clicking on this button brings up a formatted version of this manual
entry in a browsable xtext window.

**QUIT**  
Clicking on this button detaches *xspectrum* from *xwaves* and
terminates execution.

**Horizontal cursor:**  
When **ON**, display the level (magnitude) cursor that rides on the
spectrum and corresponds to the level at the particular frequency
selected by the X location of the cursor.

**Reticle:**  
When **ON**, display a reticle. The horizontal axis is frequency; the
vertical axis is determined by the **Plot scale:** setting.

**Formants:**  
When this formant/bandwidth estimate switch is **ON**, print estimates
of the formant frequencies (i.e. complex poles of the all-pole LPC
model) and their bandwidths to standard output if the current **Analysis
type** is any of the LPC-based (maximum-entropy) types. The formant
frequencies are selected from candidates proposed by solving for the
roots of the linear predictor polynomial. This frequency and bandwidth
output is only available if the order is less than 30.

**Harmonic cursors:**  
When **ON**, display a harmonic series of cursors. When the harmonic
cursors are turned on, the mouse pointer, if moved in the spectrum
display, controls the frequency of a harmonic in the vicinity of the
right edge of the display. As the pointer moves right it eventually
jumps back to the next lower harmonic. Similarly if the pointer is moved
left, it eventually jumps to the next higher harmonic (up to the
twentieth harmonic). Thus, fine-grained control of the first harmonic,
and thus the harmonic spacing is always maintained. If the pointer is
moved out of the window vertically, then back in at about the same
place, control of the same harmonic will be resumed. If the middle
button is pressed, the pointer can be moved out of the window in any
direction without disturbing the cursor adjustment. The frequency and
amplitude readouts at the top of the plot continue to refer to the
fundamental frequency.

**Plot scale:**  
This switches among three different choices for the scale of the
vertical axis: **log pwr (dB)** (the default), **magnitude**, and
**power (square of magnitude)**.

**Cep. cut (sec):** - **Cep. trans:** - **Liftering:**  
These affect spectrum estimation when cepstral smoothing (**CEPST**) is
specified by **Analysis type:**. **Liftering:** selects high-pass
liftering, low-pass liftering, or none. **Cep. cut (sec):** gives the
nominal cutoff quefrency. **Cep. trans:** gives the duration of a
quefrency transition region between zero and full power, which reduces
the ripple artifact that would result from zero transition time
(rectangular liftering). The transition shape is a raised half cycle of
a cosine. The transition region is divided evenly between the stop band
and the passband.

## xspectrum colors

The current *xwaves* colormap is passed to *xspectrum* as part of the
temporary *.wave_pro* read via the **-w** option.

The format of *xwaves* colormap files is 128 lines with three integers
per line, separated by spaces or tabs. The integers, which must be in
the range 0-255, specify the intensities of red, green, and blue
respectively. The line ordering is from low to high map entries. The
first 115 entries are used by *xwaves* for representing spectral power
density in spectrograms. The remaining 13 entries specify the colors of
cursors, reticles, backgrounds, etc. *xspectrum* uses some of these last
13 entries for similar purposes, as shown in the following table. The
first column is the entry number, the second is the notation used to
refer to these by *xwaves,* and the third column describes the use
within *xspectrum.*


    	116	WAVE2
    	117	YA1	2nd ref. spectrum and digital readouts
    	118	YA2	3rd ref. spectrum and digital readouts
    	119	YA3	4th ref. spectrum and digital readouts
    	120	YA4
    	121	YA5
    	122	MARKER	vertical (frequency) cursor(s)
    	123	CURSOR	1st ref. spectrum and digital readouts
    	124	WAVEFORM
    	125	TEXT	current spectrum and digital readouts
    	126	RETICLE	current spectrum horizontal cursor
    	127	BACKGRND
    	128	FOREGROUND

## Graphics export

Like *xwaves* and the other attachments, *xspectrum* has the capability
to export graphics in either PostScript or PCL (HP LaserJet code). This
can be used to print displays directly on the printer or to generate
graphics to be imported into a document with a suitable text editing
program. Graphics output is invoked by selecting the **print graphic**
item on the *xspectrum* menu or by a *print* command sent to the display
object in *xspectrum* from *xwaves.*

There is an *xwaves* command, *print_setup ,* that invokes a setup
window with which you can choose output to a file or printer, select
PostScript or PCL, set output resolution and scaling, and control other
aspects of the graphics-export environment. See the chapter "Printing
graphics" in *waves+ Manual* for details.

*xspectrum* supports the *xwaves* command *print_ensemble;* it can
cooperate with *xwaves* to allow the contents of *xspectrum* windows to
be included in *xwaves* multi-window graphics output. See "Printing
graphics" in *waves+ Manual* for details.

## xspectrum symbols

*xspectrum* has its own set of symbols. A full list of these symbols and
their uses can be found in the chapter in *waves+ Reference*.

You can specify these variables in your profile file. When *xspectrum*
is started from *xwaves,* it is automatically passed a temporary file
written by *xwaves* that contains the values of all the *xwaves* globals
in standard *xwaves* profile format. The file is passed with the option
**-w**.

Most of these *xspectrum* variables can also be set after starting by a
*set* command sent to *xspectrum* by the *xwaves* command *send.* E.g.:

> send function xspectrum op xspectrum set <var> <val>

## xspectrum commands

*xspectrum* recognizes a limited set of commands that are listed and
described in the chapter in *waves+ Reference*.

*xspectrum* can be controlled by an *xwaves* command file or by commands
from the program *send_xwaves*(1-ESPS) or the *SendXwaves*(3-ESPS)
functions. Commands from these sources can be passed through to
*xspectrum* via the *xwaves* command *send.* The syntax of the
*received* commands is:

> object command keyword value keyword value ...

(the same as for *xwaves* commands). The first item, *object,* is either
the attachment name "xspectrum" or the name of a display object. The
second item, *command,* is the actual command name. There may be any
number, including 0, of keyword-value pairs.

# OPTIONS

*xspectrum* is usually started as a subordinate program by *xwaves.* In
this case, you need not be concerned with the command-line options
presented below, and you may skip this section. However, it is also
possible to run *xspectrum* (and the other attachments) as sibling UNIX
processes, in which case it may be necessary to specify one or more of
the following options.

**-c** *host_X_registry*  
This is the name that the host program is registered under for X
server-based communications. This option is intended to be supplied by
*xwaves* when it runs *xspectrum.*

**-n** *host_name*  
This is the name of the program object with which *xspectrum* will be
communicating. When the host program is *xwaves,* this name is always
the default value, "waves".

**-w** *wave_pro*  
Specifies the startup profile to read. This option is always used when
*xspectrum* is invoked by *xwaves,* in which case the specified profile
is a temporary file written by *xwaves* and containing the current state
of the *xwaves* globals. If **-w** is not used (only possible if
*xspectrum* is run from the shell), *xspectrum* attempts to read the
file *.wave_pro.* In both cases the search path
*\$HOME:\$ESPS_BASE/lib/waves* is used. The search path used can be
overriden by setting the UNIX environment variable WAVES_PROFILE_PATH
before starting *xwaves.*

# SEE ALSO

*waves+ Manual*,\
*waves+ Reference*,\
*Introducing waves+*,\
*fft*(1-ESPS), *formant*(1-ESPS), *me_spec*(1-ESPS),\
*refcof*(1-ESPS), *send_xwaves*(1-ESPS), *transpec*(1-ESPS),\
*xchart*(1-ESPS), *xfft*(1-ESPS), *xlabel*(1-ESPS),\
*xrefcof*(1-ESPS), *xwaves*(1-ESPS), *compute_rc*(3-ESPSsp)

# BUGS

Depending on the analysis method and the waveform being analyzed, the
maximum-entropy methods can get into computational trouble at large
orders, in some cases leading to abrupt terminations. Pure (noise-free)
sinusoids can cause trouble with several of the maximum-entropy methods
at any analysis order. This is because the estimated correlation matrix
is singular for line spectrum. See *Digital Signal Processing,* Roberts
and Mullis, Addison Wesley, 1987, page 533.

*xspectrum* requires that the data to be analyzed (or displayed) exist
in a UNIX file. Thus, *xwaves*-internal signals (such as spectrograms
generated by some of the DSP boards, or hand-edited signals not written
to disk) must be explicitly saved to disk if they are to be analyzed by
issuing a *send make ...* command. If the spectrum analysis is initiated
from the *xwaves* **xspectrum** menu item, such signals are saved
automatically.

# AUTHOR

Program by David Talkin, AT&T Bell Laboratories. Later enhancements by
David Burton, Rod Johnson, Alan Parker, John Shore, David Talkin, and
others at Entropic. This manual page largely extracted by Rod Johnson
from *waves+ Manual* and earlier manual pages derived from Talkin's
original documentation with revisions and additions by David Burton,
Joop Jansen, Rod Johnson, John Shore, David Talkin, and others at
Entropic.
