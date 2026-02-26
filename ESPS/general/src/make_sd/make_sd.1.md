# NAME

make_sd - convert FEA fields to FEA_SD sampled data file

# SYNOPSIS

**make_sd** **-f** *field* \[ **-r** *range* \] \[ **-S**
*sampling_rate* \] \[ **-x** *debug_level* \] *file.fea* *file.feasd*

# DESCRIPTION

*Make_sd* makes a FEA_SD sampled data file *(file.feasd)* of the data in
the named *field* in the input file *file.fea.* The data type of the
FEA_SD file is that of the field *field* (but complex data are not
handled). If *file.fea* is "-", the standard input is read, and if
*file.feasd* is "-", the standard output is written.

By default, all elements of the specified field in the first record are
used in making the sampled data file. If the **-r** option is used, the
field elements in all the specified records are catenated together into
one sampled data file. If only one element from each field is to form
the sampled data stream, use *tofeasd* (1-ESPS) instead.

The fieldname must be given with the **-f** flag. This is not optional
and there is no default.

# OPTIONS

The following options are supported:

**-r** *record*  
**-r** *first:last*  
**-r***"***first:+incr**  
Determines the records from which values from the named *field* are
extracted. In the first form, a single integer identifies one record
from which values of *field* are extracted. In the second form, a pair
of unsigned integers gives the first and last points of the range. If
*first* is omitted, 1 is used. If *last* is omitted, the last record in
*file.fea* is assumed. The third form is equivalent to the first with
*last = first + incr.* When more than one record is processed, the
element values are catenated together before being put in the sampled
data file.

**-S** *sampling_rate \[1\]*  
Specifies the sampling rate of the data - this value will be stored in
the *record_freq* generic of the output file.

**-x** *debug_level*  
If *debug_level* is nonzero, debugging information is written to the
standard error output. Default is 0 (no debugging output).

# EXAMPLES

*make_sd* **-f** spec_param **-r5** speech.fana spec_param.sd

puts the *spec_param* field from record 5 of speech.fana into the
sampled data file *spec_param.sd*.

An example of how *make_sd* is useful is in computing the cross spectrum
from the output of *cross_cor*. To compute the cross spectrum
corresponding to record 5, the following command will work.

*make_sd* **-f** cross_cor **-r5** speech.fana - **\|** fft -o10 -
spec_param.spec

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

ESPS Common processing is disabled.

# DIAGNOSTICS

*Make_sd* complains and exits if *file.fea* does not exist or is not a
FEA file.

# IMPLEMENTATION NOTE

The current version of *make_sd* is implemented as a shell script that
pipes the output of *pplain* (1-ESPS) through *testsd* (1-ESPS). This is
an example of how ESPS programs can be combined with the "Unix tools
approach" - see the simplified example on the *pplain* (1-ESPS) man
page.

# BUGS

None known.

# EXPECTED CHANGES

A later version will integrate *tofeasd* (1-ESPS) and *make_sd*.

# SEE ALSO

*tofeasd* (1-ESPS), fea_element(1-ESPS), pplain(1-ESPS), testsd(1-ESPS),
auto(1-ESPS), cross_cor(1-ESPS)

# AUTHOR

    Manual page by David Burton
    Program by Alan Parker
