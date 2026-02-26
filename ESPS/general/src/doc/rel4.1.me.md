ESPS Version 4.1 Release Notes

Document version: 1.14 11/21/91

This document provides notes for release 4.1 of ESPS. These release
notes document changes to ESPS since the revision 4.0c. This document
can be viewed conveniently using *einfo* (1-ESPS) or *eversion*
(1-ESPS).

Perhaps the most important change in this release is the introduction of
powerful X Interface Generation (XIG) capabilities. XIG refers to the
combined facilities of various programs and libraries; included are
*fbuttons*, *mbuttons*, *exprompt*, *expromptrun*, *xeparam*, *xtext*,
and *xwaves*+ (see the *xwaves*+ release notes for a summary of
*xwaves*+, and *libxv*. For an overview, see the new ESPS applications
note "X Interface Generation in ESPS and *xwaves*+". For a detailed
example, look at the directory structure and files that comprise the new
demos (\$ESPS_BASE/newdemos). The sources for one of these are provided
in \$ESPS_BASE/src_examples/xig/testsignal.

Other major changes include the following:

Over 25 new user_level signal processing and utility programs, including

programs for dynamic time warping, fft cepstrum, and VQ-based
classification

cover-program for computing acoustic classification parameters

programs for Nth-order differences and for clipping

interactive program for pole-zero filter design

conversion programs for MATLAB files

Over 35 new signal processing and utility library functions, including

signal processing library functions for dynamic time warping, bilinear
transform, FFT cepstrum, structured covariance, etc.

utility functions for skip headers, free headers, fork programs,
generate temp files, communicate with an *xwaves*+ display server, etc.

new utility library to support XView programs

ESPS programs now read files with NIST (Sphere) headers

Improved support for reading headerless files and files with foreign
headers

All filter-related programs modified to use a feature file format
(FEA_FILT).

Structured covariance (and fast structured covariance) methods for
computing autocorrelations (and autoregressive spectra) have been added
to the library, as well as to *refcof*, *lpcana*, and *auto*. These
methods are particularly good on short data sequences (such as those
that produce "classic" line splitting from the modified Burg method).

*feafunc* has many more arithmetic functions and can also be used for
FEA field name or type changes

*plot3d* can now drive synchronized *xwaves*+ cursors

filters are now represented by feature files (FEA_FILT)

*splay* includes approximate (fast) down-sampling code (for signals not
sampled at 8000 Hz.)

"position-independent" installation (no longer /usr/esps)

new program for on-line documentation (*einfo*)

ESPS and *(x)waves*+ have been made "position independent". In practice,
this means that the system (or a link) no longer has to be at /usr/esps.
Thus, root access is no longer required, and it is easy to switch
between different versions (e.g., between old and new release).

To support position independence, and to support customization of
ESPS/*(x)waves*+ packages, various environment variables have been
defined. The main ones are these:

This should be set to the root of the ESPS (and *waves*+) install tree.
If not defined, programs all use /usr/esps as a default.

This can be set to the directory that you want programs to use for
temporary files. Not all programs currently pay attention to
ESPS_TEMP_PATH, but over time they will be modified to do so. The plot
programs have been modified to support ESPS_TEMP_PATH.

This is the path used by *mbuttons* (1-ESPS) and *fbuttons* (1-ESPS) to
find *olwm*-format menu files. If ESPS_MENU_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/menus".

This is the path used to find ESPS parameter files specified by the
standard ESPS **-P** option. If ESPS_PARAMS_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/params".

If defined when *read_header*() encounters a headerless file, DEF_HEADER
specifies a default header to be used.

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

ESPS sampled data programs now read NIST (Sphere) format sampled data
files. This is also the case for all ESPS programs that process sampled
data. Thus, (x)waves+ and ESPS can now be used directly on the following
NIST databases: TIMIT, Air Travel Information System (ATIS), Extended
Resource Management, TIDIGITS, and Resource Management. Note that files
produced by ESPS continue to be in ESPS format.

ESPS also has improved support for dealing with headerless files. In
particular, if any ESPS program does not recognize an input file (to be
precise, it's *read_header* (3-ESPS) that's doing this), the file is
assumed to be "headerless". If in this case the *unix* environment
variable DEF_HEADER is defined and points to a file with a valid ESPS
header (whether or not there is data in that file is irrelevant), the
header of that file is used as a "virtual" header for the headerless
file. Thus, the data description in the DEF_HEADER should be valid for
the input data. The ESPS conversion programs *btosps* and *addfeahd* are
useful in creating such headers. Here's an example that creates a 12 Khz
FEA_SD header and uses it to filter a headerless data file sg1.a1:


    	%btosps -f 12000 -c "header for sg1" /dev/null k12.hd
    	%setenv DEF_HEADER `pwd`/k12.hd
    	. . . 
    	%filter -F data/sg1.filt  data/sg1.a1 sg1.a1.filt.sd
    	%send_xwaves make file sg1.a1.filt.sd

The last command sends an *xwaves*+ display server a command to display
the filtered file. Note that the output files are ESPS files (i.e., they
have ESPS headers). Note also that this approach is not limited to
sampled data. DEF_HEADER can point to any FEA header, and it will "do
the right thing" with any FEA-eating program, provided that the header
properly describes the data.

If data files have foreign headers, it can be convenient to leave them
in place during ESPS processing, so that they are left when a final ESPS
*bhd* is run. To support this, *btosps*, *addfeahd*, and *bhd* have
options to leave skipped data (the foreign header) in place, for
example:


      btosps -S 512 -F for.sd - | filter -F esps.filt - - | bhd -F - for.filt.sd

The **-F** option on *btosps* causes the 512 skipped bytes to be kept in
place between the ESPS header and the data. Actually, it is kept there
by means of new generic header items in the ESPS header, so that it will
be carried along by later programs (like *filter*, above). The **-F**
option on *bhd* causes the foreign header to be left in place after the
ESPS header is removed. The result, in the above case, is a pipe that
starts and ends with a file in the foreign format.

Foreign headers are kept in the ESPS header in the following manner: The
generic header item *foreign_hd_length* contains the size (in bytes) of
the foreign header. If this item is present (and non-zero),
*read_header*() will read this many additional bytes of data, put it
into the header, and set an additional generic header item
*foreign_hd_ptr* to point to it. From that point on, the foreign header
is just part of the ESPS header. Note that one can use *addgen* (1-ESPS)
to modify *foreign_hd_length* in the header specified by DEF_HEADER
before calling an ESPS program.

With this mechanism, it is possible to write programs that use the ESPS
header and record I/O functions while still having access to the foreign
header. The procedure is simple: use *read_header*() to read the ESPS
header, and *get_genhd*() to get the pointer to the foreign header.

A new license manager accompanies this release. A *unix* environment
variable ELM_TIMEOUT is available to control the length of time programs
waits while trying to contact the license server.

*fbuttons* - new program that pops up a panel of screen buttons for
invoking one of a given set of programs on one of a given set of files.
By default, fbuttons is configured to either play the contents or view
the header of files in the current directory with suffixes ".sd" or
".d", but arbitrary program and file sets can be specified.

*mbuttons* - new pops up a panel of screen buttons for invoking
arbitrary ESPS program calls (e.g., creating certain test signals,
sending display commands to *xwaves*+, whatever). Standard OLWM (same as
Sunview) format menu files can be used to specify the button names and
associated commands.

*expromptrun* - new program that provides an extended version of
*exprompt*. It prompts for parameters in an X window (like *exprompt*)
and then runs the associated ESPS program on the resulting parameter
file. *expromptrun* terminates after the ESPS program terminates. For
example:


       %expromptrun -h sgram -P PWsgram sgram -r1:2000 speech.sd speech.fspec

puts up a an interactive form based on the parameter file (PWsgram is a
new paramfile in lib/params that prompts for all but *start* and *nan*;
note that *read_params* now uses a search path that by default includes
. and \$ESPS_BASE/lib/params), and then uses the resulting parameters to
compute a spectrogram on the first 2000 points of speech.sd. *xromptrun*
is well suited for shell scripts and particularly for *xwaves* menu
commands. For example:


          add_espsf name "custom spectrogram" menu wave command \
    		expromptrun -h sgram -P PWsgram sgram 

adds a custom spectrogram (with parameter prompting) to the *xwaves*
waveform menu. (You can add this to the menu via the menus-\>"menu
changes"-\>"add waveform buttons" buttons provided in the default
startup environment.)

*xeparam* - new program that runs *expromptrun* in the manner of
*eparam*; i.e., you just give it the ESPS command line for a program,
and it prompts for the needed parameters.

*acf* - new program that computes a selection of acoustic recognition
features (includes mel-warped cepstrum).

*xacf* - new program that provides an interactive (X-Windows) front-end
for *acf*.

*cbkd* - new program that computes distances between codewords in vector
quantization codebooks (FEA_VQ files).

*dtw* - new program computes dynamic time warping distance between two
sequences stored as feature file fields.

*dtw_rec* - new program that compares test sequences to reference
sequences using a dynamic time warping algorithm. Comparisons can be
made between sequences of floating point vectors or sequences of VQ
codeword indices.

*addclass* - new program for VQ-based classification; *addclass* adds a
vector quantization codebook to a set of codebooks being prepared for
classification computations (each codebook represents one class).

*vqdst* - new program for VQ-based classification; *vqdst* encodes an
input feature with respect to each of a set of vector quantization
codebooks (each codebook represents one class); the encoding rule is
minimum mean square error.

*vqclassify* - new program for VQ-based classification; applies a
classification rule to the output of *vqdst* (initial program implements
the "voting" rule - i.e., it selects the class with the largest number
of encodings.

*nodiff* new program to compute Nth order differences of an arbitrary
field in a FEA file.

*xpz* - new program for interactive filter-design program. *xpz*
provides mouse operations to add, delete, or move poles and zeros
displayed against the unit circle. As poles and zeros are modified, the
resulting spectral response or other derivative function is shown in a
separate window.

*fftcep* - new program for computing complex FFT cepstrum; will process
multi-channel and complex inputs.

*clip* - new program to apply clipping or center clipping to FEA fields.
This is useful in certain VQ thresholding applications, among others. It
can also be used from *xwaves*+ to replot data on an expanded scale.

FEA_FILT (5-ESPS) - this is a new FEA subtype that is used for store
digital filters. All filter-related programs (*notch_filt, wmse_filt,
iir_filt, filter, fft_filter, filtspec,* toep_solv, etc.) have been
modified to use the file type. In addition to the filter coefficients,
FEA_FILT files contain optional fields to store the poles and zeros. The
*xpz*, *notch_filt*, and *iir_filt* design programs programs have been
modifed to output poles and zeros in addition to coefficients.
Conversions to and from the old file format are available via *fea2filt*
(1-ESPS) and *filt2fea* (1-ESPS).

*xrefcof* - new script that runs *refcof* on a single frame of data
after using a pop-up window for parameter prompts; the analysis results
are displayed in two pop-up windows, one containing the reflection
coefficients, and one containing a maximum-entropy power spectrum
computed from these reflection coefficients. It is sometimes useful to
attach *xrefcof* to the *xwaves*+ menu (e.g., via the menus-\>"-\>"menu
changes"-\>"add waveform function" buttons provided in the default
startup environment) for cases in which the *xspectrum* attachment gets
into computational trouble.

*xfft* - new script that runs *fft* on a single frame of data after
using a pop-up window for parameter prompts; the analysis results are
displayed as a pop-up spectral plot. It is sometimes useful to attach
*xrefcof* to the *xwaves*+ menu (e.g., via the menus-\>"-\>"menu
changes"-\>"add waveform function" buttons provided in the default
startup environment) for cases where *xspectrum* proves to be inadequate
(e.g., *fft* (1-ESPS) and hence *xfft* will compute arbitrary
transforms, limited only by memory size).

*cnvlab* - new user-level program for converting NIST/Sphere (e.g.,
TIMIT) label files to *(x)waves*+ format.

*get_esps_base* - new program for locating the base of the installed
ESPS tree (returns \$ESPS_BASE or default /usr/esps). Useful for writing
position-independent scripts.

*find_esps_file* - new program for finding an ESPS file within the ESPS
tree, with options for a default search path and an environment variable
that overrides the default. Like *get_esps_base*, *find_esps_file* is
useful for writing position-independent scripts.

*mat2fea*/*fea2mat* - new programs to convert between MATLAB .mat files
and ESPS FEA files.

*xloadimage* - new program; an enhanced version of Jim Frost's public
domain *xloadimage* program for displaying images. Our variant allows a
"slideshow" to run under control of an external program, *next_slide*
(also included); we use these in one of the standard demos. The sources
for *xloadimage* and *next_slide* are included in \$ESPS_BASE/pub.

*einfo* - new program to provide a convenient interface to ESPS release
notes and other documentation.

*edemos* - new X interface to a set of demos that illustrate
ESPS/*xwaves*+ and X Interface Generation (XIG).

*wsystem* - new program to tell what window system you're running

*erlsupport* - new convenience program for e-mailing a support request

*elpr* - new ESPS utility to print ascii text.

*filter* - generalized to filter multichannel signals and complex
signals with real filters.

*refcof* - modified to provide 4 additional autoregressive spectrum
analysis methods (references are to the corresponding ESPS signal
processing library routine):


        Fast Modified Burg Method (FBURG) - get_fburg (3-ESPS)

        Structured Covariance Method (STRCOV and STRCOV1) - see
        bestauto (3-ESPS), struct_cov (3-ESPS), and genburg (3-ESPS)

        Vector Burg Method (VBURG) (fast approximation to structured 
        covariance)  - see get_vburg (3-ESPS)

*lpcana* - modified to provide an option (**-m**) for selecting the
analysis method used for computing reflection coefficients. The
available methods are the same 8 methods available from *refcof* (i.e.,
from the new library routine *compute_rc* (3-ESPS)), namely:


        Autocorrelation method (AUTOC)

        Covariance method (COV)

        Burg method (BURG) 

        Modified Burg method (MBURG) 

        Fast Modified Burg method (FBURG) 

        Two Structured Covariance methods (STRCOV and STRCOV1) 

        Vector Burg method (VBURG) (fast approximation to structured 
        covariance)  

*lpcana* was also modified to compute reflection coefficients separately
for each frame (i.e., for each pitch pulse). The old framing method is
available as an option (**-F**).

*auto* - **-B** supports computation via structured covariance rather
than lag-product.

*splay* - (SPARCStation codec output) modified to include fast,
approximate resampling code so that files can be played even if they are
not sampled at 8000 Hz. (Modifications courtesy of Tom Veatch, Univ. of
Pa.). *splay* also has a **-q** (quiet) option to suppress warning
messages.

*feafunc* - the set of computed functions has been expanded considerably
to: *abs* (absolute magnitude), *arg* (phase angle), *atan*
(arctangent), *conj* (complex conjugate), *cos* (cosine), *exp*
(exponential), *im* (imaginary part), *log* (natural logarithm), *log10*
(base 10 logarithm), *none* (no change - the identity function), *re*
(real part), *recip* (reciprocal), *sgn* (signum; for a complex number z
off the real axis, the value is z/\|z\|), *sin* (sine), *sqr* (square),
*sqrt* (square root), and *tan* (tangent). Furthermore, the output field
no longer has to be a new field, different from the fields already
present in the input; it can now replace a field with the same name in
the input file, including the input field. changed from "ln" and "log"
to "log" and "log10" for consistency with *select* and with C; thus the
meaning of "log" is now different. The parameters "gain_factor" and
"add_constant" have been replaced with "gain_real" and "add_real", and
"gain_imag" and "add_imag" are allowed in case complex coefficients are
needed. The same list of functions available with feafunc can now be
applied to arrays of any of the real and complex ESPS data types in a C
program using the new library function *arr_func*.

*plot3d* - modified for optional startup (**-w**) in a mode that sends
cursor commands to an *xwaves*+ display server. Thus, a spectrogram can
be viewed simultaneously in conventional and 3D formats, with cursor
synchronization. To see an example of this, start *xwaves*+ in server
mode (**-s**), add *plot3d* to the menu via the menus-\>"menu
changes"-\>"add image function" buttons provided in the default startup
environment, bring up a spectrogram, and invoke *plot3d* on a marked
segment. Other *plot3d* improvements include visible painting of the
first plot, a **-M** for a monochrome plot (useful for screen dumps),
startup allowed without a named file, visible busy signal, and load
window defaults to current data.

*sgram* - has a new (**-T** *desired_frames*) to force a particular
number of output records; *sgram* adjusts *step_size* accordingly. If
the start and end times are decreased while the *desired_frames* is kept
constant, *sgram* in effect computes a spectrogram in the new region
with finer time-domain resolution. This permits zooming in without
interpolation. This form of analysis is popular at TI.

*vq* - modified so that the codeword index is written to output file
along with quantized fea field, with optional**- i** output of the
codeword index alone.

*image* - modified to display FEA_SPEC fies in ARB_FIXED format; also,
*image* now works properly on untagged FEA_SPEC files. Several *image*
colormaps are now included in the \$ESPS_BASE/lib/colormaps.

*me_sgram* - modified to use support standard ESPS parameter file and
Common processing (via **-P**). *me_sgram* inherits the new spectrum
analysis methods of *refcof*; the **-c** and **-i** options were added
to *me_sgram* to handle optional parameters in the case of the
structured covariance methods.

*fft_filter* - output data type now matches input data type, and
computations revised for double precision.

*fft, refcof, sgram* - new **-z** option to suppress warnings.

*me_spec* - no longer warns unnecessarily about **-G** option.

*filter* and *rm_dc* - no longer destroy input if output is not
specified.

*sfconvert* - more robust with respect to erroneous input. A **-z** was
added to adjust the output *start_time* for the filter delay. This
permits better synchonization in *xwaves*+ displays.

*classify* - modified to remove errooneous assumption that the order of
records in the statistics file is the same as the order of the
enumerated field "class". Thanks to Richard Goldhor for this.

*copysd* - new **-S** option allows range specification in seconds. The
"standard" option name for this is **-s** (lower case), but that's
already in use by *copysps* (for scale) and we didn't want to break
existing scripts. However, if **-s** is now used with what looks like a
range argument, we print a warning. A bug was also fixed that prevented
*start* and *nan* from being taken from Common as specified in the man
page. Other Common-related bugs were also fixed.

*comment* - new **-S** option to suppress the user-date-time stamp.

*copysps* - new **-s** option to specify range in seconds.

*mux* - *start_time* generic is now correct (was always zero), output
now correct for 3 or more files (it wasn't), and the Pmux parameter file
now exists.

*addfead* - modified to accept ascii as well as binary data (thanks to
Richard Goldhor of AudioFile for this); also, there's a new **-F**
option to save a skipped header as a foreign header;

*btosps* - added **-F** to save a skipped header as a foreign header.

*bhd* - added **-F** to support foreign headers If **-F** is used
without the **-h**, then the foreign header is retained and written to
the output file before the data. If **-F** is used with **-h**, then the
foreign header is written out after the ESPS header.

*fea_edit/spstoa/atosps*, - revised so that blanks now remain in
strings.

*pplain* - has a new **-n** which facilitates output of character fields
as strings; the **-i** option now works correctly.

*echeckout* - no longer gets a license if one is already checked out.

*dtw_l2* - new function; dynamic time warping based on euclidean
distance

*dtw_tl* - new function; dynamic time warping based on table lookup

*blt* - new function for bilinear transform

*fft_cepstrum* - new function; computes the cepstrum of a data sequence.

*fft_cepstrum_r* - new function; computes the cepstrum of real data
sequence.

*fft_ccepstrum* - new function; computes the complex cepstrum of a data
sequence.

*fft_ccepstrum_r* - new function; computes complex cepstrum of a real
data sequence

*get_fburg* - new function; computes reflection coefficients using a
fast modified Burg method.

*struct_cov* - new functions; computes a structured covariance estimate
of a Toeplitz autocorrelation matrix (STRCOV)

*genburg* - new function; generalized Burg (structured covariance)
estimation of covariance matrix (STRCOV1)

*strcov_auto* - new function; estimates auto-correlation coefficients
using structured covariance

*get_vburg* - new function; computes reflection coefficients using a
vector Burg method (this is a fast approximation to a structured
covariance method).

*compute_rc* - new function; this is a cover function for the various
ESPS library functions that compute reflection coefficients. It provides
a common calling interface for all eight methods: autocorrelation,
covariance, Burg, modified Burg, fast modified Burg, two structured
covariance methods, and vector Burg (fast approximation to structured
covariance).

*windowcf, windowcfd* - new functions for windowing complex data

*convertlab* - new function for converting NIST/Sphere (e.g., TIMIT)
label files to *(x)waves*+ format.

*a_to_linear_2*/*linear_to_a_2* - new N-law conversion functions. These
differ from the existing functions *a_to_linear* and *linear_to_a* in
the code byte inverted in accordance with a CCITT recommendation. TIMIT)
label files to *(x)waves*+ format.

