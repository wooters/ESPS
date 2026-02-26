# NAME

clip - apply clipping or center clipping to FEA fields

# SYNOPSIS

**clip** \[ **-c** *range* \] \[ **-f** *input_field* \[ **-f**
*output_field* \]\] \[ **-m** *range* \] \[ **-r** *range* \] \[ **-x**
*debug_level* \] \[ **-C** *const_value* \] \[ **-P** *params* \] *input
output*

# DESCRIPTION

*clip* accepts a FEA file *input* containing arbitrary fields. It
produces a FEA file *output* with records that are copies of the input
records except that there is a field *output_field* containing the
results of applying specified clipping or \`\`center-clipping''
operations to each element of the selected field *input_field.* It is
possible to limit the the field elements to a given maximum or minimum
(see the **-m** option) or to replace all values in a given range with a
given constant value (see **-c** and **-C**). The output field has the
same size, rank, dimensions, and data type as *input_field.* If run on
complex data, the program will simply treat the real and imaginary parts
separately as real data. Normally, *output_field* is a new field,
different from any in the input file. However, the output field may
replace an existing field, including *input_field.* In that particular
case, the program transforms the contents of *input_field* by applying
the specified operations to each element.

If *input* is "-", standard input is used for the input file. If
*output* is "-", standard output is used for the output file. The input
and output should not be the same file; however, it is okay to run the
program as a filter by specifying "-" for both input and output.

Note that the **-f** option is used to specify both the input and output
field names. If an output name isn't specified (the option is used
once), the output name defaults to the input name followed by the suffix
"\_CLIP".

*clip* preserves FEA subtype information---for example, if the input is
a FEA_SPEC file, the output file header will contain the subtype code
indicating a FEA_SPEC file, and the output file will in fact be a
FEA_SPEC file if one precaution is observed. Namely, if the output field
is one that the FEA subtype specification subjects to requirements, it
is the user's responsibility to see that the requirements are not
violated. It is always legitimate to add a new field with a name not
mentioned in the subtype specification.

For scaling and shifting data, type conversion, and more general
computations and transformations, see programs *copysd*(1-ESPS),
*copysps*(1-ESPS), *feafunc*(1-ESPS), and *select*(1-ESPS).

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-c** *ctr_min***:***ctr_max* **\[(none):(none)\]**  
**-c** *ctr_min***:+***incr*  
In the first form, a pair of real numbers specifies a range for
\`\`center-clipping.'' (Decimal point and "e" followed by exponent are
optional.) Input values between *ctr_min* and *ctr_max* are replaced in
the output with a specified value *const_value.* That is the argument of
the **-C** option if **-C** is specified. Otherwise *const_value* is
taken from the parameter file, and if no value is found there, the
default value of 0 is used. The second form specifies the same range as
the first with *ctr_max* = *ctr_min* + *incr.* If **-c** is specified,
*ctr_min* and *ctr_max* (or *ctr_min* and *incr*) must both be given
explicitly, and neither value is read from the parameter file.

**-f** *field_name* **\[samples\]**  
**-f** *field_name* **\[(input field name)\_CLIP\]**  
If this option is used once, it specifies the name of the source field
*input_field* in *input*. If it is used twice, the second time it
specifies the name of the destination field *output_field* in *output*.
The default name for the input field is "samples". The default name for
the output field is the input field followed by the suffix "\_CLIP". If
the output field has the same name as some field in the input file, the
original contents of the field are lost. A warning message is normally
printed in that case. However, if the output field is specified as "-",
the name of the input field is used instead, and the warning message is
suppressed.

**-m** *clip_min***:***clip_max* **\[(minus infinity):(plus infinity)\]**  
**-m** *clip_min***:+***incr*  
In the first form, a pair of real numbers specifies a range for
clipping. (Decimal point and "e" followed by exponent are optional.)
Input values of *clip_min* or less are replaced in the output with
*clip_min,* and input values of *clip_max* or greater are replaced in
the output with *clip_max.* Either *clip_min* or *clip_max* may be
omitted, implying the default: no clipping on that side. The second form
specifies the same range as the first with *clip_max* = *clip_min* +
*incr.* If this option is specified, neither *clip_min* nor *clip_max*
is read from the parameter file.

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***incr*  
**-r** *start*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *start* or *last* may be omitted; then
the default value is used. If *last* = *start* + *incr,* the second form
(with the plus sign) specifies the same range as the first. The third
form (omitting the colon) specifies a single record. The **-r**
overrides the values of *start* and *nan* from the parameter file. The
value of *nan* becomes 1 + *last* - *start* (first form), 1 + *incr*
(second form), or 1 (third form).

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

**-C** *const_value* **\[0\]**  
Input values in the range from *ctr_min* to *ctr_max* (see **-c**) are
replaced with this value in the output. This option is ignored unless
**-c** is also specified or the parameter-file values *ctr_min* and
*ctr_max* are given. This value overrides any value for *const_value*
specified in a parameter file. If the option is not specified and no
value is specified in a parameter file, the default of 0 is used.

**-P** *param* **\[params\]**  
The name of the parameter file.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*ctr_min - float*  
*ctr_max - float*  
> These are the limits of the interval for \`\`center-clipping'': the
> operation described under the **-c** option. The values in the
> parameter file are ignored if the option is specified. If **-c** is
> not specified, the parameter file must either contain both of these
> values or contain neither. In the former case center-clipping is done,
> and in the later case it isn't.

*clip_min - float*  
*clip_max - float*  
> These are the limits of the inverval for the clipping operation
> described under the **-m** option. The values in the parameter file
> are ignored if the option is specified. If **-m** is not specified,
> then *clip_min* is used as a lower bound for clipping if present, and
> *clip_max* is used as an upper bound for clipping if present.

*const_value - float*  
> This is the constant replacement value for the center-clipping
> operation as described under the **-c** option. The value in the
> parameter file is ignored if the **-C** option is specified or if
> center-clipping is not done. If *const_val* is not specified either
> with the **-C** option or in the parameter file, the default value of
> 0 is used.

*input_field - string*  
> This is the name of the selected data field in *input.* The default is
> "samples". A parameter-file value (if present) is overridden by the
> first use of the **-f** option.

*output_field - string*  
> This is the name of the field in *output* in which the result values
> are stored. The default name is that of *input_field* with a suffix
> "\_CLIP". A parameter file value (if present) is overridden by the
> second use of the **-f** option.

*start - integer*  
> This is the first record of *input* to process. The default is 1. It
> is not read if the **-r** option is used.

*nan - integer*  
> This is the number of records to process. It is not read if the **-r**
> option is used. A value of zero means all subsequent records in the
> file; this is the default.

Remember that command line option values override parameter-file values.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

ESPS Common is not processed by *clip* if *input* is standard input.
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

> This is the name of the program (*clip* in this case).
>
> *filename - string*

> The name of the input file *input*.

# ESPS HEADERS

The *output* header is a new FEA file header. All generic header items
are copied from the input header to the output header. The generic
header item *start_time* is written with a value computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the relative time from the
first record in the file to the first record processed. The computation
of *start_time* depends on the value of the generic header item
*record_freq* in the input file. If this item is not present,
*start_time* is just copied from the input file to the output.

The items *start* and *nan* are rewritten (if they already exist) to
contain the starting record number and number of records processed. As
usual, the command line is added as a comment, and the header of *input*
is added as a source file to *output*.

# FUTURE CHANGES

# SEE ALSO

    addfea(1-ESPS), addgen(1-ESPS), copysps(1-ESPS), 
    copysd(1-ESPS), frame(1-ESPS), mergefea(1-ESPS),
    pwr(1-ESPS), select(1-ESPS), feafunc(1-ESPS),
    FEA(5-ESPS)

# WARNINGS AND DIAGNOSTICS

If an unknown option is specified, if **-f** is used more than twice, or
if the number of file names is wrong, *clip* prints a synopsis of
command-line usage and exits. The program exits with an error message if
any of the following are true: *input* does not exist or is not an ESPS
FEA file; *input* is the same as *output* (but not "-"); the
*input_field* does not exist in *input;* the data type of *input_field*
is nonnumeric; a bad range is specified with **-r**. The program prints
a warning and continues if an explicit *output_field* (that is, not
specified as "-") already exists in *input.*

# BUGS

None known.

# AUTHOR

Manual page and program by by Rod Johnson, based on John Shore's
*feafunc.*
