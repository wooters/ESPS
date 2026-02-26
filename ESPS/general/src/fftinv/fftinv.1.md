# NAME

fftinv - Inverse Fast Fourier Transform of ESPS FEA_SPEC file to FEA_SD
file

# SYNOPSIS

**fftinv** \[ **-r** *range* \] \[ **-t** *output_type* \] \[ **-x**
*debug_level* \] *specfile* *sdfile*

# DESCRIPTION

*Fftinv* takes an input ESPS spectral record file (FEA_SPEC file),
*specfile,* and takes the inverse Fast Fourier Transform of one or more
records to produce an ESPS sampled-data file (FEA_SD file) *sdfile.* If
the input file name *specfile* is replaced by "-", then stdin is read;
similarily, if *sdfile* is replaced by "-", then the output is written
to stdout.

The input FEA_SPEC file must have spectral type SPTYP_CPLX and frequency
format SPFMT_ASYM_EDGE - i.e., the full complex spectrum is stored. Such
spectral records are produced by *fft* (1-ESPS) using the **-c** option.

# OPTIONS

The following options are supported:

**-r** *first***:***last*  
**-r** *first***-***last*  
**-r** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of input records to process. If *last* = *first* + *incr,* the third
form (with the plus sign) specifies the same range as the first two
forms. If *first* is omitted, the default value of 1 is used. If *last*
is omitted, then all records from *first* are processed.

**-t** *output_type*  
Specifies the ESPS data type of the output sampled-data file. Allowable
values are DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, and BYTE_CPLX. Results are computed as float or
float_cplx and converted to the specified type. If one of the 5 real
types is specified, the output is the real part of the
inverse-transformed data; the imaginary part is simply discarded with no
check to determine whether it is negligible. If the option is not
specified, the generic header item *input_data* is read from the input
file. If if the item exists and has the string "real" as its value, the
output FEA_SD file is of type FLOAT and contains only the real part of
the inverse transform. Otherwise the output FEA_SD file has type
FLOAT_CPLX.

**-x** *debug_level \[0\]*  
Specifies that debugging output be printed on stderr; larger values of
*debug_level* result in more output. The default is for no output.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

The ESPS Common file is not read or written.

# ESPS HEADERS

The generic header items *spec_type* and *freq_format* are read from the
input file and checked to assure that they have the required values,
SPTYP_CPLX and SPFMT_ASYM_EDGE.

The generic header item *num_freqs* is read from the input file and
determines the length of the inverse Fourier transform; the transform
length is 1 less than the value of *num_freqs* because of the way
spectral values are ordered in the ASYM_EDGE format: the zero-frequency
value is in the middle, preceded by the negative-frequency values and
followed by the positive-frequency values, with the value at the folding
frequency duplicated as both the first and the last value. The transform
length is written as the header item *inv_fft_length* in the output
file. The generic header item *fft_length,* if it exists, is read from
the input file and checked for consistency; if it is different from the
transform length determined from *num_freqs,* a warning is written on
*stderr.*

The generic header item *sf* is read from the input file if present and
determines the value used for the sampling frequency; otherwise a
default of 8000 Hz is used. This value is written as the header item
*record_freq* in the output file and is used for scaling and other
purposes during the computation.

The number of samples in the first input frame is obtained, either from
the generic header item *frmlen* or from the field *frame_len* in the
first record. One half this frame length is converted to seconds, with
the sampling frequency as the conversion factor; the resulting value is
the offset from the beginning of the first input frame to the middle.
The *start_time* header item is read from the input file if present;
otherwise a default of 0 is used. This is assumed to refer to the middle
of the first frame. The offset determined from the length of the first
frame is subtracted to get the time corresponding to the beginning of
the first frame. A second adjustment to this value determines the value
to be written as the *start_time* header item of the output file: adding
the offset from the first record of the input file to the first record
actually processed.

If the **-t** option is not specified, the generic header item
*input_data,* if it exists, is read from the input file and determines
the data type of the output file as specified in the discussion of the
option.

# FUTURE CHANGES

# SEE ALSO

fft (1-ESPS), plotsd (1-ESPS), get_fft_inv (3-ESPS), FEA_SD(5-ESPS),
FEA_SPEC(5-ESPS), ESPS(5-ESPS).

# BUGS

None known.

# REFERENCES

J. W. Cooley and J. W. Tukey, "An Algorithm for the Machine Calculation
of Complex Fourier Series," *Math. Computation*, Vol. 19, 1965, pp.
297-301.

Alan V. Oppenheim and Ronald W. Schafer, *Digital Signal Processing*.
Englewood Cliffs, New Jersey: Prentice-Hall, Inc., 1975.

# AUTHOR

manual page and program by John Shore, using library function by Shankar
Narayan. Modified to write FEA_SD files by David Burton.
