ESPS 3.3 Release Notes

4/26/89 1.2

This document provides notes relevant to release 3.3 of ESPS. Please
read this document and the Installation Instructions completely before
installing this release of ESPS.

The ESPS 3.3 installation kit contains magnetic media of the ESPS 3.3
distribution. This is a complete distribution; it is not an update to
3.2. For Masscomp systems the magnetic media is either a set of
diskettes or one 9 track tape. For Sun systems the media is either a
cartridge tape or one 9 track tape. In any of these cases, the media
contains the source distribution in Unix *tar(1)* format.

If you do not already have ESPS, the kit also contains a User's Manual,
containing documents describing the use of the system and manual pages
for all programs, library functions and file types. If you do have ESPS,
then the kit contains update pages for your User's Manual. The documents
provided are important, and should be read by all users of the system.
They provide essential information about using ESPS.

Masscomp provides a dual universe environment on their systems. By using
the *universe* command, a user can set his compilation environment to be
either ATT System V, or Berkeley 4.2. ESPS is to be installed under the
UCB universe (command: *universe ucb*). In most cases, since the library
is created under ucb, user programs must also be compiled and linked
under ucb. You will notice one exception, our scripts and makefiles use
the *lint* under att. This is because lint has some problems under ucb.

Please duplicate this section and make it available to all users of
ESPS. This information is needed by others than just the ESPS installer.

There was a 3.2b and 3.2c distribution. You may have initially received
one of these. Here are the changes from 3.2 to 3.2c:

There are several new programs.

A new library function *lsqsolv* had been added. See the manual page
updated for details.

Scripts to produce speech spectrograms have been added, *sgram* and
*plotsgram*. See the manual pages for details.

*sfconvert* is a new program for converting the sample rate of sampled
data files.

*me_sgram* added. This program produces a maximum-entropy based SPEC
file suitable for display as a spectrogram.

For details on the following changes, please refer to the appropriate
manual page.

Changed *fea_edit* so that records are numbered from 1.

Added the -h option to *bhd*, to remove the data and leave the header.

Added support for external reference files in the data file header. A
pointer in the header can now refer to an ESPS or ASCII file external to
the file itself. See the History memo and *add_genhd*(3-ESPS) for
details.

Modified *psps* and *addgen* for the external reference file support
(EFILE and AFILE).

Bug fixes in *notch_filt* and *find_ep*.

Bug fix in *plotsd*, relating to plotting a file that contains all
records with a single value.

Changed Sun *mcd* and plot programs to accept standard Sunview options.
The manual page for *mcd* doesn't show that it accepts the Sun Sunview
options, but it does. See the Sunview Programmer's manual for a list of
these options.

Version 3.3 supports ESPS on Hewlett Packard series 300 and 800
computers.

A major change in 3.3 is that SPEC (spectral) files have been
reimplemented as a subtype of feature files (the same will happen to SD
and FILT files in future releases). The new file type is called
FEA_SPEC. A support module has been added to the library to handle this
file type. Most programs that deal with old SPEC files have been changed
to use new FEA_SPEC files. A set of conversion programs are available to
convert from SPEC to FEA_SPEC files and back; (*spectofea* and
*featospec*). SPEC files still work; that is they are still supported in
the library and old SPEC files can be used by some programs. To use an
old SPEC file with a program that no longer handles old SPEC files, just
use *spectofea* to convert. If you have your own programs that use SPEC
files, you should convert them to FEA_SPEC files. The following programs
have been modified to handle FEA_SPEC files: *me_spec, filtspec, fftinv,
fft, plotsgram,* sgram, plotspec and *me_sgram*. The only programs that
do not support FEA_SPEC files directly are *image* and *distort*; use
*featospec* as appropriate (these two programs will change to FEA_SPEC
in the next release).

Another major change in ESPS for this release is that 3.3 supports
*waves*+, our optional interactive graphics interface for ESPS on Sun
workstations. Many programs were modified to maintain the generic header
items *start_time* and *record_freq*. These are needed by *waves*+ to
time align data files when they are displayed. A new library function,
*update_waves_gen(3-ESPS)* has been added to maintain these generics. If
you write a program that processes sample data, or a feature file, you
should use this library function. The following programs have been
modified to maintain these header items: *addsd,* fea_deriv, lpcana,
find_ep, me_spec, sf_convert, me_sgram, vq, filtspec, fftinv, frame,
zcross, pwr, window, distort, refcof, filter, copysps, transpec,
setrange, copysd, cross_cor, classify, and *auto*.

