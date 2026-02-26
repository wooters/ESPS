# NAME

    sdtofea - convert SD header to FEA_SD header

# SYNOPSIS

\#include \<esps/esps.h\>\
\#include \<esps/sd.h\>\
\#include \<esps/feasd.h\>

    struct header *
    sdtofea(hd)
    struct header *hd;

# DESCRIPTION

*sdtofea* converts an old SD file header (SD (5-ESPS)) to a FEA_SD
(5-ESPS) file header. *hd* must be a SD (5-ESPS) header, and *sdtofea*
returns a FEA (5-ESPS) header with the subtype FEA_SD (5-ESPS) set. New
programs that read and use the FEA_SD file type, can use *sdtofea* to
make the new programs compatible with old sampled data (SD) files. The
*sf* header item is converted to *record_freq*; all other type-specific
SD header items are converted to generic header items in the new FEA_SD
header.

# DIAGNOSTICS

If *hd* is not a FT_SD header, *sdtofea* warns and exits.

# SEE ALSO

FEA_SD (5-ESPS), SD (5-ESPS)

# AUTHOR

Manual page by David Burton. Code by Alan Parker
