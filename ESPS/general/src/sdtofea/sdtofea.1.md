# NAME

sdtofea - convert sampled-data file to FEA_SD file

# SYNOPSIS

**sdtofea** \[ **-x** *debug_level* \] *input.sd output.fea*

# DESCRIPTION

This program accepts an ESPS SD(5-ESPS) file *input.sd* and writes an
ESPS FEA_SD(5-ESPS) file *output.fea* containing the same sampled data.
If the value of *hd.sd-\>nchan* in the type-specific part of the input
header is 1 or greater, it gives the number of channels--- each output
record consists of that number of consecutive samples from the input
file. A value of either 0 or 1 indicates a single-channel file. The
output data type is the same (DOUBLE, FLOAT, LONG, SHORT, or BYTE) as
the input data type.

If *input.spec* is "-", standard input is used for the input file. If
*output.fea* is "-", standard output is used for the output file.

# OPTIONS

The following option is supported:

**-x** *debug_level*  
Positive values of *debug_level* cause debugging information to be
printed. The default value is 0, which suppresses the messages.

# ESPS PARAMETERS

No parameter file is read.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The output header is a new FEA_SD file header, with appropriate items
copied from the input header. The value of the item *sf* in the
type-specific part of the input header is recorded in a generic header
item *record_freq* in the output. The type-specific input header items
*equip, max_value, src_sf, synt_method, scale,* *dcrem, q_method,
v_excit_method, uv_excit_method, synt_interp,* *synt_pwr, synt_rc,
synt_order, start,* and *nan,* except those with null values, are saved
as like-named generic header items in the output file. (A \`\`null''
value is a value, such as zero, NONE, or NULL, that indicates that an
item is inapplicable.) If *preemphasis* in the input header is non-NULL,
it gives rise to 3 generic header items in the output: *preemphasis_siz,
preemphasis_zeros,* and *preemphasis_poles* (see
*add_genzfunc*(3-ESPSu)). Similarly *de_emp,* if non-NULL, gives rise to
*de_emp_size, de_emp_zeros,* and *de_emp_poles* in the output. Generic
header items in the input file header are copied to the output header
after being renamed, if necessary, to avoid name conflicts. As usual,
the command line is added as a comment, and the header of *input.sd* is
added as a source file to *output.fea.*

# FUTURE CHANGES

None planned.

# SEE ALSO

*SD*(5-ESPS), *FEA*(5-ESPS), *FEA_SD*(5-ESPS),\
*add_genzfunc*(3-ESPSu), *featosd*(3-ESPSu).

# WARNINGS AND DIAGNOSTICS

The program exits with an error message if the command line contains
unrecognized options or too many or too few file names.

# BUGS

None known.

# AUTHOR

Manual page and program by Rodney Johnson.
