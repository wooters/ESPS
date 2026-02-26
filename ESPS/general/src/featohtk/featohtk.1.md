# NAME

featohtk - HTK input filter for ESPS FEA files

# SYNOPSIS

**featohtk** \[ **-f** *field* \[*range*\] \] \[ **-k** *parmKind* \] \[
**-r** *range* \] \[ **-x** *debug_level* \] \[ **-E** *field*
\[*index*\] \] \[ **-L** \] \[ **-O** *field* \[*index*\] \] \[ **-P**
*param_file* \] *input output*

# DESCRIPTION

*featohtk* reads a FEA file *input,* extracts the contents of specified
fields or portions of fields, formats the extracted data as an HTK
waveform or parameter file (see ref. \[1\]), and writes the result as
*output.* The function is designed to be used as an input filter to
permit convenient reading by HTK of data written by ESPS programs or
*waves+.* Output is in HTK default most-significant-byte-first order,
regardless of the architecture of the machine on which the program is
run.

If *input* is \`\`-'', standard input is used for the input file. If
*output* is \`\`-'', standard output is used for the output file. The
input and output should not be the same file; however, the program can
be run as a filter by specifying \`\`-'' for both input and output.

The output consists of a standard HTK header (see section 5.7.1
\[\`\`HTK Format Parameter Files''\] of ref. \[1\]) followed by a
sequence of waveform samples or parameter vector samples.

The header contains items that indicate the number of samples in the
file, the sample period, the number of bytes per sample, and the
parameter kind. The sample period is given in units of 100 nanoseconds
and is computed from the ESPS generic header item *record_freq* in the
input header. The sample kind is a code indicating whether the samples
are waveform samples (WAVEFORM) or contain vectors of linear-prediction
filter coefficients (LPC), mel-frequency cepstral coefficients (MFCC),
etc.

The sample kind is determined by command-line options or ESPS
parameter-file entries; see **-k** under OPTIONS for the full list of
supported basic parameter kinds. For parameter kinds other than
WAVEFORM, IREFC, and DISCRETE, the basic parameter vector can be
augmented with a log-energy term; see option **-E**. For parameter kind
MFCC, a \`\`zeroth-order cepstral parameter'' may appear in addition to,
or in place of, the log energy; see option **-O**.

Each input record supplies the contents for one output waveform sample
or parameter sample vector. The basic output coefficients (waveform
samples or parameter vectors) are taken from a specified field; see
option **-f**. The entire field or a specified subset may be used. The
log-energy term, if any, may be a specified element of the same field or
another field; see option **-E**. Likewise the zeroth-order cepstral
parameter, if included, may be a specified element of the same field or
another; see option **-O**.

In the output vector, the basic coefficients (specified with **-f**)
come first, followed by the zeroth-order cepstral term, if any, followed
finally by the log-energy term, if any.

The data type of the output vectors is *short* for parameter kinds
WAVEFORM, IREFC, and DISCRETE, and *float* for the other parameter
kinds. The data types of the input fields need not match the output data
type; conversions are performed as necessary.

# OPTIONS

The following options are supported. Default values are shown in
parentheses.

**-f** *field***(no default)**  
**-f "***field*** \[ ***grange*** \] "**  
The name of the field containing the waveform sample values or parameter
values to be included in the output.

The second form, with brackets, indicates a subset of the field elements
that are to be included in the output. For example, \`\`-f
"auto\[0,2:5,8\]"'' indicates that the output vector contains elements
number 0, 2 through 5, and 8 of the input field named *auto.* The reason
for the double quotes is simply to prevent the shell from giving the
usual special interpretation to the brackets. The brackets contain a
general range specification of the form handled by the function
*grange_switch*(3-ESPS). See the function manual page for the detailed
syntax.

The first form of the option argument, without the bracketed range,
denotes the entire field.

**-k** *parmKind***(no default)**  
A string indicating the basic kind of data to be indicated in the output
HTK header---e.g. WAVEFORM for sampled waveform data or LPREFC for
linear-prediction reflection coefficients. The allowed values are:

    	WAVEFORM	LPC	LPREFC	LPCEPSTRA
    	IREFC	MFCC	FBANK	MELSPEC
    	USER	DISCRETE

For the meaning of each, see section 5.7.1 (\`\`HTK Format Parameter
Files'') of ref. \[1\]. (Note that LPDELCEP, though listed in that
section, is not supported.)

**-r** *start***:***last***(1:\[last in file\])**  
**-r** *start***:+***incr*  
**-r** *start*  
The range of records to be processed. In the first form, a pair of
unsigned integers gives the record numbers of the first and last records
to be processed (counting from 1 for the first record of the file).
Either *start* or *last* may be omitted; then the default value is used.
If *last* = *start* + *incr,* the second form (with the plus sign)
specifies the same range as the first. The third form (omitting the
colon) specifies a single record.

**-x** *debug_level***(0)**  
A positive value of *debug_level* calls for debugging output, which is
printed on the standard error output. Larger values result in more
output. For the default value of 0, no messages are printed.

**-E** *field*  
**-E "***field*** \[ ***index*** \] "**  
A field element containing an energy or log energy term to be included
in an output parameter file in addition to the basic parameters in the
field specified with **-f**. The resulting output file has a parameter
kind denoted by appending the qualifier \`\`\_E'' to the basic type
indicated with **-k.** For example, if **-k** LPREFC was specified, the
output file would have the format indicated by \`\`LPREFC_E''. See
section 5.5 (\`\`Energy Measures'') of ref. \[1\]. In the second form,
the *index* in brackets is an integer that indicates the field element
to be used (counting from 0 for the first element). (The reason for the
double quotes is simply to prevent the shell from giving the usual
special interpretation to the brackets.) The first form, without
brackets, may be used when the field has only one element.

**-L**  
Log energy computation flag. If this option is specified, any field
element specified with **-E** is assumed to be an energy, and its
natural logarithm is computed to provide a log energy term for the
output. If **-L** is not specified, the logarithm is not computed, and
the unmodified field value is used. This option has no effect if **-E**
is not specified.

**-O** *field*  
**-O "***field*** \[ ***index*** \] "**  
A field element containing a \`\`zeroth-order cepstral parameter'' to be
included in the output in addition to, or in place of, the log energy
term specified with **-E**. See section 5.5 (\`\`Energy Measures'') of
ref. \[1\]. This option is valid only when the basic parameter kind
specified with **-k** is MFCC. The resulting output parameter kind is
MFCC_O if **-O** is specified alone, and MFCC_O_E if both **-O** and
**-E** are specified. In the second form of the option argument, the
*index* in brackets is an integer that indicates the field element to be
used, (counting from 0 for the first element). (The reason for the
double quotes is simply to prevent the shell from giving the usual
special interpretation to the brackets.) The first form, without
brackets, may be used when the field has only one element.

**-P** *param_file***(params)**  
The name of the ESPS parameter file.

# ESPS PARAMETERS

The terms \`\`parameter'' and \`\`parameter file'' are used in two
senses. An HTK parameter file, as described in ref. \[1\], is a data
file containing sample vectors of parameters such as reflection
coefficients, cepstral coefficients, or filter-bank channel outputs. An
ESPS parameter file, as described in ref. \[2\], is an ASCII file that
contains values for parameters, such as those described in this section,
that control the operation of a program.

The following parameters are read from the ESPS parameter file, if
present.

*compute_log - string*  
> A value of \`\`YES'' or \`\`yes'' means compute the logarithm of the
> field, if any, specified with the option **-E** or the parameter
> *Efield.* A value of \`\`NO'' or \`\`no'' means skip the logarithm
> computation. This parameter is not read if the option **-L** is
> specified. The default value is \`\`NO''.

*field - string*  
> The name of the field containing the waveform sample values or
> parameter values to be included in the output. As in the argument of
> the option **-f**, the field name may be followed by a bracketed
> *grange* specification to indicate a subset of the field elements that
> are to be included in the output. See **-f** under OPTIONS, and see
> the *grange_switch*(3-ESPS) man page. This parameter is not read if
> **-f** is specified. It is required if **-f** is not specified. (There
> is no default.)

*nan - int*  
> The total number of input records to process. A value of 0, the
> default, means continue processing until the end of the file is
> reached. This parameter is not read if the option **-r** is specified.

*parmKind - string*  
> The basic kind of data to be indicated in the output HTK header.
> Allowed values are those listed for the option **-k**. This parameter
> is not read if that option is specified. It is required if the option
> is not specified. (There is no default.)

*start - int*  
> The record number of the first input record to be processed. A value
> of 1, the default, denotes the first record of the file. This
> parameter is not read if the option **-r** is specified.

*Efield - string*  
> The name of a field containing an energy or log energy term to be
> included in the output HTK parameter file in addition to the basic
> parameters in the field specified with the option **-f** or the
> parameter *field.* As in the argument of the option **-E**, an integer
> index in brackets following the field name indicates the field element
> to be used; the bracketed index may be omitted when the field has only
> one element. If this parameter is omitted, and if the option **-E** is
> not specified, then no log energy term is included in the output. This
> parameter is not read if **-E** is specified.

*Ofield - string*  
> The name of a field containing a \`\`zeroth-order cepstral parameter''
> to be included in the output in addition to, or in place of, the log
> energy term specified with the option **-E** or the parameter
> *Efield.* As in the argument of the option **-O**, an integer index in
> brackets following the field name indicates the field element to be
> used; the bracketed index may be omitted when the field has only one
> element. If this parameter is omitted, and if the option **-O** is not
> specified, then no zeroth-order cepstral parameter term is included in
> the output. This parameter is not read if **-O** is specified.

# ESPS COMMON

The ESPS Common file is not read or written.

# ESPS HEADERS

The ESPS header item *ndrec* is accessed and used in determining the
number of samples to indicate in the HTK output header. The generic
header item *record_freq* in the input is accessed and used in
determining the sample period to indicate in the output header. Field
size information in the input header is accessed and used in determining
the number of bytes per sample to indicate in the output header.

# FUTURE CHANGES

Possible option for output in Esignal format. Possible option to control
output byte order.

# EXAMPLES

To let HTK read waveforms from an ESPS FEA_SD file, set the environment
variable HWAVEFILTER to the value:

> *featohtk -kWAVEFORM -fsamples \$ -*

To let HTK read reflection coefficients from an ESPS FEA_ANA file, set
the environment variable HPARMFILTER to the value:

> *featohtk -kLPREFC -fspec_param \$ -*

and set the HTK configuration variable TARGETKIND appropriately, e.g.
with an entry:

> *TARGETKIND = LPREFC*

in the HTK configuration file. (If TARGETKIND is not set, HTK will
probably attempt---and fail---to read the file as a waveform file before
reading it as a parameter file. The file can still be read successfully
if the environment variable HWAVEFILTER is given the same value as
HPARMFILTER.)

# ERRORS AND DIAGNOSTICS

If an unknown option is specified, or if the number of file names is
wrong, *featohtk* prints a synopsis of command-line usage and exits.

The program exits with an error message if any of the following are
true: *input* does not exist or cannot be read by the ESPS file input
routines; *input* is the same as *output* (but not \`\`-''); no basic
parameter kind is specified (with **-k** or the parameter *parmKind*);
the specified parameter kind is invalid or unsupported; no basic
parameter field is specified (with **-f** or the parameter *field*); an
input field (specified with **-f**, **-E**, or **-O** or a corresponding
parameter-file entry) does not exist in the input file or is not
numeric; an invalid field subrange or item index is indicated; an
invalid range is specified (with **-r** or the parameters *start* and
*nan*).

The program prints a warning and continues if either of the following is
true: an energy field is specified (with **-E** or the parameter
*Efield*) when the basic parameter kind is WAVEFORM, IREFC, or DISCRETE;
a zeroth-order cepstral parameter field is specified (with **-O** or the
parameter *Ofield*) when the basic parameter kind is not MFCC.

# BUGS

None known.

# REFERENCES

\[1\] Steve Young, Julian Odell, Dave Ollason, Valtcho Valtchev, and
Phil Woodland, *The HTK Book,* Entropic, 1997.

\[2\] Joe Buck and John Shore, \`\`Parameter and Common Files'', in
*ESPS/waves+ with EnSig Application Notes ,* Entropic, 1997.

# SEE ALSO

*grange_switch*(3-ESPS).

# AUTHOR

Rod Johnson, Entropic.
