**Release Notes for** *waves***+ Version 1.2**

Document version: 1.6 5/17/89

This document describes the changes from *waves*+ Version 1.1 to Version
1.2, as well as known problems with 1.2.

Various fixes in *label* and *waves*+ to avoid following a null pointer.

Fixed a bug that could cause attachments to hang.

Fixed the scaling of mouse positions to threshold values for the
modify-contour operation (on spectrogram displays). The feature did not
work properly in small windows.

Fixed a bug that sometimes caused garbage to be displayed in a
spectrogram window that was resized while partly covered.

Fixed a bit-order problem that affected spectrogram displays on the Sun
386i.

Fixed a bug that caused the first command file called from another
command file to be executed twice.

Fixed *play_file* from the file browser menu. Previously it ran a play
command from a wired-in path. This has been changed to work like the
other external play commands. There is no wired in path, the globals
*play_prog* and *remote_path* are used for the command, and the command
is printed if the global *verbose* is non-zero.

*Waves*+ now looks for the default .wave_pro and default *label* menu
file in the correct location (/usr/esps/lib/waves).

The dummy (flat) formant-bandwidth signal created by the mark-formants
operation now gets a proper ESPS FEA header when the spectrogram on
which it is overlaid is an ESPS spectrogram.

A bug was removed that caused core dumps when signals with empty buffers
were plotted. A warning message has been added for cases when an empty
buffer is created by reading an unreasonably short segment of a signal.

A bug was fixed that sometimes caused the horizontal axis numbering to
be misaligned with a spectrogram. This could occur when the global
variable ref_start was set to a non-default value by a "set ref_start
xxx" command or a "make ... start xxx" command.

Some cases of unnecessary repainting of windows are now avoided, and at
least one case has been fixed where a window that should have been
repainted, wasn't.

A new user-level ESPS program *dspsgram* (1-ESPS) has been added to the
set of programs that use the AT&T DSP32 board (the other programs are
*wrecord* and *wplay*). *Dspsgram* has the same interface (and function)
as *sgram*, but it uses the DSP32 board rather than the workstation CPU
to compute the spectrogram. Thus, *dspsgram* is a fast version of
*sgram*. Previously, spectrograms could be computed on the board only
from *waves*+. Since *dspsgram* can be called directly from the UNIX
shell, either locally or remotely via *rsh* (note that *dspsgram* works
on pipes), the resulting capability provides a significant extension to
the utility of the DSP32 board. *Dspsgram* is shipped as part of the
DSP32 support kit.

For installations that have the DSP32 board installed, a lock-file
mechanism has been added to prevent interference between programs that
try to use the board at the same time. The programs *dspsgram*, *wplay*,
*wrecord*, and *waves* have all been modified to operate with this
mechanism. Furthermore, a *waves*+ global *dsp32_wait* has been added to
specify the number of seconds that a *waves*+ spectrogram or play
operation will wait before giving up if it finds that the board is in
use. The lock-file mechanism is needed now that the *dspsgram* is
available and can be used to access the board remotely. For more
information, see the man pages.

*Waves*+ demos are now being shipped with *waves*+. Please see the
separate release notes for the demos.

*Wplay* was changed to accept AT&T SIGnal sampled data files. A new
option (**-a**) was added to attenuate or amplify the data so that the
maximum file value is scaled to the D/A maximum if the maximum file
value is stored in the header (this used to be a default). Also the
**-q** option was changed to behave more consistently. *Waves*+ was
changed to allow calling the external play command when the file is a
SIGnal file (now that wplay accepts SIGnal file).

Added a single-step feature, controlled by a global variable
*command_step*, to command-file processing. When in this single-step
mode, *waves*+ prints each command, executes it, and then pauses.

The interpolating and dithering routines for spectrogram images have
been rewritten with a view to speeding them up by avoiding
floating-point computations. A backup image is now kept for multiplane
spectrograms, as well as for single-plane dithered spectrograms, so that
they can be redisplayed without recomputation when uncovered after being
covered.

The default menu for *label* (/usr/esps/lib/waves/labelmenu) has been
changed to use the ASCII symbols in the DARPA TIMIT continuous speech
database. *Label* also now prints an appropriate message if no label
menu file is found (either the default or one in the current directory).
In this case, a (poor) default is generated on the fly.

A "fuzz factor" was added to a test of whether a requested segment is
contained in the buffer of already read data; the effect is to avoid
some unnecessary rereading of data.

The default spectrogram parameter file names have been changed from
nb_spect_params and wb_spect_params to nb_params and wb_params (these
changes are reflected in the default .wave_pro file).

*Waves+* will try to write some temporary files to the directory that
the input file comes from and you might not have write permission on
this directory. We consider this to be a bug.

*Waves*+ aligns spectrograms and waveforms unreasonably when they do not
have the same scale. This is manifested whenever ganged scrolling occurs
or when an align-and-rescale is performed from a waveform window (of
differing time scale).
