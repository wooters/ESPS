# NAME

    allo_feaspec_rec   - allocate memory for FEA_SPEC file record
    get_feaspec_rec    - get the next data record from an ESPS FEA_SPEC data file
    init_feaspec_hd    - initialize a FEA file header for subtype FEA_SPEC
    put_feaspec_rec    - write the next data record of an ESPS FEA_SPEC file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/feaspec.h>

    struct feaspec *
    allo_feaspec_rec(hd, re_spec_format)
        struct header   *hd;
        int	    re_spec_format;

    int
    get_feaspec_rec(data, hd, file)
        struct feaspec  *data;
        struct header   *hd;
        FILE	    *file;

    int
    init_feaspec_hd(hd, def_tot_power, freq_format, spec_type,
    	    contin, num_freqs, frame_meth, freqs, sf, frmlen, re_spec_format)
        struct header   *hd;
        int		    def_tot_power;
        int		    freq_format;
        int		    spec_type;
        int		    contin;
        long	    num_freqs;
        int		    frame_meth;
        float	    *freqs;
        double	    sf;
        long	    frmlen;
        int	    re_spec_format;

    int
    put_feaspec_rec(data, hd, file)
        struct feaspec  *data;
        struct header   *hd;
        FILE	    *file;

# DESCRIPTION

> *allo_feaspec_rec*

This function allocates memory for a FEA_SPEC file record and returns a
pointer to it. Since the size of the allocated record depends on values
in the data file header, it is important to be sure that a given
FEA_SPEC record is consistent with the header of the file it is being
used with. (See *init_feaspec_hd*(3-ESPSu)). Internally,
*allo_feaspec_rec* calls *allo_fea_rec*(3-ESPSu) and then hooks the FEA
record up to a feaspec structure.

The feaspec structure refers to some fields that may in some cases be
defined implicitly by the file header rather than by data in the file
records. In such cases *allo_feaspec_rec* allocates storage separate
from the FEA file record and fills in the values. The field
*im_spec_value* in the structure is implicitly defined as an array of
*num_freqs* zeros whenever the generic header item *spec_type* has a
value other than SPTYP_CPLX. The fields *n_frqs* and *frqs* in the
structure are implicitly defined whenever the header item *freq_format*
has a value other than SPFMT_ARB_VAR. In that case *n_frqs* is the same
as *num_freqs,* and the frequencies contained in *frqs* are either found
in the generic header item *freqs* or computed from the generic header
item *sf.* See the description of *freq_format* in the FEA_SPEC(5-ESPS)
manual page for details. The field *frame_len* in the structure is
implicitly defined by the generic header item *frmlen* whenever the
header item *frame_meth* has the value SPFRM_FIXED.

If the header item *spec_type* has a value of SPTYP_DB, the real
spectral values can be made available in the data structure as either
floats or bytes, regardless of the representation in the external file.
If *spec_type* is SPTYP_DB and *re_spec_format* is FLOAT, then
*re_spec_val_b* in the data structure is NULL, and *re_spec_val* is
defined; it is defined as a pointer into the underlying *feaspec*
structure if the data type of the *re_spec_val* field in the external
file is FLOAT, and as a pointer to separate storage allocated by
*allo_feaspec_rec* if the external type is BYTE. If *spec_type* is
SPTYP_DB and *re_spec_format* is BYTE, then *re_spec_val* in the data
structure is NULL, and *re_spec_val_b* is defined; it is defined as a
pointer into the underlying *feaspec* structure if the data type of the
*re_spec_val* field in the external file is BYTE, and as a pointer to
separate storage allocated by *allo_feaspec_rec* if the external type is
FLOAT.

if the header item *spec_type* has a value other than SPTYP_DB, then the
parameter *re_spec_format* is ignored.

> *get_feaspec_rec*

This function reads the next FEA_SPEC record from stream *file* into the
data structure pointed to by *data,* which must have been allocated by
means of a call to *allo_feaspec_rec*(3-ESPSu). The parameter *hd*
points to the ESPS header in which the various FEA_SPEC fields have been
defined. If *spec_type* is SPTYP_DB, and the external and internal data
types of the spectrum data are different, *get_feaspec_rec* converts the
types. There are two cases. If the *re_spec_val* member in \**data* is a
non-NULL pointer, and the type of the *re_spec_val* field in the file is
BYTE, the function converts the byte values to float, subtracts a 64.0
dB offset, and stores the results in the array indicated by the pointer.
(Byte quantities in the range 0 to 127 represent spectral values in the
range -64.0 dB to 63.0 dB; see *FEA_SPEC*(5-ESPS)). If the
*re_spec_val_b* member in \**data* is a non-NULL pointer, and the type
of the *re_spec_val* field in the file is FLOAT, the function adds the
64.0 dB offset, converts the float values to byte, and stores the
results in the array indicated by the pointer.

The function returns EOF upon end of file. If *spec_type* is SPTYP_DB,
and a float-to-byte conversion results in an overflow, it returns the
number of such overflows. The normal return value is 0.

> *init_feaspec_hd*

