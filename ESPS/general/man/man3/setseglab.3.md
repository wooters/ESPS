# NAME

set_seg_lab - flag an ESPS FEA file as segment-labeled and define the
necessary fields

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    void
    set_seg_lab(hd,files)
    struct header *hd;
    char **files;

# DESCRIPTION

*set_seg_lab* flags an ESPS Feature file as *segment-labeled* and
defines the necessary fields. The fields defined are a coded field of
size 1 named "source_file" and two long-integer fields of size 1 named
"segment_start" and "segment_length". For each record these give the
name of an ESPS file and the beginning record number and number of
records of a segment in that file to which the feature record refers.
The item *segment-labeled* in the FEA file header is set to YES.
Flagging a FEA file as segment-labeled is incompatible with a value of
YES for *tag* in the common part of the header.

Since the file name is stored as a CODED data type (to conserve space,
assuming that file names will repeat in segments) the list of possible
values (file names) for the field "source_file" must be known when the
header is written. If this list is known when *set_seg_lab* is to be
called, then it is passed to the function through *files* which is a
pointer to an array of character pointers (or a pointer to an array of
character strings). If this list is not known when the function is
called, NULL should be given for *names* and the list can be assigned to
*hd.fea-\>enums\[i\]*, where *i* is the index into the header arrays
corresponding to the field named "source_file". (Use
*lin_search2*(3-ESPSu) to get *i*.)

Since this function creates fields in the feature file and modifies the
file header, it must be called before the header is written out with
*write_header*(3-ESPSu).

# DIAGNOSTICS

If *hd* is not an ESPS Feature file a message is printed and the program
terminates with exit 1.

# BUGS

None known.

# SEE ALSO

add_fea_fld(3-ESPSu), lin_search2(3-ESPSu), FEA(5-ESPS)

# AUTHOR

Alan Parker
