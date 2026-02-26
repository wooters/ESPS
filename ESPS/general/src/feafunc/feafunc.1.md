# NAME

feafunc - apply optional function, gain factor, additive constant, and
type change to FEA fields

# SYNOPSIS

**feafunc** \[ **-d** *add_constant* \] \[ **-f** *input_field* \[
**-f** *output_field* \]\] \[ **-g** *gain_factor* \] \[ **-r** *range*
\] \[ **-t** *output_type* \] \[ **-x** *debug_level* \] \[ **-F**
*function* \] \[ **-P** *params* \] *input output*

# DESCRIPTION

*feafunc* accepts a FEA file *input* containing arbitrary fields. It
produces a FEA file *output* with records that are copies of the input
records except that there is a field *output_field* containing the
values of the functional form *g\*F(element) + d* for each element of
the selected field *input_field*. Here *g* is a multiplicative constant,
*F* is a single-valued scalar function (*none, abs, arg, atan, conj,
cos, exp, exp10, im, log, log10, re,* recip, sgn, sin, sqrt, sqr, tan),
and *d* is an additive constant. The output field has the same size,
rank, and dimensions as *input_field* and, by default, the same data
type. However, with the **-t** option, the result may be converted to an
arbitrary numeric data type. Normally, *output_field* is a new field,
different from any in the input file. However, the output field may
replace an existing field, including *input_field.* In that particular
case, the program transforms the contents of *input_field* by applying
the functional form to each element.

If *input* is "-", standard input is used for the input file. If
*output* is "-", standard output is used for the output file. The input
and output should not be the same file; however, it is okay to run the
program as a filter by specifying "-" for both input and output.

The defaults for **-F**, **-g**, and **-a** respectively are "none", 1,
and 0. ("None" is a function that just returns the input value---i.e.,
it does not modify the argument.) These defaults imply no changes at all
to the data, which is useful since *feafunc* can then be used to change
the name or numeric type of a field.

Note that the **-f** option is used to specify both the input and output
field names. If an output name isn't specified (the option is used
once), the output name defaults to the input name followed by a suffix
giving the name of the applied function.

Function values *F(element)* are computed by the ESPS function
*arr_func*(3-ESPSsp). See the *arr_func* manual entry for more
information on particular functions *F.* The result is as though the
input values were converted to DOUBLE_CPLX, the computations done with
complex arithmetic, and the result converted to the output type. A more
direct method is actually used internally when the input and output
types and the multiplicative and additive constants permit; for example,
if these are all real, real arithmetic is used. Type conversions are
done by *type_convert*(3-ESPS). Briefly, conversion from complex to real
discards the imaginary part, conversion from float or double to an
integral type rounds rather than truncating, and conversion from one
type to another type with a narrower numerical range may entail
clipping; in the latter case a warning message is printed. See the
*type_convert* manual page for more details on type conversions.

*feafunc* preserves FEA subtype information---for example, if the input
is a FEA_SPEC file, the output file header will contain the subtype code
indicating a FEA_SPEC file, and the output file will in fact be a
FEA_SPEC file if one precaution is observed. Namely, if the output field
is one that the FEA subtype specification subjects to requirements, the
requirements must not be violated. It is unadvisable, for instance,
though possible, to use *feafunc* with the **-t** option to make a file
that appears to be a FEA_SPEC file but has a field named *re_spec_val*
whose data type is LONG_CPLX. (The *FEA_SPEC*(5-ESPS) manual entry
requires it to be FLOAT or BYTE.) It is always legitimate to add a new
field with a name not mentioned in the subtype specification.

For scaling and shifting the data in FEA_SD files, *copysd*(1-ESPS) is
probably a better choice than *feafunc*. For changing types and formats
in FEA_SPEC files, *copysps*(1-ESPS) is probably better. For more
general computations, consider *select*(1-ESPS).

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-d** *add_constant \[0\]*  
Specifies an additive constant *d* for the expression *g\*F(element) +
d* that is computed for each element of *input_field* and stored in the
output file. The function *F* and the multiplicative constant in the
expression are obtained respectively from the **-F** and **-g** options.
A complex constant is specified with a comma, in the form
*real_part***,***imaginary_part.*

**-f** *field_name* **\[samples\]**  
**-f** *field_name* **\[(input field name plus suffix)\]**  
**-f -**  
If this option is used once, it specifies the name of the source field
*input_field* in *input*. If it is used twice, the second time it
specifies the name of the destination field *output_field* in *output*.
The default name for the input field is "samples". The default name for
the output field is the input field followed by a suffix identifying the
function type (see **-F**). If the output field has the same name as
some field in the input file, the original contents of the field are
lost. A warning message is normally printed in that case. However, if
the output field is specified as "-", the name of the input field is
used instead, and the warning message is suppressed.

**-g** *gain_factor \[1\]*  
Specifies a multiplicative constant (gain factor) for the expression
*g\*F(element) + d* that is computed for each element of the
*input_field* and stored in the *output_field*. The function *F* and the
additive constant in the expression are obtained respectively from the
**-F** and **-d** options. A complex factor is specified with a comma,
in the form *real_part***,***imaginary_part.*

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

