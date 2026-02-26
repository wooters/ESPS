# NAME

dither - add half-tone bit-map version of spectrogram to FEA_SPEC or
other FEA file.

# SYNOPSIS

**dither** \[ **-x** *debug_level* \] \[ **-P** *params* \] *input.fea
output.fea*

# DESCRIPTION

*Dither* accepts a FEA file *input.fea* containing a vector field of
power-spectrum values in each record. It produces a FEA file
*output.fea* with records that are copies of the input records plus an
additional field containing 1s and 0s intended for display as a
simulated gray-scale spectrogram on a black-and-white monitor. The
default name for the spectral-value field in *input.fea* is
*re_spec_val,* and the default name for the new field in *output.fea* is
*dith_spec_val.* Both defaults can be changed by means of entries in a
parameter file. If *input.fea* is "-", standard input is used for the
input file. If *output.fea* is "-", standard input is used for the
output file.

# OPTIONS

The following options are supported:

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

**-x** *debug_level*  
Positive values of *debug_level* cause debugging information to be
printed; higher values produce more messages. The default value is 0,
which suppresses the messages.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*spec_field_name - string*  
> This is the name of the spectral-value data field in *input.fea.* The
> default is "re_spec_val".

*dspec_field_name - string*  
> This is the name of the half-tone (\`\`dithered'') field in
> *output.fea.* The default is "dith_spec_val".

*start - integer*  
> This is the first record of *input* to process. The default is 1.

*nan - integer*  
> This is the number of records to process. A value of zero means all
> subsequent records in the file; this is the default.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

ESPS Common is not processed by *dither* if *input* is standard input.
Otherwise, provided that the Common file is newer than the parameter
file, and provided that the *filename* entry in Common matches *input*,
the Common values for *start* and *nan* override those that may be
present in the parameter file.

The following items are written into the ESPS Common file provided that
*output* is not \<stdout\>.

> *start - integer*

> The starting point from the input file.
>
> *nan - integer*

> The number of points in the selected range.
>
> *prog - string*

> This is the name of the program (*dither* in this case).
>
> *filename - string*

> The name of the input file *input.fea.*

# ESPS HEADERS

The output header is a new FEA file header, with appropriate items being
copied from the input header, including all generic header items. As
usual, the command line is added as a comment and the header of
*input.fea* is added as a source file to *output.* Another comment gives
the name of the field added by *dither.*

# FUTURE CHANGES

Command-line options for setting the parameters *start,* *nan,*
*spec_field_name,* and *dspec_field_name.* Explicit controls over
thresholds used by the dithering algorithm.

# SEE ALSO

*image* (1-ESPS), FEA (5-ESPS), FEA_SPEC (5-ESPS)

# WARNINGS AND DIAGNOSTICS

*Dither* will exit with an error message if the output field name
conflicts with the name of a field in the input file, if the
spectral-value field does not exist in the input file, if the values of
*start* and *nan* are inconsistent, or if the program had problems in
allocating memory, creating the output field, or writing to common.
Also, the input field must be of type BYTE or FLOAT.

# BUGS

None known.

# AUTHOR

Manual page and program by Rodney Johnson.