*arr_func* - new function for computing various standard functions such
as cosine, square root, logarithm, and absolute value for real and
complex arguments (any of the ESPS numeric data types). It will take an
array input and apply the function to all elements of the array. The
function is used in the new version of the user-level program *feafunc*.

*skip_header* - new function; skips an ESPS header (without the overhead
of the recursive header read);

*free_header* - new function; frees the storage associated with an ESPS
header.

*exec_command* - new function; forks a shell to run a unix command

*e_temp_name, e_temp_file* - new functions to support creating and
opening temporary ESPS files. These make use of the *unix* environment
variable ESPS_TEMP_PATH.

*get_esps_base* - new function or ESPS position-independence; returns
the base directory of ESPS (ESPS_BASE or /usr/esps).

*find_esps_file* - new function for ESPS position-independence; searches
for a file along a path that is specified through a default path which
can be overridden by an environment variable. Various cover macros are
also defined (in \$ESPS_BASE/include/esps/epaths.h) for various
important categories of ESPS and *(x)waves*+ files.

*build_esps_path* - new function for ESPS postition-independence;
appends an arbitrary extension to a valid path in the ESPS hierarchy.

*build_file_name* - new function; expands environment variables in a
path name

*open_xwaves* - new function; opens a socket connection to an *xwaves+*
server

