# NAME

feaop - element-by-element binary operations on fields of FEA files

# SYNOPSIS

**feaop** \[ **-f** *in_field1* \[ **-f** *in_field2* \[ **-f**
*out_field* \]\]\] \[ **-g** *gain_factor* \] \[ **-r** *range1* \[
**-r** *range2* \]\] \[ **-t** *output_type* \] \[ **-x** *debug_level*
\] \[ **-z** \] \[ **-I** \] \[ **-O** *operation* \] \[ **-P**
*param_file* \] \[ **-R** \] *file1.in* *file2.in* *file.out*

# DESCRIPTION

*feaop* performs binary operations on numbers taken from two input files
and places the results in an output file. For example, it can be used to
subtract values in one file from values in another, to multiply values
from two files, or to combine pairs of real values from two files to
form complex numbers. The program accepts two input FEA files *file1.in*
and *file2.in.* It combines the contents of a specified field in
*file1.in,* element by element and record by record, with the contents
of a specified field in *file2.in* using a specified binary operation.
The records in the output file, *file.out,* are copies of records from
the second input file except that there is a field containing the
results of the operation. Normally this is a new field, different from
any in *file2.in,* but it may replace an existing field, including the
input field in *file2.in.* A warning is issued unless the input fields,
*in_field1* in *file1.in* and *in_field2* in *file2.in,* have the same
rank and dimensions. However, processing continues as long as the fields
have the same number of elements. The rank and dimensions of the output
field, *out_field* in *file.out,* are taken from *in_field2.*

