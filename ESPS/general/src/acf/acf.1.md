# NAME

    acf - Transforms a data sequence into a set of acoustic features.

# SYNOPSIS

**acf** \[ **-P** *param* \] \[ **-{r,s}** *range* \]\[ **-x**
*debug_level* \] *sd_file* *fea_file*

# DESCRIPTION

*Acf* takes a single channel FEA_SD file, reads frames of data, and
produces acoustic features based on each frame. The following acoustic
features are supported: power, zero crossings, Fast Fourier Transform
(FFT), autocorrelation, reflection coefficients, linear prediction
coefficients (LPCs), cepstral coefficients derived from LPCs and
directly from the FFT, log area ratios, and line spectral frequencies.
Mel-warped cepstral features can be generated using the bilinear
Z-transform. Parameters are read by *acf* from the default parameter
file, *params*, or the file specified by the **-P** option.

The initial point of the first frame is determined by the **-r** option
or by *start* in the parameter file. The number of data points in each
frame is *frame_len* and the initial points of any subsequent frames
follow at equal intervals *step.* Thus the 3 cases *step* \<
*frame_len,* *step* = *frame_len,* and *step* \> *frame_len,* correspond
to overlapping frames, exactly abutted frames, and frames separated by
gaps.

The number of frames extracted is the minimum sufficient to cover a
specified range of *nan* points, given *frame_len* and *step*.

The sampled data in each frame optionally may be windowed using a window
function specified by *window_type* in the parameter file. It is
possible to store the windowed data frame can be stored in one of the
fields in the FEA file.

The acoustic features used to form the records in *fea_file* are
selected by the *flag* parameters in the parameter file. If a flag is
set, e.g. an entry **int pwr_flag = 1;** appears in the parameter file,
then the corresponding feature, in this case the power in each frame, is
computed and stored in *fea_file*. Full description of the flag
parameters appears below. Features are stored in separate fields in the
FEA file, which are defined only for the selected features.

The output file, *fea_file*, is a tagged FEA file. If the Fast Fourier
Transform is to be computed, *fea_file* is of feature-file subtype
FEA_SPEC. The tags in each record give the starting point of the frame
in *sd_file*.

If *sd_file* is "-" then the input is read from the standard input and
if *output* is "-" then the output is directed to the standard output.

Note that the menu-based X Windows program *xacf*(1-ESPS) provides an
easy to use interface to *acf*.

# OPTIONS

**-P** *param*  
Uses the parameter file *param* rather than the default, which is
*params*.

**-{r,s}** *first***:"last"**  
**-{r,s}** *first-last*  
**-{r,s}** *first***:+***incr*  
The **-r** and **-s** options specify the range of data to process. Only
one of the two may be used. If **-r** is used, the arguments are in
numbers of samples. If **-s** is used, the arguments are in seconds. In
the first two forms, a pair of positive numbers specifies the range of
sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default is to begin processing at the first
point in the file. If *last* is omitted, then the entire file is
processed; *last* cannot be omitted if reading from standard input. If
the specified range contains points not in the input file, zeros are
appended. Both forms of the option override the values of *start* and
*nan* in the parameter file or ESPS Common file. If these options are
not used, the range is determined from the ESPS Parameter or Common file
if the appropriate parameters are present. If the **-s** option is used,
the field *record_freq* in the input header is used to translate the
units in seconds to numbers of samples. If **-s** is used and
*record_freq* is undefined, or is 0, *acf* warns and exits.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

# ESPS PARAMETERS

*Acf* requires that a parameter file be present. If *acf* is called
without the **-P** option, the file *params* must be present. If the
**-P** option is used, the specified file must be present. If the
appropriate parameter file exists, the parameters listed below are read
from it .

Note that some integer parameters are flags, e.g. *sd_flag*, *pwr_flag*.
These flags determine which acoustic features are stored in *fea_file*.
If the value assigned to a flag parameter is **1**, the associated
acoustic field is computed and stored in a field in the output record.
If any value other than **1** is assigned to a flag parameter, the
acoustic feature associated with the flag is not stored in *fea_file*.
By default, no flags are set, so if a flag is not set explicitly in the
parameter file, the associated acoustic feature will not be stored in
*fea_file* .

