# NAME

    xacf - X-window interface for acoustic feature extractor

# SYNOPSIS

acf \[ **-P** *param* \] \[ **-x** *debug_level* \] *acf_params*

# DESCRIPTION

*Xacf* is a graphical interface to the acoustic feature generating
program, *acf* (1-ESPS). *Acf* reads a single channel FEA_SD file,
extracts and windows frames of data, and produces acoustic features
based on each frame (see the ESPS section 1 entry on *acf* for a
complete description). *Xacf* presents a menu-driven interface by which
all parameters parameters read by *acf* can be specified.

When *xacf* is called, the output parameter file *acf_params* is created
using the default values for all *acf* parameters. If the -P option is
provided, these default values are taken from the specified parameter
file; otherwise they are taken from the default file *Pxacf* (this
default file is searched for along the path ESPS_PARAMS_PATH, which in
turn by default contains the current directory followed by
\$ESPS_BASE/lib/params). If the output parameter file exists, it is
overwritten. As the user enters parameter values, *xacf* updates the
output parameter file with the new values. The parameter entries can be
restored to their default values at any time by selecting the *DEFAULT*
button. This resets the menu as well as the values in the output
parameter file. After all user parameter choices have been made, the
user can exit *xacf* by selecting the *DONE* button.

Help is available by selecting either the *Acf Man Page* or *Help*
buttons. The *Help* button produces this document.

Several of the features computed by *acf* share parameters. The
autocorrelation, line spectral frequencies, log area ratios, linear
prediction coefficients, and reflection coefficients are all computed
from the autocorrelation and all have the same order. The *order*
entries for each of these features in the *xacf* are therefore forced to
have the same value; updating one changes all. Similarly, the bilinear
transformation is applied to the FFT cepstrum and LPC cepstrum with the
same warping parameter. The warping parameter fields in the *xacf* menu
for these two features are forced to take the same value.

An output file must be specified; standard output is not allowed.

**USAGE NOTES**\
The following sequence of commands is an example of using *xacf* to
generate parameters for *acf*:

xacf acf_params\
acf -P acf_params speech.sd speech.fea

*Xacf* first creates the parameter file *acf_params* based on user
input. *Acf* processes the FEA_SD file *speech.sd* using this parameter
file to produce the FEA file of acoustic features, *speech.fea*.

There are several interface styles in the menu presented by *xacf*. Push
button items (YES/NO selections) are selected by mouse click. The choice
of window to apply to the data is selected by using the mouse to choose
one item from the list of possible windows. Text items, such as the
frame length or various fieldnames, are entered by selecting a field by
mouse button click and typing in the desired value. Note that for text
items, the output parameter file is not updated until a carriage return
is typed. For the other interface styles, the output parameter file is
updated immediately.

Note that it is possible to enter values for the parameters *start* and
*nan*, but that these values are overriden by *acf* command line
options.

**USE WITH WAVES+**\
*Xacf* can be used with *xwaves* (1-ESPS). Suppose the shell script
*do_acf* contains the following commands

\#! /bin/sh\
xacf acf_params\
acf -P acf_params -r \$1 \$2 \$3

Entering **add_espsf name features command do_acf** at the *xwaves*
command prompt adds the option **features** to the *xwaves* menu. If
this new option is selected, *do_acf* is executed. The *xacf* menu
appears and, when the user finishes entering parameter values, *acf*
processes the selected time series segment to produce the acoustic
features specified by the parameter values in *acf_params*. When *acf*
is finished processing, *xwaves+* displays the acoustic features. See
the *xwaves* (1-ESPS) entry for a more detailed description. Note that
the *xwaves* values for parameters *start* and *nan* are obtained from
the command line, so entries for these values made in *xacf* are
ignored.

# OPTIONS

**-P** *param*  
If this option is specified, the default parameter values presented by
*xacf* are taken from the file *param*. Otherwise, they are taken from
the file *param*.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

# ESPS PARAMETERS

The parameters read by *xacf* are used as the default entries in the
selections presented by *xacf*. As such, the parameters read by *xacf*
are identical to those read by *acf*, and are described here as they are
used by *acf*.

The following parameters are read from the appropriate parameter file:

*sd_field_name - string*  
> Specifies the name of the field in the input file *sd_file* which
> contains the sampled data. The default field name is "sd".

*units - string*  
> Specifies whether the units of the parameters *start*, *nan*,
> *frame_len*, and *step* are in seconds or samples. There are two valid
> values for *units*: "seconds" or "samples". If "seconds" is specified,
> the header item *record_freq* is used to convert the specified values
> in seconds to an equivalent number of samples. If "seconds" is
> specified and the field *record_freq* is not defined in the input
> header, or is 0, *acf* warns and exits. The default value is
> "samples". This parameter is not read by *acf* if it is called with
> the **-r** or the **-s** option.

