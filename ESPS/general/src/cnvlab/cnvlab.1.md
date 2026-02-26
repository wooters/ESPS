# NAME

    cnvlab - convert NIST/SPHERE (e.g., TIMIT) label file to waves+ label file

# SYNOPSIS

**cnvlab** \[ **-s** *sampling_rate* \] \[ **-b** \] nist_file
waves_file

# DESCRIPTION

*cnvlab* reads the time-marked labels in a NIST label file *nist_file*,
and writes an equivalent *waves*+ label file *waves_file*. The input
file contains one label per line with three fields: (1) the starting
sample number; (2) the ending sample number; and (3) the label text
(which may include blanks).

The output file *waves_file* contains one label per line (after an
initial line with "#"), with three fields: (1) the time (in seconds) of
the label; (2) the color of the label (RGB); (3) the label text. Note
that labels do not have a start and end time. By convention, the time of
a waves+ label is the ending time.

The sampling rate to be assumed by *cnvlab* when interpreting sample
numbers is given by the **-s** option.

In the default mode (no **-b** option), *cnvlab* produces one *waves*+
label per input label, with the time corresponding to the ending sample
number of the input label. If the first input label does not begin with
sample 0, *cnvlab* issues a warning and generates a special label (with
text "UNL", for "unlabelled") to mark the actual starting point of the
first label. If the ending time of one label is not the same as the
starting point of the next label (a relatively rare case in the NIST
databases), *cnvlab* issues a warning. If the ending time of one label
exceeds the starting time of the next label, *cnvlab* issues a warning
and also inserts a special label (again, with text "UNL") to mark the
starting time of the that next label.

If the **-b** option is used, *cnvlab* produces two *waves*+ labels per
input label - one each for the starting point and the ending point. The
text for the former is the input label text with "\_S" appended, and the
text for the latter is the input label text with "\_E" appended.

In the default mode, the color of the *waves*+ labels is set to green,
with the color of the special "UNL" labels set to blue. If **-m** is
used, the *waves*+ endpoint labels have color green, and the starting
point labels have the color blue.

# OPTIONS

The following options are supported:

**-s** *sampling_rate \[8000\]*  
Sets the sampling rate used to compute the times associate with the
sample numbers in *nist_file*.

**-b**  
Specifies that both the start and end points of the input label each be
turned into a *waves*+ label. This results in two output labels for each
input label. See the DESCRIPTION about for details.

# ESPS PARAMETERS

An ESPS parameter file not used.

# ESPS COMMON

ESPS Common is not read or written.

# ESPS HEADERS

No ESPS headers are read or written.

# FUTURE CHANGES

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

# SEE ALSO

*convertlab* (3-ESPSsp), *xlabel* (1-ESPS)

# AUTHOR

John Shore (with help from David Talkin).