There are default field names for all the acoustic featues. These can
all be changed using the field name parameters, e.g. *sd_fname*,
*pwr_fname*. Unless otherwise noted, acoustic features have data type
REAL and dimension 1.

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
> "samples". This parameter is not read if the **-r** or the **-s**
> option is used.

*start - float*  
> The first point in the input sampled data file that is processed. The
> first sample in the file is denoted by 1 if *units="samples"* or by 0
> if *units="seconds"*. If it is not in the parameter (or Common) file,
> the default is to begin processing at the begining of the file. This
> parameter is not read if the **-r** or the **-s** option is used.

*nan - float*  
> The total amount of data to process. If *nan* is 0 and the input is
> not a pipe, the whole file is processed. If *nan* is 0 and the input
> is a pipe, *acf* warns and exits. If *nan* is not specified, the value
> 0 is used as its default. *Nan* is not read if the **-r** or **-s**
> option is used.

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
> computed as in the program *zcross*(1-ESPS). The number of
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
> *get_atal*(3-ESPS). The parameter *ac_order* determines the number of
> prediction coefficients which are computed. If *ac_order*=0, a warning
> message is printed. The coefficients are stored in the field
> "lpc_coeffs", unless *lpc_fname* is assigned a different name. The
> field has data type REAL and dimension *ac_order*.

*lpccep_flag - integer*  
*lpccep_fname - string*  
*lpccep_order - integer*  
*lpccep_deriv - string*  
> If *lpccep_flag* is set to 1, cepstral coefficients are computed from
> reflection coefficients found from the windowed data frame. The
> program *get_atal*(3-ESPS) is used to compute *ac_order* reflection
> coefficients; *lpccep_order* cepstral coefficients are obtained using
> *rc_reps*(3-ESPS). If *ac_order* is not defined or is 0, it is set to
> *lpc_order*; if *lpccep_order* is zero, it is set to *ac_order*. If
> *ac_order* \< *lpccep_order*, the reflection coefficients are padded
> with *lpccep_order*-*ac_order* zeros before the cepstral coefficients
> are computed. If *lpccep_order* \< *ac_order*, *acf* sets
> *lpccep_order* to *ac_order*.
>
> The cepstral coefficients are stored in the field "lpc_cepstrum",
> unless *lpccep_fname* is assigned a different name. The field has data
> type REAL and, if *lpccep_deriv* is not specified, has dimension
> *lpccep_order*. If the string *lpccep_deriv* is defined, the routine
> *grange_switch*(3-ESPS) is used to to parse the string to determine
> which elements of the *lpccep_order* cepstral coefficients are to form
> the output field. For example if the entry\
> **string lpccep_deriv = "0,11:20";**\
> appears in the parameter file, the output field has 21 elements taken
> from positions 0, and 11 through 20 in the cepstral sequence. If
> *lpccep_deriv* specifies points outside the range
> \[0:*lpccep_order*-1\], *acf* prints a warning and exits.

*lar_flag - integer*  
*lar_fname - string*  
> If *lar_flag* is set to 1, log area ratios (LARs) are computed from
> the reflection coefficients found from the windowed data frame. The
> reflection coefficients are found as above, and the LARs are obtained
> using *rc_reps*(3-ESPS). The parameter *ac_order* determines the
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
> are obtained using *rc_reps*(3-ESPS). The parameter *ac_order*
> determines the number of LSFs which are computed. If *ac_order*=0, a
> warning message is printed. The LSFs are stored in the field
> "line_spec_freq", unless *lsf_fname* is assigned a different name. The
> field has data type REAL and dimension *ac_order*. The parameter
> *lsf_freq_res* has default value 10.0 (see *rc_reps*(3-ESPS)).

*fftcep_flag - integer*  
*fftcep_fname - string*  
*fftcep_order - integer*  
*fftcep_deriv - string*  
> If *fftcep_flag* is set to 1, the FFT cepstrum is computed from the
> windowed data frame using the routine *fft_cepstrum_r*(3-ESPS). The
> cepstral data is stored in the field "fft_cepstrum", unless
> *fftcep_fname* is assigned a different name. The parameter
> *fftcep_order* determines the order of the FFT, i.e. the FFT produces
> 2^*fftcep_order* frequencies. If *fftcep_order*=0, a warning message
> is printed. The field has data type REAL and, if *fftcep_deriv* is not
> specified, has dimension 2^*fftcep_order*. If the string
> *fftcep_deriv* is defined, the routine *grange_switch*(3-ESPS) is used
> to to parse the string to determine which elements of the
> 2^*fftcep_order* cepstral coefficients are to form the output field.
> For example if the entry\
> **string fftcep_deriv = "0,11:20";**\
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
> FEA_SPEC(5-ESPS)). If *fft_order* = 0, a warning message is printed;
> the default values of *fft_order* is 10.