*send_xwaves* - new function sends a command to an *xwaves+* server

*close_xwaves* - new function; closes a socket connection to an
*xwaves+* server

*send_xwaves2* - new function; sends a single command to an *xwaves+*
server without a separate open and close

*atoarrays* - new function; converts ASCII file to a data array of
strings (similar to *atoarrayf* and *atoarray*).

*strlistlen* - new function; returns the current number of strings in a
string array.

*trange_switch* - new function to assist in parsing command-line
arguments expressed in seconds (parses -s\<a\>:\<b\> and returns start
and end records).

*read_header* - modified to read NIST (Sphere) sampled data headers and
return an equivalent ESPS FEA_SD header. From the viewpoint of programs
that call *read_header*, NIST files are FEA_SD files.

read_header - modified to assume that a default header properly
describes any header-less file. If the environment variable DEF_HEADER
exists, and if the input file is a headerless (i.e., non-ESPS and
non-SIGnal), then *read_header* uses the file pointed to by DEF_HEADER
as a "virtual header".

read_header - modified to look for generic header item "foreign_header".
If it is defined and non-zero, then it is taken as a number of bytes of
a foreign header in the file after our header. The foreign header is
skipped over, so that the next read after read_header will get the data.

*read_params* - The assumption of "params" as the default ESPS parameter
file has been moved into *read_params*(). In particular, if the
parameter *param_file* is NULL, then read_params uses the ESPS default
parameter file name "params". If *param_file* is non-NULL, and if
*read_params* is unable to find a corresponding, readable parameter
file, a warning is printed. By default, *read_params* uses
*find_esps_file*() to search along the path


         ".:$ESPS_BASE/lib/params".