The following new user-level programs are available:

This program adds a digital halftone bit-map field to a FEA files. It
was developed for an intermediate version of other ESPS programs.
Version 3.3 ESPS does not require *dither*, but it is provided in case
users want to get their hands on a dithered representation of
spectrograms or other images.

This program converts a FEA file to a FEA_SPEC file. It is needed
primarily by *waves*+ users who wish to display arbitrary FEA data in
spectrogram form.

Converts old-style SPEC files to FEA_SPEC.

Converts FEA_SPEC files to old-style SPEC.

The program *sgram* has been replaced. The older version was a shell
script. It is now a C program (i.e., faster, and also supports standard
I/O). Some options have changed. If you use this, please check the man
page.

The library routine *window* (3-ESPS) was changed to support additional
window types HANNING and COS4. Several user-level programs were changed
to exploit this.

A new library routine *print_feaspec_rec* has been added to support
FEA_SPEC programming.

The semantics of *add_genhd* (3-ESPS) has changed so that it is no
longer an error to call on an existing header item. If such a call is
made, the old value is replaced with the new one.

A new library routine *get_genhd_val* has been added - this returns any
item as a double and furthermore returns a default value (a parameter)
if the item is undefined.

A new library routine *inhibit_hdr_date* was added. This causes the next
call on *write_header* to not change the date field. *Comment* (1-ESPS)
and *addgen* (1-ESPS) were changed to use this, so that the date field
gives the date when the file was created.

The user-level programs *zcross*, *pwr*, and *window* were changed to
copy all generics to the output file.

*Hdshrink* (1-ESPS) has been changed to move comments from embedded
headers only if a **-c** option is used.

A new generic header item has been added to *lpcana* output files:
*nominal_frame_size*. It contains the target frame length for spectrum
analysis; that is, the value specified by *lpc_frame_size* in the
parameter file. *Lpcana* now writes 0 for the value of the *frmlen*
generic header item (it used to record *lpc_frame_size*). These changes
were made to make *lpcana* output compatible with the new *me_spec*.

The following changes have been made to *refcof*: fixed so that a frame
truncated (e.g., at end of file) is handled as full frame. That is, the
optional window is applied as though the frame length is given by the
size of the truncated frame. *Prefcof* (default parameter file) - fixed
to work properly with eparam (wrong default for analysis method)

A bug in *frame* was fixed that caused a problem with *frame_len* == 0
and common was processed.

*Mcplay* was fixed so that the **-s** option handles fractional seconds.
Some error messages were also improved.

The manual page for *read_params(3-ESPS)* was fixed to correctly
describe common processing.

The library function *pc_to_lsf* was updated. This has bug fixes.

The programs *pwr* and *zcross* were updated to correct some error
messages.

*Lpcsynt* now looks in the *nominal_frame_size* generic header to get
information for synthesis; it used to look in *frmlen*. If you want to
synthesis from old lpcana output files, you need to add the generic
header item *nominal_frame_size*. This can be done easily by using
*addgen*.

The program *me_sgram* has been changed to have options consistent with
the new *sgram* program. Also, it now allows non integer step sizes.

*lpcsynt* updated to fix a bug which only shows up on Sun4 systems.

The filter design program *wmse_filt* computes and stores in the header
of the output file the filter delay time, as *sample_delay*. The
programs *filter* and *fft_filter* use this to correctly compute the
*start_time* generic in the filtered output file. The other filter
design programs do not yet compute this and their man pages have been
changed to mention this.

Numerous minor bug fixes and documentation changes.

This release of ESPS fully supports the optional ESPS interactive
graphics interface, *waves+*. *Waves+* currently runs only on Sun3 and
Sun4 systems. The *waves+* distribution is in binary form and includes
the following programs:

*waves+* - this is the main program for *waves+*. It requires the
Suntools window environment to run.

*spectrum* - this is an "attachment" for waves+. It is an on-screen
spectrum analyzer.

