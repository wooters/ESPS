# NAME

cepanal - cepstrum and phase of sampled data

# SYNOPSIS

**cepanal** \[ **-l** *frame_len* \] \[ **-o** *order* \] \[ **-r**
*range* \] \[ **-w** *window_type* \] \[ **-x** *debug_level* \] \[
**-S** *step* \] *input.sd* *phase_out.fea* *cepst_out.fea*

# DESCRIPTION

This is one of a pair of programs that lets one analyze a file of
sampled data to obtain cepstrum and phase information, modify the
cepstrum, and recombine the modified cepstrum with the original phase to
obtain a new sampled-data file. This program analyzes the sampled data
into cepstrum and phase. The program *cepsyn*(1-ESPS) performs the
inverse transformation, combining cepstrum and phase to produce sampled
data. The input file, *input.sd,* must be a single-channel, real
sampled-data file (FEA_SD or equivalent).

*cepanal* forms the input into equally spaced frames of fixed length
(see **-l**, **-S** in the OPTIONS section below), optionally windows
the data (see option **-w**), performs a Fast Fourier Transform on each
frame, and computes the complex logarithm of the Fourier transform. It
saves the phase (the imaginary part of the logarithm) in the output file
*phase_out.fea.* It takes the inverse Fourier transform of the log
magnitude (the real part of the complex logarithm) to obtain the
cepstrum and outputs the result in *cepst_out.fea.* The output cepstrum
is essentially the same as the output of

    fftcep -R -F input.sd output.fea

(see *fftcep*(1-ESPS)) with redundant values (nearly half the total
number) dropped from the end of each record.

The input frames have length *frame_len* (see option **-l**). The
initial point of the first frame is determined by the **-r** option.
Initial points of any subsequent frames follow at equal intervals *step*
(see option **-S**). Thus the 3 cases *step* \< *frame_len,* *step* =
*frame_len,* and *step* \> *frame_len* correspond to overlapping frames,
exactly abutted frames, and frames separated by gaps.

The number of frames is the minimum sufficient to cover the specified
range (see option **-r**). The last frame in the file may overrun the
range, in which case a warning is printed. If a frame overruns the end
of the file, it is filled out with zeros.

The output phase is not unwrapped, is between -pi and pi, and may have
jumps with sizes of nearly 2pi. These discontinuities don't matter when
the phase is used as input to *cepsyn*(1-ESPS).