This default search path can be overridden by setting the unix
environment variable ESPS_PARAMS_PATH. The unix environment variable
ESPS_VERBOSE is used (as before) to control the extent of parameter
processing feedback messages issued by read_params. There are now three
significant settings: 0, 1, and 2. If it is equal to 0, no feedback is
provided. If ESPS_VERBOSE is 1, programs report the value of any
parameters taken from ESPS common. If it is 2 or greater, programs
report the values of parameters taken from ESPS common, the name of the
actual parameter file used (if any), and the values of parameters taken
from the parameter file. If ESPS_VERBOSE is not set, a value of 2 is
assumed. Note that parameter file selection is affected by
ESPS_PARAMS_PATH (as described above). Regardless of ESPS_VERBOSE, if
debug_level is non-zero, read_params will warn if a parameter file
cannot be found (including the default "params"), will report the name
of any parameter file found, and will report if ESPS Common is
processed. This new behavior is documented in the *read_params* and
*espsenv* man pages.

*addstr* - modified so that it is now legal to call it with a NULL for
the string array, in which case initial allocation results.

This release includes the first version of *libxv*, an extension of the
utility library that supports XView applications. The following
functions are included:

*exv_helpfile* - return file name containing cleaned man page or plain
text

*exv_get_help* - creates XView frame containing text of man page or help
file

