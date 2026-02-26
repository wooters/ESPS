# NAME

    allo_vqfea_rec - allocate memory for FEA_VQ file record
    get_vqfea_rec - get the next data record from an ESPS FEA_VQ data file
    init_vqfea_hd - initialize an FEA file header for subtype FEA_VQ
    put_vqfea_rec - write the next data record of an ESPS FEA_VQ file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/vq.h>

    struct vqcbk *
    allo_vqfea_rec(hd)
    struct header *hd;

    int


    get_vqfea_rec(data, hd, file)


    struct vqcbk *data;


    struct header *hd;


    FILE *file;

    int
    init_vqfea_hd(hd, rows, cols)
    struct header *hd;	/*FEA file header*/
    long rows;		/*number of rows in codebook*/
    long cols;		/*number of columns in codebook*/

    void


    put_vqfea_rec(data, hd, file)


    struct vqcbk *data;


    struct header *hd;


    FILE *file;

# DESCRIPTION

*allo_vqfea_rec* allocates memory for a FEA_VQ file record and returns a
pointer to it. The number of elements allocated to *clusterdist* and
*clustersize* os given by the generic header item *codebook size.* The
number of elements allocated to *codebook* is given by the product of
the two generic header items *codebook size* and *codeword dimen.*
(These allocations assume that the header was initialized with
*init_vqfea_hd* (3-ESPSu). Since the size of the allocated record
depends on values in the data file header, it is important to be sure
that a given FEA_VQ record is consistent with the header of the file it
is being used with. (See *init_vqfea_hd* (3-ESPSu). Internally,
*allo_vqfea_rec* calls *allo_fea_rec* (3-ESPSu) and then hooks the FEA
record up to a vqcbk struct. Note that, like other components, the
codebook is stored in the FEA record. Thus, for example, you cannot
assign an arbitrary pointer to the codebook and expect *put_vq_rec* to
work properly.

*get_vqfea_rec* reads the next FEA_VQ record from stream *file* into the
data structure pointed to by *data*, which must have been allocated by
means of a call to *allo_vqfea_rec.* The parameter *hd* points to the
ESPS header in which the various FEA_VQ fields have been defined. When
the header was originally created, it must have been initialized by
means of *init_vqfea_hd* (3-ESPSu). An EOF is returned upon end of file.
A positive non-zero value is returned otherwise.

*Init_vqfea_hd* takes a pointer *hd* to an ESPS FEA header. It sets
*hd.hd.fea-\>fea_type* to FEA_VQ and initializes the record-field
definitions to define the fields that make up a file of subtype FEA_VQ.
It does this by means of calls to *add_fea_fld* (3-ESPSu). The parameter
*rows* specifies the size of the fields *clusterdist* and *clustersize.*
The size of the *codebook* field is *rows \* cols .* For a description
of the various FEA_VQ record fields, see FEA_VQ(5-ESPS). *Init_vqfea_hd*
also defines the generic header items *design_size* and *codeword_dimen
,* and it sets their values respectively to *rows* and *cols.*
*Init_vqfea_hd* returns 1 if any of the internal calls to *add_fea_fld*
(3-ESPSu) return an error code. Otherwise, it returns 0. *Init_vqfea_hd*
should only be called when creating a new FEA_VQ file, after the call to
*new_header* (3-ESPSu).

*put_vqfea_rec* writes an FEA_VQ data record pointed to by *data* onto
the stream *file*, which should be an open ESPS VEA_VQ file. The header
must be written out to the FEA_VQ file before calling this function.
When the header was originally created, it must have been initialized by
means of *init_vqfea_hd* (3-ESPSu).

# EXAMPLE

struct vqcbk \*p;\
struct header \*ih;\
ih = read_header(file); /\* read FEA_VQ file header \*/\
p = allo_vqfea_rec(ih); /\* allocate record \*/\
design_size= \*p-\>design_size; /\* record reference \*/
if(get_vqfea_rec(p,ih,file) == EOF) . . .

    ih = new_header(FT_FEA);
    if (init_vqfea_hd(fea_oh, c_rows, fea_dim) != 0) 
             ERROR_EXIT("error filling FEA header");
     .
     .
     .		
    write_header(ih);
    p = allo_vqfea_rec(ih); 
     .
     .
     .
    put_vqfea_rec(p,ih,file);

# DIAGNOSTICS

If *hd* does not point to a FEA header of subtype FEA_VQ, then the
program terminates with an assertion failure. In *get_vqfea_rec,* if an
incomplete record is read, a message is printed on the standard error
output. With *put_vqfea_rec,* if an I/O error occurs during the write, a
message is written to standard error and the program exits with status
1.

# BUGS

None known.

# SEE ALSO

    eopen(3-ESPSu), allo_fea_rec(3-ESPSu), copy_header(3-ESPSu), 
    new_header(3-ESPSu), read_header(3-ESPSu), FEA_VQ(5-ESPS),
    FEA(5-ESPS), ESPS(5-ESPS)

# AUTHOR

John Shore