*start - float*  
> The first point in the input sampled data file that is processed. The
> first sample in the file is denoted by 1 if *units*="samples" or by 0
> if *units*="seconds". If it is not in the parameter (or Common) file,
> the default is to begin processing at the begining of the file. This
> parameter is not read by *acf* if it is called with the **-r** or the
> **-s** option.

*nan - float*  
> The total amount of data to process. If *nan* is 0 and the input is
> not a pipe, the whole file is processed. If *nan* is 0 and the input
> is a pipe, *acf* warns and exits. *Nan* is read by *acf* only if the
> **-r** option is not used.

*frame_len - float*  
> The length of each frame. A value of 0 indicates that a single frame
> of length *nan* is processed; this is also the default value in case
> *frame_len* is not specified in the parameter file.

*step - float*  
> Initial points of consecutive frames are separated by this amount. If
> the option is omitted and no value is found in the parameter file, a
> default equal to *frame_len* is used (resulting in exactly abutted
> frames).

*preemphasis - float*  
> If *preemphasis* is not equal 0.0, the first order preemphasis filter\
> (1 - (*preemphasis*) z^(-1)) is applied to the data. The preemphasis
> factor must be between 0 and 1; if not, *acf* warns and exits.

*window_type - string*  
> The data window to apply to the data. If the option is omitted and if
> no value is found in the parameter file, the default used is "RECT",
> for a rectangular window with amplitude one. Other acceptable values
> include "HAMMING", for Hamming, and "TRIANG", for triangular; see the
> window(3-ESPS) manual page for the complete list.

*sd_flag - integer*  
*sd_fname - string*  
> If *sd_flag* is set to 1, the frame of windowed data is stored in the
> output records of *fea_file*; by default, this is not done. If
> *sd_fname* is defined in the parameter file, its value specifies the
> name of the field in which the windowed data is stored. The default
> field name is "sd".

*pwr_flag - integer*  
*pwr_fname - string*  
> If *pwr_flag* is set to 1, the power in each windowed frame of data is
> computed and stored in *fea_file*. The power is the sum of the squared
> values of the windowed data divided by the number of points in the
> current frame. The power of each frame is stored in the field "power",
> unless *pwr_fname* is assigned a different name.

*zc_flag - integer*  
*zc_fname - string*  
> If *zc_flag* is set to 1, the zero-crossings in each windowed frame of
> data are computed and stored in *fea_file*. The zero-crossings are
> computed as in the program *zcross* (1-ESPS). The number of
> zero-crossings in each frame is stored in the field "zero_crossing",
> unless *zc_fname* is assigned a different name.

*ac_flag - integer*  
*ac_fname - string*  
*ac_order - int*  
> If *ac_flag* is set to 1, the sample autocorrelation of the windowed
> data frame for lags 0,...,*ac_order* is found using *get_auto*
> (3-ESPS). The data is stored in the field "auto_corr", unless
> *ac_fname* is assigned a different name. The output field has data
> type REAL and dimension *ac_order*+1. If *ac_order*=0, a warning
> message is printed.

*rc_flag - integer*  
*rc_fname - string*  
> If *rc_flag* is set to 1, reflection coefficients are found from the
> sample autocorrelation of the windowed data frame using
> *get_atal*(3-ESPS). The parameter *ac_order* determines the number of
> reflection coefficients which are computed. If *ac_order*=0, a warning
> message is printed. The reflection coefficients are stored in the
> field "refcof", unless *rc_fname* is assigned a different name. The
> field has data type REAL and dimension *ac_order*.

*lpc_flag - integer*  
*lpc_fname - string*  
> If *lpc_flag* is set to 1, linear prediction coefficients are found
> from the sample autocorrelation of the windowed data frame using
> *get_atal* (3-ESPS). The parameter *ac_order* determines the number of
> prediction coefficients which are computed. If *ac_order*=0, a warning
> message is printed. The coefficients are stored in the field
> "lpc_coeffs", unless *lpc_fname* is assigned a different name. The
> field has data type REAL and dimension *ac_order*.