**-t** *output_type* **\[(same as input)\]**  
Specifies the type of the *output_field*. Allowable values are DOUBLE,
FLOAT, LONG, SHORT, BYTE, (or CHAR), DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX,
SHORT_CPLX, and BYTE_CPLX. The case doesn't matter: upper is not
distinguished from lower. The default type is the same type as that of
the *input_field*.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

**-F** *function \[none\]*  
Specifies a function *F* to be applied to each element of the
*input_field* before storing *g\*F(element) + d* in the output file. The
possible functions are *abs* (absolute magnitude), *arg* (phase angle),
*atan* (arctangent), *conj* (complex conjugate), *cos* (cosine), *exp*
(exponential), *exp10* (10 to the given power), *im* (imaginary part),
*log* (natural logarithm), *log10* (base 10 logarithm), *none* (no
change---the identity function), *re* (real part), *recip* (reciprocal),
*sgn* (signum; for a complex number *z* off the real axis, the value is
*z*/\|*z*\|), *sin* (sine), *sqr* (square), *sqrt* (square root), *tan*
(tangent). The case doesn't matter: upper is not distinguished from
lower. The multiplicative and additive constants in the expression
*g\*F(element) + d* are obtained from the **-g** and **-d** options. The
default function ("none") does nothing: it just returns its argument
unchanged.

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*add_real - float*  
> This is the value for *d* in the expression *g\*F(element) + d*, or
> the real part of *d* if *d* is complex. The default is 0. This
> parameter is not read if the **-d** option is used.

*add_imag - float*  
> This is the imaginary part of *d* in the expression *g\*F(element) +
> d*. The default is 0. This parameter is not read if the **-d** option
> is used.

*input_field - string*  
> This is the name of the selected data field in *input*. The default is
> "samples". A parameter file value (if present) is overridden by the
> first use of the **-f** option.

*output_field - string*  
> This is the name of the *output* field in which the the values of
> *g\*F(element) + d* are stored. The default name is that of
> *input_field* with a suffix that identifies the function *F*. A
> parameter file value (if present) is overridden by the second use of
> the **-f** option.

*gain_real - float*  
> This is the factor *g* in the expression *g\*F(element) + d*, or the
> real part of *g* if *g* is complex. The default is 1. This parameter
> is not read if the **-g** option is used.

*gain_imag - float*  
This is the imaginary part of *g* in the expression *g\*F(element) + d*.
The default is 0. This parameter is not read if the **-g** option is
used.

*start - integer*  
> This is the first record of *input* to process. The default is 1. It
> is not read if the **-r** option is used.

*nan - integer*  
> This is the number of records to process. It is not read if the **-r**
> option is used. A value of zero means all subsequent records in the
> file; this is the default.

*output_type - string*  
> This is the desired data type of *output_field*. Allowable values are
> double, float, long, short, byte (or char), double_cplx, float_cplx,
> long_cplx, short_cplx, and byte_cplx (case insensitive). The default
> is the type of *input_field*. A parameter file value is not read if
> the **-t** option is used.

*function_type - string*  
The function *F*. Allowable values are abs, arg, atan, conj, cos, exp,
exp10, im, log, log10, none, re, recip, sgn, sin, sqr, sqrt, and tan
(case insensitive). This parameter is not read if the command-line
option **-F** is specified. If the option is omitted and if no value is
found in the parameter file, the default used is "none". See the
discussion of the **-F** option.

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

ESPS Common is not processed by *feafunc* if *input* is standard input.
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

> This is the name of the program (*feafunc* in this case).
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
contain the starting record number and number of records processed.
Generic header items are added for the *function_type*, *gain_real*,
*gain_imag*, *add_real*, *add_imag*, *input_field*, and *output_field*.
As usual, the command line is added as a comment, and the header of
*input* is added as a source file to *output*.

# FUTURE CHANGES

# SEE ALSO

    addfea(1-ESPS), addgen(1-ESPS),copysps(1-ESPS), 
    copysd(1-ESPS),clip(1-ESPS),frame(1-ESPS),
    mergefea(1-ESPS), pwr(1-ESPS), select(1-ESPS),
    arr_func(3-ESPS),type_convert(3-ESPSsp),FEA(5-ESPS)

# WARNINGS AND DIAGNOSTICS

When functions (**-F** option) or conversions (**-t** option) lead to
undefined or out-of-bounds values, the results vary with the machine on
which *feafunc* is run. If floating-point exceptions are generated,
*feafunc* exits with an error message. On some machines, such values do
not result in exceptions; they are specially coded (NaN, Infinity, etc.)
and can be observed using *psps*(1-ESPS).

If an unknown option is specified, if **-f** is used more than twice, or
if the number of file names is wrong, *feafunc* prints a synopsis of
command-line usage and exits. The program exits with an error message if
any of the following are true: an unknown function name is specified;
*input* does not exist or is not an ESPS FEA file; *input* is the same
as *output* (but not "-"); the *input_field* does not exist in *input;*
the *output_type* is not known or nonnumeric; a bad range is specified
with **-r**. The program prints a warning and continues if an explicit
*output_field* (that is, not specified as "-") already exists in
*input.*

# BUGS

None known.

# AUTHOR

Manual page and program by John Shore. Treatment of complex values
revised and additional functions added by Rod Johnson.
