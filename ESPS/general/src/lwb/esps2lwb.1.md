# NAME

esps2lwb - convert an ESPS sampled data file to Laboratory Work Bench
data files

# SYNOPSIS

**esps2lwb** \[ **-x** *debug_level* \] *infile* *outfile*

# DESCRIPTION

*Esps2lwb* converts an ESPS sampled data file to a Laboratory Work Bench
(LWB) data file. *Esps2lwb* actually produces two ascii files:
*outfile.H* and *outfile.D.*

If *infile* is replaced by "-", *esps2lwb* will read from standard
input.

*Esps2lwb* correctly handles multiplexed files. *Esps2lwb.*

# ESPS HEADER

*record_freq* and *num_channels* are read from the input file.

# ESPS PARAMETERS

This program does not access the parameter file.

# ESPS COMMON

This program does not access common.

# DIAGNOSTICS

*Esps2lwb* informs the user and quits if the input file does not exist
or is not an ESPS sampled data file.

# SE ALSO

lwb2esps (1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page and code by David Burton