*lpccep_flag - integer*  
*lpccep_fname - string*  
*lpccep_order - integer*  
*lpccep_deriv - string*  
> If *lpccep_flag* is set to 1, cepstral coefficients are computed from
> the reflection coefficients found from the windowed data frame. The
> reflection coefficients are found as above, and the cepstral
> coeffiecients are obtained using *rc_reps* (3-ESPS). The parameter
> *lpccep_order* determines the number of cepstral coefficients which
> are computed. If *lpccep_order*=0, a warning message is printed. The
> cepstral coefficients are stored in the field "lpc_cepstrum", unless
> *lpccep_fname* is assigned a different name. The field has data type
> REAL and, if *lpccep_deriv* is not specified, has dimension
> *lpccep_order*. If the string *lpccep_deriv* is defined, the routine
> *grange_switch* (3-ESPS) is used to to parse the string to determine
> which elements of the *lpccep_order* cepstral coefficients are to form
> the output field. For example if the entry\
> **string lpccep_deriv = "1,11:20";**\
> appears in the parameter file, the output field has 21 elements taken
> from positions 0, and 11 through 20 in the cepstral sequence. If
> *lpccep_deriv* specifies points outside the range
> \[0:*lpccep_order*-1\], *acf* prints a warning and exits.

*lar_flag - integer*  
*lar_fname - string*  
> If *lar_flag* is set to 1, log area ratios (LARs) are computed from
> the reflection coefficients found from the windowed data frame. The
> reflection coefficients are found as above, and the LARs are obtained
> using *rc_reps* (3-ESPS). The parameter *ac_order* determines the
> number of LARs which are computed. If *ac_order*=0, a warning message
> is printed. The LARs are stored in the field "log_area_ratio", unless
> *lar_fname* is assigned a different name. The field has data type REAL
> and dimension *ac_order*.

*lsf_flag - integer*  
*lsf_freq_res - float*  
*lsf_fname - string*  
> If *lsf_flag* is set to 1, line spectral frequencies (LSFs) are
> computed from the reflection coefficients found from the windowed data
> frame. The reflection coefficients are found as above, and the LSFs
> are obtained using *rc_reps* (3-ESPS). The parameter *ac_order*
> determines the number of LSFs which are computed. If *ac_order*=0, a
> warning message is printed. The LSFs are stored in the field
> "line_spec_freq", unless *lsf_fname* is assigned a different name. The
> field has data type REAL and dimension *ac_order*. The parameter
> *lsf_freq_res* has default value 10.0 (see *rc_reps* (3-ESPS)).

*fftcep_flag - integer*  
*fftcep_fname - string*  
*fftcep_order - integer*  
*fftcep_deriv - string*  
> If *fftcep_flag* is set to 1, the FFT cepstrum is computed from the
> windowed data frame using the routine *fft_cepstrum_r* (3-ESPS). The
> cepstral data is stored in the field "fft_cepstrum", unless
> *fftcep_fname* is assigned a different name. The parameter
> *fftcep_order* determines the order of the FFT, i.e. the FFT produces
> 2^*fftcep_order* frequencies. If *fftcep_order*=0, a warning message
> is printed. The field has data type REAL and, if *fftcep_deriv* is not
> specified, has dimension 2^*fftcep_order*. If the string
> *fftcep_deriv* is defined, the routine *grange_switch* (3-ESPS) is
> used to to parse the string to determine which elements of the
> 2^*fftcep_order* cepstral coefficients are to form the output field.
> For example if the entry\
> **string fftcep_deriv = "1,11:20";**\
> appears in the parameter file, the output field has 21 elements taken
> from positions 0, and 11 through 20 in the cepstral sequence. If
> *fftcep_deriv* specifies points outside the range
> (0:2^(*fftcep_order*)-1), *acf* prints a warning and exits.

*fft_flag - integer*  
*fft_order - integer*  
> If the flag *fft_flag* is set to 1, the FFT of the windowed data frame
> is stored in *fea_file*. The order of the FFT is *fft_order*, i.e.
> 2^*fft_order* negative and positive frequencies are computed. If
> *fft_flag* is set, *fea_file* has FEA subtype FEA_SPEC, and the data
> format is SPFMT_SYM_EDGE, and is stored in decibels (log power) (see
> FEA_SPEC (5-ESPS)). If *fft_order* = 0, a warning message is printed;
> the default values of *fft_order* is 10.

*warping_param - float*  
> If *warping_param* is not 0.0, the bilinear transform routine *blt*
> (3-ESPS) is applied to all the following acoustic features being
> computed: lpc cepstrum, FFT cepstrum, FFT complex cepstrum. The
> routine is applied using the parameter *warping_param*. If the
> parameter is outside the range (-1,1), *acf* warns and exits.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 0.

# ESPS COMMON

ESPS Common is not read.

# ESPS HEADER

The parameter file *acf_params* produced by *xacf* is an ASCII file and
has no ESPS header. A comment is inserted in *acf_params* which
indicates the time and date of the most recent change made by *xacf*.

# SEE ALSO

    acf(1-ESPS), exprompt(1-ESPS), xwaves(1-ESPS)

# BUGS

If you do not type a RETURN in an entry field, the entry will not
"take" - i.e., the output parameter file will not contain the new entry.

# FUTURE CHANGES

# AUTHOR

Man page and program by Bill Byrne.