The output files are ordinary ESPS FEA files, not of any special FEA
subtype, and each contains a single field with data type FLOAT. The
field in *phase_out.fea* is named *phase;* its length is *n*/2 + 1*,*
where *n* is the transform length (see option **-o**). The phase values
correspond to frequencies that run in equal steps from 0 to *sf*/2*,*
where *sf* is the sampling frequency. The field in *cepst_out.fea* is
named *cepstrum;* its length is also one greater than half the transform
length *n* (see **-o**). The cepstrum values correspond to quefrencies
that run in equal steps from 0 to (*n*/2)(1/*sf*).

If *input.sd* is "-", standard input is read. Either *phase_out.fea* or
*cepst_out.fea,* but not both, may be "-", for standard output.

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-l** *frame_len* **\[(transform length)\]**  
The length of each frame. This is also the length of the data window
applied to each frame (see option **-w***).* If the option is omitted or
0, a default value is used: the transform length determined by the FFT
order (see option **-o**).

**-o** *order* **\[10\]**  
The order of the FFT used in the computations; the transform length is
2^*order* (2 to the *order*-th power). This is also the default length
of the frames into which the input sampled-data stream is divided (see
option **-l**). If the frame length is less than the transform length,
each frame is padded with zeros. (This is done after windowingsee option
**-w***).* If the frame length is greater than the transform length,
each frame is truncated after windowing. The default order, 10,
corresponds to a transform length of 1024 and output fields of length
513.

**-r** *first***:***last* **\[1:(last in file)\]**  
**-r** *first***:+***incr*  
**-r** *first*  
In the first form, a pair of unsigned integers specifies the range of
sampled data to analyze. If *first* is omitted, the default value of 1
is used. If *last* is omitted, the range extends to the end of the file.
If *last* = *first* + *incr,* the second form (with the plus sign)
specifies the same range as the first form. The third form (omitting the
colon) specifies a single sample. If the range doesn't end on a frame
boundary, it is extended to make up a full last frame. If a frame
overruns the end of the file, it is filled out with zeros.

**-w** *window_type* **\[RECT\]**  
The name of the data window to apply to the data in each frame. If the
option is omitted, no windowing is done (equivalent to a rectangular
window with amplitude one). Possible window types include rectangular
("RECT"), Hamming ("HAMMING"), Hanning ("HANNING"), cos^4 ("COS4"), and
triangular ("TRIANG"); see the *window*(3-ESPSsp) manual page for the
complete list.

**-x** *debug_level \[0\]*  
A positive value specifies that debugging output is to be printed on the
standard error output. Larger values result in more output. For the
default value, 0, there is no output.

**-S** *step* **\[(frame length)\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted or 0, a default equal to *frame_len* is used
(resulting in exactly abutted frames).

# ESPS PARAMETERS

This program does not access a parameter file.

# ESPS COMMON

The ESPS common file is not read.

If Common processing is enabled, and the output file is not standard
output, the program writes the Common parameters *prog,* *filename,*
*start,* and *nan* to record the program's name, the name of the input
file, the starting sample in the input file, and the number of samples
in the specified range. (A value of 0 for *nan* implies that no explicit
end of range was specified, so that the program continued processing to
the end of the input file.)

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to *off.* The default ESPS Common file is
*espscom* in the user's home directory. This may be overridden by
setting the environment variable ESPSCOM to the desired path. User
feedback of Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

The program reads the header item *record_freq* from the input header,
and it uses *update_waves_gen*(3-ESPS) to process the items *start_time*
and *record_freq* in the standard way.

In addition to *start_time* and *record_freq,* the program add header
items *start,* *nan,* *sf,* *fft_length,* *frmlen,* *step,* and
*window_type* to both output file headers. The values of *start* and
*nan* give the starting sample in the input file and the number of
samples in the specified range. (A value of 0 for *nan* implies that no
explicit end of range was specified, so that the program continued
processing to the end of the input file.) The value of *sf*
(\`\`sampling frequency'') records the value of *record_freq* from the
input file. The value of *fft_length* is the transform length, computed
from the order. The values of *frmlen* and *step* are the frame length
and step (see the options **-l** and **-S**). The item *window_type* is
a coded item that records the window type (see **-w**).

The programs defines fields *phase* in the header of *phase_out.fea* and
*cepstrum* in the header of *cepst_out.fea.* Like most ESPS programs, it
includes copies of the input file header in the ouput headers, and it
saves a copy of the command line as a comment in each output header.

# FUTURE CHANGES

# EXAMPLES

# ERRORS AND DIAGNOSTICS

If an unknown option is specified, or if the number of file names is
wrong, *cepanal* prints a synopsis of command-line usage and exits.

The program exits with an error message if any of the following are
true: the input file name is the same as one of the output file names
(but not "-"); the output file names are the same; the input file
contains multichannel or complex sampled data; a negative FFT order is
specified; a starting sample less than 1 is specified; an empty range of
records is specified; no samples can be read from the input file.

The program prints a message and continues if any of the following
conditions are encountered: the indicated input range does not end on a
frame boundary; the end of the input file is reached when an incomplete
frame has been read; the end of the input file is reached prematurely
according to an explicitly indicated end of range.

# BUGS

None known.

# REFERENCES

# SEE ALSO

*cepsyn*(1-ESPS), *fft*(1-ESPS), *fftcep*(1-ESPS),\
*fftinv*(1-ESPS) *update_waves_gen*(3-ESPS)

# AUTHOR

Rod Johnson
