# NAME

filtspec - compute spectral amplitude response from filter definition

# SYNOPSIS

**filtspec** \[ **-x** *debug_level* \] \[ **-r** *range* \] \[ **-m**
*mode* \] \[ **-n** *num_freqs* \] \[ **-s** *sf* \] *input.filt*
*output.spec*

# DESCRIPTION

The program *filtspec* reads records from a *FEA_FILT*(5-ESPS) file and
produces an *FEA_SPEC*(5-ESPS) file containing the amplitude response
expressed in either linear or decibel units. If \`\`-'' is given for the
input file, standard input is read. If \`\`-'' is given for the output
file, standard output is written. The output file can be plotted using
the *plotspec*(1-ESPS) command.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-x***"***debug_level**  
If *debug_level* is non-zero, *filtspec* prints debugging messages and
other information on the standard error output.

**-r** *first***:***last* **\[(first in file):(last in file)\]**  
**-r** *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *first* or *last* may be omitted; then
the default value is used. If *last* = *first* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If the
specified range contains records not in the file, *filtspec* complains
and quits. The default is to process all of the records in the file.

**-m** *mode* **\[d\]**  
The string *mode* specifies whether the output spectral record contains
the power spectrum in linear or decibel units, or a complex frequency
spectrum. Allowable values for *mode* are *l* for linear, *d* for
decibel, and *c* for complex. The default for *mode* is *d.*

**-n** *num_freqs* **\[2049\]**  
Compute spectral values for this number of frequencies, equispaced from
0 to half the sampling frequency. Must equal 2*n* + 1 for some positive
integer *n*.

**-s** *sf* **\[1.0\]**  
Specify the sampling frequency in the FEA_SPEC file header to be *sf.*
If **-s** is not specified on the command line, *filtspec* looks for a
sampling frequency value in the generic header item *samp_freq*. If this
generic header item exists, *filtspec* uses the value found there as the
sampling frequency. If *samp_freq* does not exist or is type CHAR, the
default value 1.0 Hz is used.

# ESPS PARAMETERS

The ESPS parameter file is not used.

# ESPS COMMON

The ESPS Common file is not used.

# ESPS HEADERS

The following values are read from the header of the FEA_FILT file:
*common.type,* *max_num,* *max_denom,* *common.ndrec,* and the fields
consulted by *allo_spec_rec.*

The following parameters are written to the header of the FEA_SPEC file:
*common.prog,* *common.vers,* *common.progdate.* In addition, the
following standard FEA_SPEC generic header items are written: *sf*
(FLOAT), *freq_format* (CODED), *spec_type* (CODED), *num_freqs* (LONG),
*frame_meth* (CODED), and *contin* (CODED). Also, the following generic
header items are copied or updated if they exist in the input file:
*start_time* (DOUBLE), *record_freq* (DOUBLE), and *src_sf* (DOUBLE).

# SEE ALSO

    plotspec(1-ESPS), allo_feaspec_rec(3-ESPSu), write_header(3-ESPSu),
    FEA_FILT(5-ESPS), FEA_SPEC(5-ESPS), ESPS(5-ESPS).

# DIAGNOSTICS

filtspec: unknown option: -*letter*\
Usage: filtspec \[-x debug_level\]\[-f range\]\[-P param_file\]\[-n
num_freqs\] filt_file spec_file\
filtspec: number of frequencies *n* is not 1 plus a power of 2.\
filtspec: number of frequencies *n* exceeds 16385.\
filtspec: can't open *filename: reason*\
filtspec: *filename* is not an ESPS file\
filtspec: input file *filename* is not a FEA_FILT file.\
filtspec: bad range: *n* records in *filename*\
filtspec: EOF encountered.

# AUTHOR

Brian Sublett. Improved for ESPS 5.0 by Derek Lin.
