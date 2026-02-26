# NAME

    update_waves_gen - update waves-relevant generic header items record_freq and start_time

# SYNOPSIS

\#include \<esps/esps.h\>

void\
update_waves_gen(ih, oh, start, step)\
struct header \*ih, \*oh;\
float start, step;

# DESCRIPTION

This function is intended primarily for use by programs that produce
files that will be displayed using *xwaves*(1-ESPS). It writes the
generic header items which *waves*+ requires in order to properly
display files in a time-synchronized manner, namely the generics
"start_time" and "record_freq".

The header pointers *ih* and *oh* refer respectively to an ESPS input
file and an ESPS output file. These should both be FEA files, but for
compatibility with previous versions, they can also point to old-style
SD files.

The parameter *start* is the starting record position in the input file
that corresponds to the start of the output file (e.g., the starting
sample for FEA_SD or SD files). The parameter *step* is the number of
input records that correspond to one output record. (if *step* is 0,
*update_waves_gen* does not compute and write "record_freq".) Although
integer values for *start* and *step* are the most common case, they are
n specified as FLOATs to handle special cases (for example, *step* will
be less than 1 in the case of a sampling rate increase).

When both *ih* and *oh* both point to FEA headers (including FEA_SD),
*update_waves_gen* has the following behavior: It expects to find the
generic header items "start_time" and "record_freq" in the input header
*ih*. If these are not present, they default to 0 and 1 respectively.
*Update_waves_gen* uses the generic "record_freq" and the parameter
*start* to compute a starting time relative to the beginning of the
file, it adds this value to the value of the "start_time" generic in
*ih*, and it writes the result as the "start_time" generic in *oh*. If
"start_time" in *ih* is a vector, the relative start time is added to
each component before the results are written to *oh*.

If *step* is non-zero, the number of output records per second is
computed by dividing the input generic "record_freq" with the parameter
*step* (this parameter gives the number of input records that correspond
to one output record). The resulting value is written as the generic
"record_freq" in the output header. (For example, if *step* == 1, the
output "record_freq" is the same as that of the input.) If *step* is 0,
then the header item "record_freq" is not written. Programs that output
FEA_SD (or SD) files often use *step* == 1 or *step == 0*, in cases
where they compute and set the sampling rate ("record_freq") outside of
*update_waves_gen*.

If the input header *ih* is an old-style SD header, the input header
item *ih-\>hd.sd-\>sf* is used instead of the generic "record_freq". If
the output header *oh* is an an old-style SD header, the output generic
"record_freq" is not written, since it is assumed that the header item
*oh-\>hd.sd-\>sf* is set correctly.

Note that the generic header items written by *update_waves_gen* are not
physically written to an output file until *write_header* (3-ESPS) is
called (*update_waves_gen* just modifies the header structures).

# DIAGNOSTICS

The function exits with an assertion failure if *ih* and *oh* do not
point to SD or FEA files, or if the input "record_freq" (or
*ih-\>hd.sd-\>sf*) is less than equal to zero. If *ih* is a FEA file and
does not contain "record_freq" and "start_time" generics, a warning is
printed on standard error if the global variable debug_level is
non-zero.

# BUGS

None known.

# SEE ALSO

*add_genhd*(3-ESPS), *get_genhd_val*(3-ESPS),\
*copy_genhd*(3-ESPS), *genhd_type*(3-ESPS), *genhd_list*(3-ESPS),\
*genhd_codes*(3-ESPS), ESPS(5-ESPS), FEA(5-ESPS),\
FEA_SD(5-ESPS)

# AUTHOR

Manual page by John Shore, code by Alan Parker and John Shore