It is possible to scale the data values in *in_field1* by a \`\`gain
factor'' *g* before using them as operands. (See the **-g** option.)
Thus this option provides a convenient way of adding various levels of
noise to a sampled-data signal. Moreover, the roles of the operands may
be interchanged with the **-I** option. So, for example, by specifying
the subtraction operation, SUB, it is possible to obtain output values
of the form *gx* - *y,* or *y* - *gx,* where *x* is a value from
*file1.in* and *y* is a corresponding value from *file2.in*

The default data type of the output field is selected to \`\`cover'' the
two input types (see cover_type*(3-ESPS)).* That is, all values of the
input types can be stored in the output type. For example, if one input
field has type SHORT_CPLX, and the other is FLOAT, the default output
type is FLOAT_CPLX. However, with the **-t** option or the *output_type*
parameter, the output data type may be chosen arbitrarily. The rule for
the default output type was chosen for simplicity; for some operations
another type may actually be better for representing the result. For
example, PWR (raising to a power) may yield complex results even when
both operands are real. In fact an exception to the rule is made for the
operation CPLX, whose entire purpose is to take real operands and yield
complex results: the default output type is always complex if the
operation is CPLX. The output value is what would be obtained by
performing the operation in a data type \`\`sufficiently large'' for the
operation (typically DOUBLE_CPLX) and then converting to the output type
by using *type_convert*(3-ESPS). However, a more direct method is
actually be used internally when the input and output types permit. If
the output type is real, the imaginary part of the result is in effect
discarded in conversion from complex to real; in actual fact it simply
is not computed. See the discussions of the individual operations for
more information on result types.

Ordinarily, *feaop* starts with the first record in each file and
proceeds through the two files in step, pairing each record from
*file1.in* with a record from *file2.in* and stopping when the end of
one file or the other is reached. However, it is possible to specify
different starting points in the two files and to restrict processing to
a subrange of each file (see the **-r** option). Moreover, with the
**-R** option, it is possible to reuse the data from *file1.in*
cyclically, stopping only at the end of the data from *file2.in.*

If either input file is "-", standard input is used; however, *file1.in*
cannot be standard input if the **-R** option is used, and the input
files cannot both be standard input. Aside from that restriction,
*file1.in* and *file2.in* may be the same file. If *file.out* is "-",
standard output is used. The output file must not be the same as either
input file; however, it is okay to run the program as a filter by
specifying standard input for one input file and standard output for the
output file.

*feaop* copies generic header items from *file2.in* to the output and
preserves FEA subtype information---for example, if *file2.in* is a
FEA_SPEC file, the output file header will contain the subtype code
indicating a FEA_SPEC file, and the output file will in fact be a
FEA_SPEC file if one precaution is observed. Namely, if the output field
is one that the FEA subtype specification subjects to requirements, the
requirements must not be violated. It is unadvisable, for instance,
though possible, to use *feaop* with the **-t** option to make a file
that appears to be a FEA_SPEC file but has a field named *re_spec_val*
whose data type is LONG_CPLX. (The *FEA_SPEC*(5-ESPS) manual entry
requires it to be FLOAT or BYTE.) It is always legitimate to add a new
field with a name not mentioned in the subtype specification.

Notes on the individual operations follow. In the formulas, *x* and *y*
denote the first and second operands of the operation.

ADD  
The sum of the operands, (*x* + *y*).

SUB  
The difference of the operands, (*x* - *y*).

MUL  
The product of the operands, (*xy*).

DIV  
The quotient of the operands, (*x*/*y*). For integer input types, this
is not an integer division such as C and other programming languages
perform on integer operands. (An IDIV operation may be added in a later
version of the program.) The result is the best approximation to the
exact quotient that can be represented in the output type. For example,
suppose *x*= 2 and *y*= 3*.* The result is 0.6666..., not 0.0, if the
output type is for FLOAT or DOUBLE; when the output type is an integer
type such as SHORT, the result is the result of rounding 0.6666... to
the nearest integer, 1, not truncating to 0.

PWR  
The result of raising *x* to the power *y,* (*x*^*y*). If *x* is 0, then
the result is 1 if *y* is 0, 0 if *y* has a positive real part, and
undefined otherwise. If *x* is not 0, the result is mathematically
defined by exp (*y* log *x*). The result may be complex even for real
operands. For example -4 to the power 0.25 yields the result 1 + *i.* If
the result type is specified as (or defaults to) a real type, the
imaginary part is lost, and the result becomes 1.

CPLX  
The complex number with given real and imaginary parts, (*x* + *iy*).
This operation is mainly intended for use with real operands. If complex
operands are given, the result is that given by the formula, though the
real and imaginary parts of the result are no longer equal to *x* and
*y.*

While this program subsumes the main functionality of both
*addsd*(1-ESPS) and *multsd*(1-ESPS), it isn't yet competitive with them
for speed on their special domain: single-channel FEA_SD files.

# OPTIONS

The following options are supported:

**-f** *field* **\[(input:) samples\]**  
**-f** *field* **\[(output: derived from input field names)\]**  
**-f** *-*  
This option may be used at most three times. If used once, it specifies
the name of the source fields *in_field1* and *in_field2* in the two
input files---the same name for both. If used twice, it specifies
*in_field1* the first time and *in_field2* the second time. If it is
used three times, the third occurrence specifies the name of the result
field *out_field* in the output file. The default name for the two input
fields is "samples". The default name for the output field normally
consists of the names of the first input field, the operation (see
**-O**), and the second input field, in that order, connected by
underscore characters---for example "samples_ADD_samples". The field
names are interchanged if the **-I** option is used. If the output field
has the same name as a field in the second input file, the original
contents of the field are lost. A warning message is normally printed in
that case. However, if the output field is specified as "-", the name of
the second input field is used instead, and the warning message is
suppressed.

**-g** *gain_factor* **\[1\]**  
Specifies a constant (gain factor) by which each element of the first
input field is multiplied before being used as an operand. A complex
factor is specified with a comma, in the form
*real_part***,***imaginary_part.*

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***incr*  
**-r** *start*  
Determines the range of record to be taken from one or both input files.
In the first form, a pair of unsigned integers gives the numbers of the
first and last records of the range. (Counting starts with 1 for the
first record in the file.) Either *start* or *last* may be omitted; then
the default value is used: 1 for *start* and the last record in the file
for *last.* If *last* = *start* + *incr,* the second form (with the plus
sign) specifies the same range as the first. The third form (omitting
the colon) specifies a single record. The **-r** overrides the values of
*start* and *nan* from the parameter file. The implied value of *nan* is
1 + *last* - *start* (first form), 1 + *incr* (second form), or 1 (third
form).

This option may be used at most twice. If used once, it applies to both
input files. If used twice, it applies to *file1.in* the first time and
*file2.in* the second time. If the option is used twice and implies
inconsistent values of *nan,* a warning message may be issued. For
example **-r** 1**:**10 and **-r** 101**:**120 in the same *arrop*
command will generate a warning of inconsistent **-r** options (unless
**-R** is in effect). On the other hand two options with one unspecified
endpoint, like **-r** 1**:** and **-r** 101**:**120, are not considered
inconsistent and will not generate the warning. The warnings can be
suppressed by the **-z** option.

**-t** *output_type*  
Specifies the type of the output field. Allowable values are DOUBLE,
FLOAT, LONG, SHORT, BYTE, (or CHAR), DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX,
SHORT_CPLX, and BYTE_CPLX. The case doesn't matter: upper is not
distinguished from lower. With one exception, the default is the
\`\`cover type'' of the input types; see the DISCUSSION and the
*cover_type*(3-ESPS) manual page for details. The exception is that when
the operation being performed is CPLX, and the input types are both
real, the default output type is the complex type corresponding to the
\`\`cover type'' of the input types. Note that if you combine real input
fields with a complex gain factor (see **-g**), you will need to specify
a nondefault output type with **-t** to obtain the intended complex
result.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *feaop* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

**-z**  
Suppress warning messages.

**-I**  
Interchange the operands. Normally, each value from *file1.in* (possibly
scaled) is used as the first operand of the operation, with a value from
*file2.in* as the second operand. When **-I** is used, however, the
possibly scaled values from *file1.in* are each used as the second
operand with a value from *file2.in* as the first operand. Thus, if DIV
is the operation, this option allows you to divide *in_field2* by
*in_field1* instead of the reverse.

**-O** *operation* **\[ADD\]**  
Specifies the operation to be performed. The possible operations are
those supported by *arr_op*(3-ESPSsp) and include ADD, SUB, MUL, DIV,
PWR, and CPLX; see the DISCUSSION section and the *arr_op* manual entry.
The case doesn't matter; upper is not distinguished from lower, and
"add" (or "aDd") will do as well as "ADD". The default, ADD, specifies
addition.

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
"params".

**-R**  
\`\`Recycle.'' If records from *file1.in* (or the subrange specified
with **-r**) are exhausted before the end of the data from *file2.in,*
they are reused cyclically as often as necessary.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*gain_real - float*  
*gain_imag - float*  
> The real part and the imaginary part of the gain factor *g* by which
> values from *in_field1* are multiplied before being used as operands.
> The defaults are 1 and 0. These parameters are not read if the **-g**
> option is used.

*in_field1 - string*  
*in_field2 - string*  
> The names of the selected data fields in *file1.in* and *file2.in,*
> respectively. The default for both is "samples". These parameters are
> not read if the **-f** option is used.

*nan - int array or int*  
> The number of records to process in each input file. This is either a
> scalar, applying to both files, or a two-element array, giving
> separate values for the two files. A value of 0, the default for both
> files, means continue processing until the end of the file is reached.
> If the **-R** option is not in effect, and two different non-default
> *nan* values are specified, a warning is given, and the smaller value
> is used. This parameter is not read if the **-r** option is used.

*operation - string*  
> The operation performed. Allowable values include "add", "sub", "mul",
> "div", "pwr", and "cplx" (case-insensitive). This parameter is not
> read if the **-O** option is used. The default, "add" performs
> addition.

*out_field - string*  
> The name of the output field in which the results are stored. The
> default is as described for the **-f** option. This parameter is not
> read if **-f** is used three times.

*output_type - string*  
> The data type of the output field, *out_field.* Allowable values are
> double, float, long, short, byte (or char), double_cplx, float_cplx,
> long_cplx, short_cplx, and byte_cplx (case insensitive). The default
> depends on the input types; see **-t**, the DISCUSSION, and the
> *cover_type*(3-ESPS) manual page for details. The parameter is not
> read if the **-t** option is used.

*start - int array* or *int*  
> Either a two-element array, containing the starting record numbers in
> the input files, or a scalar, applying to both input files. The
> default is {1, 1}, meaning the beginning of each file. This parameter
> is not read if the **-r** option is used.

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

The header of *file.out* is a copy of the header of *file2.in,*
including all generic header items. The generic header item *start_time*
is written (or rewritten) with a value computed by taking the
*start_time* from the header of *file2.in* (or zero, if the item doesn't
exist) and adding to it the relative time from the first record in that
file to the first record processed. The computation of *start_time*
depends on the value of the generic header item *record_freq* in
*file2.in.* If that item isn't present, *start_time* is just copied from
*file2.in* to *file.out.* The items *start* and *nan* are written (or
rewritten) to contain the starting record number and number of records
to be processed in *file2.in* (with *nan* = 0 implying all records from
*start* up to the end of the file). Items *start1* and *nan1* record the
same information for *file1.in.* Generic header items are added for the
*operation,* *gain_real,* *gain_imag,* *in_field1,* *in_field2,* and
*out_field* parameters. As usual, the command line is added as a
comment, and the headers of the input files are added as source files to
the output.

# FUTURE CHANGES

An option may be added to allow *file1.in* to be omitted and a single
constant operand to be specified instead. The conformability
requirements on the two input fields may be made more flexible. Any
additions to the list of operations accepted by *arr_op*(3-ESPS) will be
reflected in this program.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

If an unknown option is specified, if **-f** is used more than three
times, if **-r** is used more than twice, or if the number of file names
is wrong, *feaop* prints a synopsis of command-line usage and exits.

The program exits with an error message if any of the following are
true: an unknown operation name is specified; an input file does not
exist or is not an ESPS FEA file; both input file names are "-"; an
input file name is the same as the output name (but not "-"); an input
field does not exist in the respective file; the input fields have
different numbers of elements; the output type is not known or
nonnumeric; a bad range is specified with **-r.**

The program issues a warning and continues if the files do not have the
same value of the header item *record_freq.* (For sampled-data files,
that means that the sampling frequencies mismatch.) It also warns if an
explicit output field (that is, one not specified with **-f**-) already
exists in *file2.in,* if the input fields have different ranks or
dimensions (but the same number of elements), if two **-r** options
specify inconsistent ranges (see the discussion of **-r**), or if an
input file ends before a specified endpoint.

# BUGS

None known.

# REFERENCES

# SEE ALSO

*addsd*(1-ESPS), *feafunc*(1-ESPS), *multsd*(1-ESPS), *mux*(1-ESPS).
*select*(1-ESPS), *arr_op*(3-ESPS), *cover_type*(3-ESPS),
*type_convert*(3-ESPS) *FEA_SPEC*(5-ESPS)

# AUTHOR

Rod Johnson
