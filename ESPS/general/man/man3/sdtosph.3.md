# NAME

sd_to_sphere - convert ESPS FT_SD or FEA_SD header to Sphere header

# SYNOPSIS

struct header_t \*\
sd_to_sphere(ifile, ofile, byte_format)\
FILE \*ifile;\
FILE \*ofile;\
char \*byte_format;

# DESCRIPTION

*sd_to_sphere* assumes that *ifile* is non-NULL, is open for reading,
and is positioned to point at the beginning of an ESPS header. If
*ofile* is non-NULL, it is assumed to be open for writing.
*sd_to_sphere* reads the ESPS header and checks to make sure it
describes a single-channel, non-complex, FT_SD or FEA_SD file. If these
conditions are not met, *sd_to_sphere* writes an error message to stderr
and returns NULL.

*sd_to_sphere* converts the input ESPS header to Sphere format. If
*ofile* is non-NULL, the resulting Sphere header is written to *ofile*
followed by all of the data from the input ESPS file. The input data can
be any type, but are converted to SHORT before output to *ofile*. The
parameter *byte_format* determines the byte order of output data; values
are restricted to either "10" or "01". If *byte_order* is "01", the data
are byte-reversed before output. (If *byte_order* is some other value,
an error message is output and *sd_to_sphere* returns NULL).

All scalar generic header items from the input ESPS header are
reproduced as sphere header items in the output header. Note that CODED
generics from the input header are converted as integers. In addition,
the Sphere header items *channel_count, sample_count,* sample_rate,
sample_min, sample_max, sample_n_bytes, sample_byte_format, and
*sample_sig_bits* are included in the output Sphere header.

*sd_to_sphere* returns a pointer to the converted Sphere header. If
*ofile* is non-NULL, *ifile* is positioned at the end of all input data,
and *ofile* is positioned at the end of the written data. If *ofile* is
NULL, *sd_to_sphere* returns the Sphere header but writes no output (in
this case, *ifile* is positioned at the end of the ESPS header).

Note that, since *sd_to_sphere* is available in an unlicensed form, it
can be used in non-ESPS programs that read ESPS sampled data files
(e.g., if only to skip the ESPS header).

# EXAMPLE

# DIAGNOSTICS

# FUTURE CHANGES

# BUGS

None known.

# SEE ALSO

read_header(3-ESPSu), skip_header(3-ESPSu), e2sphere (1-ESPS)

# AUTHOR

John Shore