*exv_make_text_window* - create XView frame containing text of ASCII
file (complete with quit, search-forward, and search-backward buttons).

*exv_attach_icon* - attachs one of a selection of standard ESPS icons to
a frame.

*exv_prompt_params* - fills in an ESPS parameter file by means of an
interactive X-Windows prompt panel

*exv_bbox* - create panel with arbitrary screen buttons

*read_olwm_menu* - reads a menu in Open Look Window Manager format; this
is a support function for *exv_bbox*()

*print_olwm_menu* - prints an *olwm*-format menu; support function for
*exv_bbox*().

The directory \$ESPS_BASE/pub contains full-source copies of certain
relevant and useful public domain programs. You are free to use them and
pass them on in any manner consistent with restrictions stated by their
authors. This release contains these new additions:

This is a utility that splits a *unix* pipeline into two pipelines.
Stated differently, the output of one pipe can provide the intput to two
others. *tpipe* was written by David B. Rosen of Boston University.

Rod Johnson at ERL enchanced Jim Frost's *xloadimage* so that a
"slideshow" can run under the control of an external program,
*next_slide* (also included).

This is a utility to build and edit forms. It was written by Paul Lew.

A utility that allows you to grab arbitrary portions of the screen and
output them in Postscript or many other formats. *xgrabsc* was written
by Bruce Schuchardt.

