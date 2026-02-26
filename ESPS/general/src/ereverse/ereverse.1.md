# NAME

ereverse - write records from an ESPS file in reverse order

# SYNOPSIS

**ereverse** \[ **-x** *debug_level* \] \[ **-r** *range* \] *infile*
*outfile*

# DESCRIPTION

*Ereverse* copies the records from an ESPS file, or a portion thereof,
to another file and writes them in reverse order. For a sampled data
file, the samples are written in reverse order. For a feature file or
other type of ESPS file, the records are written in reverse order but
the order of the data in each record is the same as in the input file.

If "-" is supplied in place of *outfile,* standard output is used.
Standard input may not be used for *infile.*

# OPTIONS

The following options are supported:

**-x** *debug level*  
Only debug level 1 is defined; this causes several not-terribly-useful
messages to be printed. The default level is zero, which causes no debug
output.

**-r** *range*  
Selects a subrange of points from *infile* using the format *start-end,*
*start:end,* or *start:+delta*. Either *start* or *end* may be omitted,
in which case the omitted parameter defaults respectively to the start
or end of *infile* The first record in *infile* is considered to be
point 1, regardless of its position relative to any original source
file. The form *start:+delta* is equivalent to *start:(start+delta).* If
the **-r** option is not used the range is determined from the ESPS
Common file if the appropriate parameters are present (see ESPS COMMON).
Otherwise the default range is the entire input file *infile.*

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

It the **-r** option is not used, the parameters *start* (starting
point) and *nan* (number of points) are read from ESPS Common if they
exist and if the Common parameter *filename* matches *infile.* If
*outfile* is not standard output, the Common parameters *filename, prog,
start,* and *nan* are written to correspond to the entire output file.

ESPS Common processing is enabled if the environment variable
USE_ESPS_COMMON is defined (any value). The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 2 is assumed.

# DIAGNOSTICS

*Ereverse* complains and dies if the input file does not exist, if the
input file is "-", if the input file is not an ESPS file, if the output
file cannot be created, or if the range specified extends beyond the end
of the file.

# BUGS

The output file will have the same EDR status (either NATIVE or EDR) as
the input file; regardless of the setting of the **ESPS_EDR**
environment variable. The program dows not work correctly unless the
input and output files are both in field order or both in type order.
For example, if the input file is in type order (the default) and the
environment variable **FIELD_ORDER** is set to "on" before running
*ereverse*, the output file will be garbage. The program does not handle
files in all NIST Sphere formats or in Esignal format or in PC WAVE
format; it will issue a warning or exit with an error message if given
such a file as input. If reversing is required, convert the file to an
ESPS file by using copysps(1-ESPS).

# SEE ALSO

psps(1-ESPS)

# AUTHOR

Joseph Buck; revised by John Shore