*warp_param - float*  
> If *warp_param* is not 0.0, the bilinear transform routine
> *blt*(3-ESPS) is applied to the lpc cepstrum and FFT cepstrum using
> the parameter *warp_param*. Warping is performed before elements are
> extracted from the cepstral sequences (see parameters *lpccep_deriv*
> and *fftcep_deriv*). If the parameter is outside the range (-1,1),
> *acf* warns and exits.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 0.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *sd_file,* in which case
parameters present in Common override values from the parameter file,
which in turn may be overriden by command line options (see the
discussion in ESPS PARAMETERS and under each option). Common is not read
if *input* is standard input. If *output* is not standard output and
*input* is not standard input, the Common parameters *filename* (=
sd_file), *prog* (= acf), *start,* and *nan* are written to ESPS Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 0 is assumed.

# ESPS HEADER

A new file header is created for the FEA file *fea_file*. If the FFT is
computed, the header is of FEA subtype FEA_SPEC. The sampled data header
from the input header is added as a source in the output file header,
and the command line is added as a comment. The input file *input* is
set as the reference header for tags.

The program writes the usual values into the common part of the output
header. *Acf* creates and writes the following generic items in the
output file:


    start = start (LONG)
    nan = nan (LONG)
    frmlen = frame_len (LONG)
    src_sf = sample frequency of input (FLOAT)
    step = step (LONG)
    window_type = window_type (CODED) (not written for RECT window)
    warp_param = warp_param (FLOAT)
    preemphasis = preemphasis (FLOAT)
    start_time (DOUBLE)
    record_freq (DOUBLE)

The value written for *start_time* is computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the relative time from the
first record in the file to the first record processed. The generic
header item *record_freq* is the number of output records per second of
input.

The following generic header items are created based on entries in the
parameter file:


    source_field_name = sd_field_name (STRING)
    sd_flag = sd_flag (SHORT)
    sd_fname = sd_fname (STRING)
    pwr_flag = pwr_flag (SHORT)
    pwr_fname = pwr_fname (STRING)
    zc_flag = zc_flag (SHORT)
    zc_fname = zc_fname (STRING)
    ac_flag = ac_flag (SHORT)
    ac_fname = ac_fname (STRING)
    ac_order = ac_order (STRING)
    rc_flag = rc_flag (SHORT)
    rc_fname = rc_fname (STRING)
    lpc_flag = lpc_flag (SHORT)
    lpf_fname = lp_fname (STRING)
    lpccep_flag = lpccep_flag (SHORT)
    lpccep_fname = lpccep_fname (STRING)
    lpccep_order = lpccep_order (STRING)
    lpccep_deriv = lpccep_deriv (STRING)
    lar_flag = lar_flag (SHORT)
    lar_fname = lar_fname (STRING)
    lsf_flag = lsf_flag (SHORT)
    lsf_fname = lsf_fname (STRING)
    lsf_freq_res = lsf_freq_res (FLOAT)
    fftcep_flag = fftcep_flag (SHORT)
    fftcep_fname = fftcep_fname (STRING)
    fftcep_order = fftcep_order (SHORT)
    fftcep_deriv = fftcep_deriv (STRING)
    fft_flag = fft_flag (SHORT)
    fft_order = fft_order (SHORT)

# SEE ALSO

    frame(1-ESPS), pwr(1-ESPS), refcof(1-ESPS), sgram(1-ESPS), 
    zcross(1-ESPS), get_rfft(3-ESPS), fft_cepstrum_r(3-ESPS), 
    get_auto(3-ESPS), get_atal(3-ESPS), rc_reps(3-ESPS),
    grange_switch(3-ESPS), FEA(5-ESPS), FEA_SPEC(5-ESPS)

# BUGS

# FUTURE CHANGES

# AUTHOR

Man page and program by Bill Byrne (based on frame.c by John Shore).