We use *GNUtar* to make and read tapes, so we distribute in in the GNU
spirit.

*feafunc* has changed in some ways that may break existing scripts. In
particular, the notation for the natural and common logarithms has been
changed from "ln" and "log" to "log" and "log10" for consistency with
*select* and with C; The parameters "gain_factor" and "add_constant"
have been replaced with "gain_real" and "add_real", and "gain_imag" and
"add_imag" are allowed in case complex coefficients are needed.

If filter (FILT) files from the old release are used as intput for the
filter programs in Version 4.1, they won't work. The most likely symptom
is an exit from a FEA_FILT support routine with an assertion error
stating that a non FEA_FILT file was detected. Just convert the file
with *filt2fea* (1-ESPS).

FEA_FILT files generated with the beta release of Version 4.1 also will
not work with this final release (sorry!). Unfortunately the most likely
symptom is that ever-informative "segmentation fault, core dump." An
assertion error is also possible. If it is difficult to re-create such a
filter, many of them can be fixed by running *fea_edit* on the file and
changing all instances of the string "degree" to "size". This is not
possible if the FEA_FILT contains the fields "poles" and "zeros" (e.g.,
if generated from *xpz*). In this case, the ugly but workable solution
is to use *xpz* to create a FEA_FILT file with the right number of poles
and zeros, use *bhd* to obtain the header, use *bhd* to get rid of the
header in the beta file, and then glue the new header on with *cat*.
