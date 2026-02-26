# NAME

skiprec - skip fixed-length records in a file

fea_skiprec - skip records in a file

# SYNOPSIS

    void
    skiprec(stream, nrec, size)
    FILE *stream;
    long nrec;
    int size;

    void
    fea_skiprec(stream, nrecs, hdr)
    FILE *stream;
    long nrecs;
    struct header *hdr;

# DESCRIPTION

*skiprec* changes position in a binary file. It skips forward *nrec*
records, each containing *size* bytes. It first tries to accomplish this
with a disk seek operation. If the seek would change the position to
beyond the end of the file, the position is left at the end of the file.
If this fails (for instance, *stream* may be a pipe) and *nrec* is
nonnegative, it skips forward by reading the file and discarding the
output.

*fea_skiprec* changes position in a file described by the ESPS header
structure indicated by *hdr.* When the file is an ordinary FEA file
(*FEA*(5-ESPS)), the effect is simply that of

> skiprec(stream, nrecs, size_rec(hdr));

However, *fea_skiprec* also works when \**hdr* is a surrogate header
created by *read_header*(3-ESPS) upon reading a NIST *Sphere* file or an
Entropic *Esignal* file. In those cases *fea_skiprec* calls the
appropriate *Sphere* or *Esignal* routine. It can thus handle certain
formats that do not store records in fixed-size chunks. Examples are
*Sphere* variable-rate compressed formats and the *Esignal* ASCII
representation. Being more general than the combination of *skiprec*
with *size_rec*(3-ESPS), the function *fea_skiprec* is to be preferred.

# DIAGNOSTICS

If a seek error occurs and *nrec* is negative, *skiprec* prints an error
message on the error output and exits. An assertion failure
(*spsassert*(3-ESPS)) occurs if *skiprec* is called with a NULL argument
*stream* or a negative argument *siz,* or if *fea_skiprec* is called
with a NULL argument *stream* or a NULL argument *hdr.*

# SEE ALSO

*read_header*(3-ESPS), *size_rec*(3-ESPSu), *spsassert*(3-ESPS),\
*FEA*(5-ESPS)

# AUTHOR
