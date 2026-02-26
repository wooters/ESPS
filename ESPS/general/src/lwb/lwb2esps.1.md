# NAME

lwb2esps - convert a Laboratory Work Bench data file to an ESPS sampled
data file

# SYNOPSIS

**lwb2esps** \[ **-x** *debug_level* \] \[ **-c** *channel_num* \]
*infile* *outfile*

# DESCRIPTION

*Lwb2esps* accepts a specially formatted set of files written by the
Laboratory Work Bench (LWB) program and produces an ESPS sampled data
file (FEA_SD).

*Lwb2esps* opens two files: *infile.H* and *infile.D.* It uses the
information in *infile.H* to build a header for the ESPS sampled data
file, and it copies the data in *infile.D* to the output sampled data
file.

If "-" is specified in place of *outfile,* standard output is used.

# OPTIONS

**-c** *channel_num*  
If the LWB data file contains multi-channel data (interleaved data from
more than one A/D converter) then *lwb2esps* converts only the data from
the *channel_num* A/D channel into the named sampled data file (
*outfile* ).

For this program, A/D channel numbers start from one. So if the A/D
hardware has a channel zero, it corresponds to channel one in this
program.

# ESPS HEADER

The entire LWB header file is written as a generic header item in the
output sampled data file.

# ESPS COMMON

This program does not access the ESPS common.

# ESPS PARAMETERS

This program does not access the parameter file.

# DIAGNOSTICS

*Lwb2esps* informs the user and quits if the input files do not exist.
It also quits and warns if the input header file is not a LWB header
file.

# ASSUMPTIONS

*Lwb2esps* assumes that the second number in the *sizes* field of the
LWB header file is the number of recorded channels, and it assumes the
value of the *slope* field contains the reciprocal of the sampling
frequency.

# SEE ALSO

esps2lwb (1-ESPS)

# WARNINGS

*Lwb2esps* is rigid about the format of the input files. You will have
trouble if you edit the LWB header file.

# BUGS

None Known.

# AUTHOR

Manual page and code by David Burton