*label* - this is a time series labeling attachment for waves+.

*formant* - computes formant frequencies, bandwidths and voicing
information.

The program *cmap* (1-ESPS) didn't make it into this release. It will be
available shortly.

For information about *waves*+ and ESPS, see the *waves*+ man page and
the document "Waves+ Product Descriptions."

See the ESPS installation instructions for details on installing
*waves+*, but for the most part it is automatic when you install this
release of ESPS (assuming you bought *waves+*!). In the case of Sun3, we
supply two sets of binaries, one for the MC68881 floating point chip and
one for the Sun3 FPA board. You should use the one that matches your
hardware. The *waves+* related programs and manual pages get installed
into the standard ESPS locations. Some related *waves+* files, such as
example parameter files and colormaps, get put into the ESPS library in
a subdirectory named waves (*eg.* /usr/esps/lib/waves).

Postscript support for the ESPS plot programs is provided by a program
that converts Tektronix plotting codes into Postscript. This program is
public domain (tek2ps) and is included in the directory
*general/pub/tek2ps*. It is not installed by the installation script.
You should compile it and install it as you see fit for your system.

The ESPS plot programs are all executed by a cover shell script
(*plotsd, plotspec*, etc). The actual output of the plot programs is an
intermediate form that is piped to a program that turns it into GPS or
Tektronix codes. For hardcopy plotting, we pipe the Tektronix codes out
to a laser printer capable of plotting these. For a Postscript laser
printer, the output must be piped through tek2ps and then spooled to the
printer. Edit the PLOTCOMMAND section of the install script to produce a
file with the correct command line for your system (comment out all but
one line in there).

If you already have ESPS 3.2 installed, there are several options about
how to install 3.3. If you want the target directory to remain the same
as before, simply read the 3.3 sources into any directory you desire and
follow the installation instructions. Set the target directory path in
the installation script to be the same as you used for 3.2. Please read
the 3.3 sources into a clean directory; if you want it to be the same as
you used for the 3.2 sources, then rename that directory to something
like esps.old first. Don't read the tape on top of the 3.2 sources, some
names have changed and things might get confused.

If you are short on file space, then you should probably delete the old
3.2 sources and binaries first. If you reinstall over the old version a
copy of all binaries will be kept in the bin/old directory. This will
take many megabytes.

All of the ESPS plot programs produce an intermediate plot stream
output, which is then processed into Unix GPS format. If the plot is to
the displayed on the Sun screen, this is then processed by the ESPS
program *mcd*, which runs under Suntools. *Mcd* will create a window and
display the plot in that window. The window with the plot can be moved,
resized, or reduced to an icon. It is removed when no longer needed by
using the **QUIT** item on the menu pulled down by clicking the mouse on
the title bar (just like all tools under Suntools).

Do not write any programs which depend upon the intermediate output of
our plot programs. This will probably change in a future release.

The ESPS plot programs can produce output for the Imagen laser printer
using its Tektronix emulation mode. If you have another type of printer
or plotter that can plot tektronix plots streams then you should be able
to use it as we use the Imagen. If you use a postscript based printer
(such as the Apple LaserWriter) we can supply a public domain tektronix
to postscript emulator. Call us if you want it.

To adapt another type of plotter to the plot programs, look at the
install script under *esps_plot*. Call us if you have questions. In the
next major release, we are going to provide a better way to specify the
type of hardcopy plot device in the install script.

This version of ESPS does not directly support data acquisition (speech
input and output) on Suns, since there is no standard speech hardware
used by Suns. This package does include the source code to the speech
input and output programs used on ESPS Masscomp systems. If you have
data acquisition hardware, you might be able to modify these programs
for your hardware. The speech input program is called *mcplay* and the
speech output program is called *mcrecord*.

If you have another means of data acquisition that results in a binary
file (of 16 bit integer data) you can use the ESPS program *btosps* to
turn that file into an ESPS sampled data file. You can also use *testsd*
with the -a option to produce an ESPS sampled data file from an ascii
file.

The ESPS program *bhd* can be used to remove the ESPS header and leave
behind just the binary data from an ESPS data file. In the case of
sampled data files, you can convert to the correct data type with
*copysd* first.