This function takes a pointer *hd* to an ESPS FEA header. It sets
*hd.hd.fea-\>fea_type* to FEA_SPEC and initializes the record-field
definitions to define the fields that make up a file of subtype
FEA_SPEC. It does this by means of calls to *add_fea_fld*(3-ESPSu). For
a description of the various FEA_SPEC record fields, see
FEA_SPEC(5-ESPS). The field *tot_power* is created if the argument
*def_tot_power* has the value YES; if the value is NO, the field is left
undefined. The field *im_spec_val* is created only if *spec_type* has
the value SPTYP_CPLX defined in *esps/feaspec.h.* The fields *n_frqs*
and *frqs* are created only if *freq_format* has the value
SPFMT_ARB_VAR. The field *frame_len* is created only if *frame_meth* has
the value SPFRM_VARIABLE.

If *spec_type* is SPTYP_DB then the value of the *re_spec_format*
determines the data type *re_spec_val* on the physical file.
*re_spec_format* can be either FLOAT or BYTE. If *spec_type* != SPTYP_DB
then *re_spec_format* is ignored. Note that *re_spec_format* determines
the type of the data on the physical file. A similar parameter on
*allo_feaspec_rec* determines how the user program sees the data in
memory.

*init_feaspec_hd* also defines the required generic header items
described in FEA_SPEC(5-ESPS). The values of the following generic
header items are set equal to the values of the corresponding parameter
to *init_feaspec_hd:* *freq_format, spec_type, contin, num_freqs,* and
*frame_meth.*

If *freq_format* equals the constant SPFMT_ARB_FIXED defined in
*esps/feaspec.h,* the function defines the header item *freqs* and
copies *num_freqs* frequency values, starting at the location that the
argument *freqs* points to. If *freq_format* has any other value, the
header item is not created, and the argument *freqs* is ignored.

If *freq_format* equals one of the constants SPFMT_SYM_CTR,
SPFMT_SYM_EDGE, SPFMT_ASYM_CTR, and SPFMT_ASYM_EDGE defined in
*esps/feaspec.h,* the function defines the header item *sf* and sets it
equal to the argument *sf.* If *freq_format* has any other value, the
header item is not created, and the argument *sf* is ignored.

If *frame_meth* equals the constant SPFRM_FIXED defined in
*esps/feaspec.h,* the function defines the header item *frmlen* and sets
it equal to the argument *frmlen.* If *frame_meth* has any other value,
the header item is not created, and the argument *frmlen* is ignored.

*init_feaspec_hd* returns 1 if any of the internal calls to
*add_fea_fld*(3-ESPSu) return an error code. Otherwise, it returns 0.
*init_feaspec_hd* should only be called when creating a new FEA_SPEC
file, after the *new_header*(3-ESPSu) call.

> *put_feaspec_rec*

This function writes a FEA_SPEC data record pointed to by *data* onto
the stream *file,* which should be an open ESPS FEA_SPEC file. The
header must be written out to the FEA_SPEC file before this function is
called. If *spec_type* is SPTYP_DB, and the external and internal data
types of the spectrum data are different, this function, like
*get_feaspec_rec,* converts the types, adding or subtracting the
necessary 64.0 dB offset. If a float-to-byte conversion results in an
overflow, the function returns the number of such overflows. Zero is the
normal return value.

# EXAMPLE

    Reading an existing file:

    struct feaspec *p;
    struct header *ih;
    ih = read_header(file);	/* read FEA_SPEC file header */
    p = allo_feaspec_rec(ih,FLOAT);	/* allocate record */
    if(get_feaspec_rec(p,ih,file) == EOF) . . .     /* get next data record */
    for (i = 0; i < num_freqs; i++)
        p->re_spec_val[i] = 10.0 * log10(p->re_spec_val[i]);
    		/* record reference */

    Creating a new file:

    struct header *ih;
    ih = new_header(FT_FEA);
    /* create FEA_SPEC header */
    if ( init_feaspec_hd(fea_oh, YES, SPFMT_SYM_EDGE, SPTYP_DB,
    	YES, 257L, SPFRM_FIXED, (float *) NULL, 8000.0, 180L, BYTE) != 0 )
        ERROR_EXIT("error filling FEA header");
     .
     .
     .		
    fd = fopen(outputfile,"w");
    write_header(ih,fd);
    p = allo_feaspec_rec(ih,FLOAT); 
     .
     .
     .
    if(put_feaspec_rec(p,ih,file) != 0) float to byte conversion error

# DIAGNOSTICS

If *hd* does not point to a FEA header of subtype FEA_SPEC, then the
program terminates with an assertion failure. In *get_feaspec_rec,* if
an incomplete record is read, a message is printed on the standard error
output. In *init_feaspec_hd,* if the value of *freqs* is required but is
NULL, the program terminates with an assertion failure. In
*put_feaspec_rec,* if an I/O error occurs during the write, a message is
written to standard error, and the program exits with status 1.

# BUGS

None known.

# SEE ALSO

    allo_fea_rec(3-ESPSu),  copy_header(3-ESPSu), 
    eopen(3-ESPSu), new_header(3-ESPSu), 
    read_header(3-ESPSu), ESPS(5-ESPS), FEA(5-ESPS), 
    FEA_SPEC(5-ESPS), SPEC(5-ESPS)

# AUTHOR

Rodney Johnson
