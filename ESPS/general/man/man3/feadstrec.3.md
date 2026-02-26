# NAME

    allo_feadst_rec - allocate memory for an ESPS FEA_DST file record.
    get_feadst_rec - get the next data record from an ESPS FEA_DST file.
    init_feadst_hd - initialize a FEA file header for subtype FEA_DST.
    put_feadst_rec - write the next data record of an ESPS FEA_DST file.

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/feadst.h>
    #include <esps/vq.h>

    struct feadst *
    allo_feadst_rec(hd)
    struct header *hd;

    int
    get_feadst_rec(data, hd, file)
    struct feadst *data;
    struct header *hd;
    FILE *file;

    int
    init_feadst_hd(hd, max_num_sects)
    struct header *hd;
    long max_num_sects;

    void
    put_feadst_rec( data, hd, file )
    struct feadst *data;
    struct header *hd;
    FILE *file;

# DESCRIPTION

*Allo_feadst_rec* allocates memory for a FEA_DST file record and returns
a pointer to it. The memory allocations assume that the header was
initialized by a call to *init_feadst_hd*. Because the size of the
allocated record depends on values in the data file header, it is
important to ensure that a FEA_DST record is consistent with the header
of the file it is being used with \[see *init_feadst_hd*\]. Internally,
*allo_feadst_rec* calls *allo_fea_rec* (3-ESPS), and then hooks the FEA
record up to a *feadst* structure.

*Get_feadst_rec* reads the next FEA_DST record from stream *file* into
the data structure pointed to by *data*, which must have been allocated
by means of a call to *allo_feadst_rec*. The parameter *hd* points to
the ESPS header in which the various FEA_DST fields have been defined.
When the header was originally created, it must have been initialized by
means of *init_feadst_hd*. An EOF is returned upon end of file. A
positive, non-zero value is returned otherwise.

*Init_feadst_hd* accepts a pointer *hd* to an ESPS FEA file header. It
sets *hd.hd.fea-\>fea_type* to FEA_DST and initializes the record-field
definitions to describe the fields that make up a file of subtype
FEA_DST. It does this by means of calls to *add_fea_fld* (3-ESPS). For a
description of the various FEA_DST record fields, see *fea_dst*
(5-ESPS). *Init_feadst_hd* also defines the generic header items
described in *fea_dst* (5-ESPS). The values of these generic header
items are set equal to the values of the corresponding parameters in the
call to *init_feadst_hd*. *Init_feadst_hd* returns 1 if any of the
internal calls to *add_fea_fld* (3-ESPS) return an error code;
otherwise, it returns 0. *Init_feadst_hd* should be called after
*new_header*(3-ESPS) only when creating a new FEA_DST file.

*Put_feadst_rec* writes a FEA_DST data record pointed to by *data* onto
the stream *file*, which should be an open ESPS FEA_DST file. The header
must be written out to the FEA_DST file before calling this function.
When the header was originally created, it must have been initialized by
means of *init_feadst_hd*.

# EXAMPLES

    Reading an existing file:

    FILE *ifp;
    struct feadst *feadst_rec;
    struct header *ih;

    ih = read_header(ifp);
    feadst_rec = allo_feadst_rec(ih);
    if ( get_feadst_rec(feadst_rec, ih, ifp) == EOF ) . . .

    c = *feadst_rec->count;

    Creating a new file:

    FILE *ofp;
    struct feadst_rec;
    struct header *oh;

    oh = new_header(FT_FEA);
    if ( init_feadst_hd(oh, max_num_sects) )
        ERROR_EXIT("error filling FEA_DST header");
     . . .
    write_header(oh, ofp);
    feadst_rec = allo_feadst_rec(oh); 
     . . .
    *feadst_rec->cbk_rec = c;
    put_feadst_rec(feadst_rec, oh, ofp);

# DIAGNOSTICS

If *hd* does not point to a FEA header of subtype FEA_DST, the program
terminates with an assertion failure. In *get_feadst_rec*, if an
incomplete record is read, a message is written to *stderr*. In
*put_feadst_rec*, if an I/O error occurs during the write, a message is
written to *stderr* and the program exits with status 1.

# BUGS

None known.

# SEE ALSO

allo_fea_rec(3-ESPS), fea_dst(5-ESPS).

# AUTHOR

Programs and manual page by Alan Parker
