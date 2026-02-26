# NAME

his - sort data into bins to make histograms for plotting.

# SYNOPSIS

**his** \[ **-x** *debug_level* \] \[ **-r** *range* \] \[ **-n**
*nbins* \] *out_file*

# DESCRIPTION

The program *his* reads Ascii data from standard input and sorts the
data into bins to form a histogram for plotting. The output is Ascii
data in a form that can be given directly to *aplot*(1-ESPS) to make the
plot. If *out_file* is "-", the program writes standard output.

# OPTIONS

The following options are supported:

**-x** *debug_level* **\[0\]**  
A value of 0 (the default value) will cause *his* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-r** *low:high*  
This is the range of bin values on the x axis, specified in the format
accepted by *frange_switch*(3-ESPSu). The default for range is +/- 2048;
this is appropriate for 12-bit sampled data files.

**-n** *nbins*  
The range is divided uniformly into *nbins* bins or segments. Each bin
includes its lower bound but does not contain its upper bound. In other
words, bin *i* will count the number of occurences of numbers greater
than or equal to bin *i*'s lower bound, and less than bin *i*'s upper
bound. The default for *nbins* is 64.

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

The common file is not accessed.

# SEE ALSO

*pplain*(1-ESPS), *aplot*(1-ESPS)

# EXAMPLE

pplain file.sp \| his -r-1024:1024 -n2048 - \| aplot -z

# AUTHOR

Original code by Brian Sublett; extensively changed and modified for
ESPS 3.0 by David Burton
