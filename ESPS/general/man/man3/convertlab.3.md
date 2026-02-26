# NAME

convertlab - convert NIST/SPHERE (e.g., TIMIT) label file to waves+
label file

# SYNOPSIS


    #include <stdio.h>
    #include <esps/unix.h>
    #include <esps/esps.h>

    int
    convertlab(file_in, file_out, sf, mode, lab_color, unl_color)
    char *file_in;
    char *file_out;
    int  lab_color;	
    int  unl_color;	
    double sf;
    int mode;			

# DESCRIPTION

*convertlab* reads the time-marked labels in a SPHERE (TIMIT) label file
*file_in*, and writes an equivalent *waves*+ label file *file_out*. The
input file contains one label per line with three fields: (1) the
starting sample number; (2) the ending sample number; and (3) the label
text (which may include blanks).

The parameter *sf* is the sampling rate to be assumed by *convertlab*
when interpreting sample numbers.

The output file *file_out* contains one label per line (after an initial
line with "#"), with three fields: (1) the time (in seconds) of the
label; (2) the color of the label (RGB); (3) the label text. Note that
labels do not have a start and end time. By convention, the time of a
waves+ label is the ending time.

If *mode* == 1, *convertlab* produces one *waves*+ label per input
label, with the time corresponding to the ending sample number of the
input label. If the first input label does not begin with sample 0,
*converlab* issues a warning and generates a special label (with text
"UNL", for "unlabelled") to mark the actual starting point of the first
label. If the ending time of one label is not the same as the starting
point of the next label (a relatively rare case in the NIST databases),
*convertlab* issues a warning. If the ending time of one label exceeds
the starting time of the next label, *convertlab* issues a warning and
also inserts a special label (again, with text "UNL") to mark the
starting time of the that next label.

If *mode* == 2, *convertlab* produces two *waves*+ labels per input
label - one each for the starting point and the ending point. The text
for the former is the input label text with "\_S" appended, and the text
for the latter is the input label text with "\_E" appended.

If *mode* == 1, the default color of the *waves*+ labels is set to
*lab_color*, with the color of the special "UNL" labels set to
*unl_color*. If *mode* == 2, the *waves*+ endpoint labels have color
*lab_color*, and the starting point labels have the color *unl_color*.
If *lab_color* or *unl_color* is negative, an internal default is used.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

*xlabel (1-ESPS)*

# AUTHOR

John Shore (with help from David Talkin)
