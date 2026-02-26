# NAME

featosd - convert FEA_SD sampled-data file to SD file

# SYNOPSIS

**featosd** \[ **-x** *debug_level* \] *input.fea output.sd*

# DESCRIPTION

This program accepts an ESPS FEA_SD file *input.fea* and writes an ESPS
SD file *output.sd* containing the same sample values. Any fields other
than "samples" in the input file are ignored. The samples in
multichannel input files are written out in order with the samples from
one input record immediately followed by the samples from the next. The
number of channels is stored in the type-specific part of the output
header as *hd.sd-\>nchan.* The sample data from all channels of a
multichannel input file is thus preserved; however, the resulting output
file may not be particularly useful, as there is little ESPS support for
multichannel SD files (as opposed to FEA_SD files---see *mux*(1-ESPS)
and *demux*(1-ESPS)). If the input data type is DOUBLE, FLOAT, LONG,
SHORT, or BYTE, the output data type is the same. If the input data type
is one of the complex types (*e.g.,* FLOAT_CPLX), the output data type
is the corresponding real type (*e.g.,* FLOAT). In that case each input
channel is split into two output channels containing the real and
imaginary parts.

If *input.fea* is "-", standard input is used for the input file. If
*output.sd* is "-", standard output is used for the output file.

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

The output header is a new SD file header, with appropriate items copied
from the input header. The number of channels is recorded in the item
*nchan* in the type-specific part of the output header. The value of the
generic header item *record_freq* is recorded in the item *sf* in the
type-specific part of the output header. The information in any of the
generic header items *equip, max_value, src_sf, synt_method, scale,*
*dcrem, q_method, v_excit_method, uv_excit_method, synt_interp,*
*synt_pwr, synt_rc, synt_order, start,* and *nan* that are present is
copied into the like-named item in the type-specific part of the output
header. If generic header items *prefilter_siz, prefilter_zeros,* and
*prefilter_poles* are all present, the information is converted to a
zfunc (see *get_genzfunc*(3-ESPSu)), a pointer to which is stored in
*prefilter* in the type-specific part of the output header. Similarly,
if generic header items *de_emp_siz, de_emp_zeros,* and *de_emp_poles*
are all present, the information is saved in the output as a zfunc
pointed to by the type-specific header item *de_emp.* Input generic
header items not used as above are copied into generic header items in
the output header. As usual, the command line is added as a comment, and
the header of *input.fea* is added as a source file to *output.sd.*

# FUTURE CHANGES

None planned.

# SEE ALSO

    SD(5-ESPS),FEA(5-ESPS),FEA_SD(5-ESPS),get_genzfunc(3-ESPSu),
    sdtofea(3-ESPSu).

# WARNINGS AND DIAGNOSTICS

The program exits with an error message if the command line contains
unrecognized options or too many or too few file names.

# BUGS

None known.

# AUTHOR

Manual page and program by Rodney Johnson.
