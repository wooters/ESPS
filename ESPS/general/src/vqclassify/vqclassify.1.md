# NAME

vqclassify - classify based on VQ distortions (FEA_DST file)

# SYNOPSIS

**vqclassify** \[ **-x** *debug_level* \] \[ **-v** \] \[ **-m**
*method* \] *infile.dst*

# DESCRIPTION

*vqclassify* reads *infile.dst* (a *FEA_DST*(5-ESPS) file), and for each
different *cbk_signal* found in the input file, *vqclassify* finds the
record that contains the smallest *average_dst* and remembers the
*cbk_source* value. If all records have the same *cbk_signal* value,
then the *cbk_source* in the record that contains the smallest
*average_dst* is printed to standard output. If several different
*cbk_signal* values exist in the input file, a classification decision
is made for each *cbk_signal* and the *cbk_source* that was selected the
most times is output to standard output. If an ordered list of all
possible *cbk_source*s (from best guess to worst guess) along with
confidence factors is wanted, then the **-v** option should be used.

If *infile.dst* is equal to "-", then standard input is used.

# OPTIONS

**-x** *debug_level* **\[0\]**  
Values greater than 0 cause messages to print to *stderr*.

**-v**  
With this option, confidence factors along with average distotion
information for all possible choices are written to standard output.

**-m** *method*  
At this time only one option is supported: *vote*. This method makes a
classification decision on each *cbk_signal* parameter in the input
FEA_DST file and then counts the number of votes for each *cbk_source*.
The *cbk_source* with a plurality of votes is the guess of the input\`s
identity.

# ESPS PARAMETERS

The parameter file is not processed.

# ESPS COMMON

Common is neither read nor written.

# ESPS HEADERS

No ESPS file is written.

# FUTURE CHANGES

More methods will be added.

# WARNINGS

*Vqclassify* warns and exits if the input file is not a
*FEA_DST*(5-ESPS) file.

# SEE ALSO

    FEA_DST(5-ESPS), vqdst(1-ESPS), addclass(1-ESPS),
    vqdes(1-ESPS)

# BUGS

# AUTHOR

Manual page by David Burton. Program by Alan Parker.
