# NAME

    allo_feafilt_rec - allocate memory for a FEA_FILT file record
    get_feafilt_rec - get the next data record from an ESPS FEA_FILT data file
    init_feafilt_hd - initialize a FEA file header for subtype FEA_FILE
    put_feafilt_rec - write the next data record of an ESPS FEA_FILT 
    data file
    feafilt_to_zfunc - zfunc structure from feafilt record

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/feafilt.h>

    struct feafilt *
    allo_feafilt_rec( hd)
    	struct	  header	*hd;

    int
    get_feafilt_rec( data, hd, file)
    	struct feafilt *data;
    	struct header *hd;
    	FILE *file;

    int 
    init_feafilt_hd( hd, max_num, max_denom, filter_design_params);
    	struct header *hd;
    	long max_num;
    	long max_denom;
    	filtdesparams *filter_design_params;

    void
    put_feafilt_rec( data, hd, file)
    	struct feafilt *data;
    	struct header *hd;
    	FILE *file;

    struct zfunc
    feafilt_to_zfunc( data)
           struct feafilt *data;

# DESCRIPTION

*allo_feafilt_rec* allocates memory for a FEA_FILT file record and
returns a pointer to it. Since the size of the allocated record depends
on values in the data file header, it is important to be sure that a
given FEA_SPEC record is consistent with the header of the file it is
being used with. (See *init_feafilt_hd*(3-ESPSu)). Internally,
*allo_feafilt_rec* calls *allo_fea_rec*(3-ESPSu) and then hooks the FEA
record up to a feafilt structure. If the value of the FEA_FILT header
generic header item *complex_filter* is NO, no memory is allocated for
the fields *im_num_coeff* and *im_denom_coeff* and they should be
treated as NULL pointers. If the value of the FEA_FILT header generic
header item *define_pz* is NO, no memory is allocated for the fields
*zero_dim, pole_dim, zeros* and *poles*; they should be treated as NULL
pointers.

*get_feafilt_rec* reads the next FEA_FILT record from stream *file* into
the data structure *data,* which already must have been allocated by
means of a call to *allo_feafilt_rec.* The parameter *hd* points to the
ESPS header in which the various FEA_FILT fields have been defined. An
EOF is returned upon end of file. Zero is returned if the function
returns normally.

*init_feafilt_hd* takes a pointer *hd* to an ESPS FEA header. It sets
*hd.hd.fea-\>fea_type* to FEA_FILT and initializes the record-filed
definitions to define the fields that make up a file of subtype
FEA_FILT. It does this by calls to *add_fea_fld (3-ESPS).* The necessary
values are passed in through the pointer *filter_design_params* to the
following structure

    typdef struct_filtdesparams {
    	short			complex_filter;
    	short			define_pz;
    	short			type;
    	short			method;
    	short			func_spec;
    	long			g_size;
    	long			nbits;
    	float			*gains;
    	long			nbands;
    	float			*bandedges;
    	long			npoints;
    	float			*points;
    	float			*wts;
    } filtdesparams; 

This structure is defined in the feafilt support module. If
*init_feafilt_hd* is called with a NULL value of *filter_design_params*,
the corresponding integer parameters are set to 0 and the pointers point
to 1 element zero filled arrays.

The header items *wts* and *gains* are both created as floating arrays
with the same number of elements. If the argument *func_type* is BAND,
they contain *nbands* elements. If the argument *func_type* is POINTS,
they contain *npoints* elements. They are both NULL pointers if
*func_type* is NONE. For a description of the various FEA_FILT record
fields, see FEA_FILT(5-ESPS). Zero is returned if the function returns
normally.

*put_feafilt_rec* writes a FEA_FILT data record pointed to by *data*
onto the stream *file,* which should be an open ESPS FEA_FILT file. The
header must be written out to the FEA_FILT file before this function is
called.

*feafilt_to_zfunc* creates a zfunc structure from a feafilt data record.
The feafilt fields num_degree and denom_degree are copied to the zfunc
fields nsiz and dsiz. Memory is allocated for the zfunc arrays zeros and
poles and the contents of the feafilt arrays re_num_coeff and
re_denom_coeff are copied to the new zfunc. Note that imaginary data in
the feafilt record is ignored.

# EXAMPLE

    Reading an existing file:

    struct feafilt *p;
    struct header *ih;
    ih = read_header(file);	/* read FEA_FILT file header */
    pp = allo_feafilt_rec(ih);	/* allocate record */
    if(get_feafilt_rec(p,ih,file) == EOF) . . .     /* get next data record */
    for (i = 0; i <= p->num_degree; i++)	/* record reference */
        printf("numerator coefficient %d: real part %e, imaginary part %e\n",
                      p->re_num_coeff[i].real, p->im_num_coeff[i].imag);

    Creating a new file:

    struct header *oh;
    oh = new_header(FT_FEA);
    filtdesparams fdp;
    fdp.type = FILT_LP;
    /* create FEA_FILT header */
    if ( init_feafilt_hd(oh, 16L, 0L, fdp) != 0 ) 
        ERROR_EXIT("error filling FEA header");
     .
     .		
    write_header(oh);
    p = allo_feafile_rec(oh); 
     .
     .
    p->num_degree = 16;
    for (i = 0; i< 16; i++) {	/* copy filter polynomial to record */
    	p->re_num_coeffs[i] = realpart[i];
    	p->im_num_coeffs[i] = imagpart[i];
    }
     .
     .
    put_feafilt_rec(p,ih,file);

# SEE ALSO

    filt2fea(1-ESPS), fea2filt(1-ESPS), init_feafilt_hd(3-ESPS),
    allo_feafilt_rec(3-ESPS), get_feafilt_rec(3-ESPS), 
    put_feafilt_rec(3-ESPS), FEA(5-ESPS)

# DIAGNOSTICS

If *hd* does not point to a FEA header of subtype FEA_FILT, then the
program terminates with an assertion failure. In *get_feafilt_rec,* if
an incomplete record is read, a message is printed on the standard error
output. In *put_feaspec_rec,* if an I/O error occurs during the write, a
message is written to standard error, and the program exits with status
1.

# BUGS

None known.

# AUTHOR

Bill Byrne
