# NAME

cepsyn - recover sampled data from cepstrum and phase

# SYNOPSIS

**cepsyn** \[ **-r** *range1* \[ **-r** *range2* \]\] \[ **-t**
*output_type* \] \[ **-x** *debug_level* \] \[ **-W** \] *phase_in.fea*
*cepst_in.fea* *output.sd*

# DESCRIPTION

This is one of a pair of programs that lets one analyze a file of
sampled data to obtain cepstrum and phase information, modify the
cepstrum, and recombine the modified cepstrum with the original phase to
obtain a new sampled-data file. The program *cepanal*(1-ESPS) analyzes
the sampled data into phase and cepstrum data in separate output files.
This program performs the inverse transformation, combining phase and
cepstrum data in *phase_in.fea* and *cepstrum_in.fea* to produce sampled
data in *output.sd.*

Either input file, but not both, may be "-", for standard input. If "-"
is given for the output file, the output is written to the standard
output.

The input files, *phase_in.fea* and *cepst_in.fea* should have the same
format as the output files of *cepanal*(1-ESPS). Namely, they are
ordinary ESPS files, not of any special FEA subtype, each containing a
single field with data type FLOAT. The fields are named *phase* and
*cepstrum,* respectively; they must have the same length, namely *n*/2 +
1, where *n* is the length of the Fourier transform used in *cepanal.*
(Thus *n* is 2 raised to the power *order,* where *order* is the order
of the transform. See the option **-o** in the man page for
*cepanal*(1-ESPS)).

Each input field implicitly determines a vector of the full transform
length, *n,* by symmetry, in the case of *cepstrum,* or antisymmetry
(mod 2pi), in the case of *phase.* The program performs a Fast Fourier
Transform on each vector of cepstral data from *cepst_in.fea,* obtaining
a real result (because of the symmetry). To this it adds an imaginary
part consisting of the vector of phase data from the corresponding frame
in *phase_in.fea.* It then computes the inverse Fourier transform of the
exponential of the resulting complex quantity, obtaining frames of
sample data, which it combines to form the contents of an ESPS FEA_SD
file, It normally attempts to compensate at the same time for any
windowing performed by *cepanal*: it divides the overlapped sum of the
sampled-data frames by a similarly overlapped sum of translated copies
of the window function, obtaining an overlapped average of the frames.
For this to succeed, the latter sum must not contain zeros; otherwise a
message is printed, and the division step is skipped. This behavior can
be modified by the **-W** option (see below).

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-r** *first***:***last* **\[1:(last in file)\]**  
**-r** *first***:+***incr*  
**-r** *first*  
The range of records to be taken from one or both input files. In the
first form, a pair of unsigned integers specifies the range of records
to analyze. If *first* is omitted, the default value of 1 is used. If
*last* is omitted, the range extends to the end of the file. If *last* =
*first* + *incr,* the second form (with the plus sign) specifies the
same range as the first form. The third form (omitting the colon)
specifies a single record. Note that for this program the range is
specified in frames, whereas for *cepanal*(1-ESPS) it is specified in
samples.

This option may be used at most twice. If used once, it applies to both
input files. If used twice, it applies to *phase_in.fea* the first time
and *cepst_in.fea* the second time. If the option is used twice and
implies ranges of inconsistent sizes, a warning message may be issued.
For example **-r** 1**:**10 and **-r** 101**:**120 in the same *cepsyn*
command will generate a warning of inconsistent **-r** options. On the
other hand two options with one unspecified endpoint, like **-r** 1**:**
and **-r** 101**:**120, are not considered inconsistent and will not
generate the warning.

**-t** *output_type* **\[FLOAT\]**  
The data type of the output sampled data.

**-x** *debug_level \[0\]*  
A positive value specifies that debugging output is to be printed on the
standard error output. Larger values result in more output. For the
default value, 0, there is no output.

**-W**  
Specifying this option causes the program to ignore the input header
item *window_type* and assume a rectangular window.

# ESPS PARAMETERS

This program does not access a parameter file.

# ESPS COMMON

The ESPS Common file is not read.

If Common processing is enabled, and the output file is not standard
output, the program writes the Common parameters *prog,* *filename,*
*start,* and *nan* to record the program's name, the name of the output
file, the starting record number of the output file (always 1), and the
number of points in the output file.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to *off.* The default ESPS Common file is
*espscom* in the user's home directory. This may be overridden by
setting the environment variable ESPSCOM to the desired path. User
feedback of Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

The program reads the header items *sf,* *framelen,* *record_freq,*
*start_time* *step,* and *window_type* from the header of
*phase_in.fea.* It relies on the phase file for these items since they
are more likely to be preserved intact there than in the cepstrum file.
However, it also reads certain of the corresponding items from
*cepst_in.fea* and prints a message in case of inconsistency.

The program defines the standard ouput header items *start_time* and
*record_freq* and includes the normal field definition for a FEA_SD file
in the output header (see *init_feasd_hd*(3-ESPS)). Like most ESPS
programs, it includes copies of the input file headers in the ouput
header (see *add_source_file*(3-ESPS)), and it saves a copy of the
command line as a comment in the output header (see
*add_comment*(3-ESPS) and *get_cmd_line*(3-ESPS)).

# FUTURE CHANGES

# EXAMPLES

# ERRORS AND DIAGNOSTICS

If an unknown option is specified, if the **-r** option is used more
than two times, or if the number of file names is wrong, *cepsyn* prints
a synopsis of command-line usage and exits. The program exits with an
error message if any of the folowing are true: the output file name is
the same as one of the input file names (but not "-"); the input file
names are the same; the field *phase* in *phase_in.fea* is absent or not
FLOAT; the field *cepstrum* in *cepst_in.fea* is absent or not FLOAT;
the fields *phase* and *cepstrum* have different sizes; the size of the
fields *phase* and *cepstrum* does not correspond to an integer order
(i.e. is is not of the form *n*/2 + 1, where *n* is a power of 2); the
generic header items *frmlen,* *sf,* and *record_freq* in *cepst_in.fea*
are not all present or do not all have positive numerical values; a
**-r** option specifies a starting record before the beginning of the
file or specifies an empty range of records; two **-r** options specify
ranges with different explicit lengths; the **-t** option does not
specify a valid numeric data type; an attempt to write an ESPS common
file failed. The program prints a message and continues if any of the
following conditions are encountered: one of the generic header items
*frmlen,* *sf,* and *record_freq* in *cepst_in.fea* (if present)
specifies a value inconsistent with *phase_in.fea;* the two input file
headers, together with any range options, specify inconsistent values of
*start_time;* the end of the input file is reached prematurely according
to an explicitly indicated end of range.

# BUGS

None known.

# REFERENCES

# SEE ALSO

*cepanal*(1-ESPS), *fft*(1-ESPS), *fftcep*(1-ESPS),\
*fftinv*(1-ESPS), *init_feasd_hd*(3-ESPS),\
*add_source_file*(3-ESPS), *add_comment*(3-ESPS),\
*get_cmd_line*(3-ESPS).

# AUTHOR

Rod Johnson
