# NAME

    allo_feastat_rec - allocate memory for FEA_STAT file record
    get_feastat_rec  - get the next data record from an ESPS FEA_STAT data file
    init_feastat_hd  - initialize an FEA file header for subtype FEA_STAT
    put_feastat_rec  - write the next data record of an ESPS FEA_STAT file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/feastat.h>

    struct feastat *
    allo_feastat_rec(hd)
    struct header *hd

    int
    get_feastat_rec(data, hd, file)
    struct feastat *data;
    struct header *hd;
    FILE *file;

    int
    init_feastat_hd (hd, statfield, statsize, class_type, covar, invcovar, eigen)
    struct	header *hd;
    char	*statfield;
    int	statsize;
    char	**class_type;
    short	covar, invcovar, eigen; 

    void
    put_feastat_rec(data, hd, file)
    struct feastat *data;
    struct header *hd;
    FILE *file;

# DESCRIPTION

*allo_feastat_rec* allocates memory for a FEA_STAT file record and
returns a pointer to it. Since the size of the allocated record depends
on values in the data file header, it is important to be sure that a
given FEA_STAT record is consistent with the header of the file it is
being used with. (See *init_feastat_hd)* Internally, *allo_feastat_rec*
calls *allo_fea_rec* (3-ESPSu) and then hooks the FEA record up to a
feastat struct.

*get_feastat_rec* reads the next FEA_STAT record from stream *file* into
the data structure pointed to by *data*, which must have been allocated
by means of a call to *allo_feastat_rec.* The parameter *hd* points to
the ESPS header in which the various FEA_STAT fields have been defined.
An EOF is returned upon end of file. A positive non-zero value is
returned otherwise.

*init_feastat_hd* takes a pointer *hd* to an ESPS FEA header. It sets
*hd.hd.fea-\>fea_type* to FEA_STAT and initializes the record-field
definitions to define the fields that make up a file of subtype
FEA_STAT. It does this by means of calls to *add_fea_fld* (3-ESPSu). For
a description of the various FEA_STAT record fields, see
FEA_STAT(5-ESPS). *init_feastat_hd* always makes the *class, nsamp,* and
*mean* record fields in the FEA_STAT file. *class_type* should point to
the beginning of a NULL-terminated array of strings that is to be used
as the *enums* array (the set of coded values) for the field *class.* If
the value of *covar* is nonzero, then the COVAR record field name in
FEA_STAT is also created. Similarly for *invcovar* and *eigen*.
*init_feastat_hd* also defines the generic header items described in
FEA_STAT. The values of the following generic header items are set equal
to the values of the corresponding parameter to *init_feastat_hd:*
statfield and statsize. *init_feastat_hd* returns 1 if any of its calls
to *add_fea_fld* (3-ESPSu) return an error. Otherwise, it returns 0.
*init_feastat_hd* should only be called when creating a new FEA_STAT
file, after the call to *new_header* (3-ESPSu).

*put_feastat_rec* writes an FEA_STAT data record pointed to by *data*
onto the stream *file*, which should be an open ESPS FEA_STAT file. The
header must be written out to the FEA_STAT file before calling this
function.

# EXAMPLES

    struct feastat *p;	
    struct header *ih;
    ih = read_header(file);	/* read FEA_STAT file header */
    p = allo_feastat_rec(ih);	/* allocate record */
    if(get_feastat_rec(p,ih,file) == EOF) . . .
    mean[i] = p->mean[i];

    struct feastat *p
    struct header *fea_oh;
    FILE *ostrm;
    char *class_type[] = {"voiced", "unvoiced", "silent", NULL};

    fea_oh = new_header(FT_FEA);
    /*create FEA_STAT header for file without filters in the records*/
    if (init_feastat_hd(fea_oh, statfield, statsize, class_type, 1, 0, 0) != 0) 
             ERROR_EXIT("error filling FEA header");
     .
     .
     .		
    write_header(fea_oh, ostrm);
    p = allo_feastat_rec(fea_oh); 
     .
    p->mean[0] = mean[0];		/* record reference */
     .
    put_feastat_rec(p, fea_oh, ostrm);

# DIAGNOSTICS

If *hd* is not a FEA header, *init_feastat_hd* exits with an assertion
failure. In the other *feastat* functions, if *hd* does not point to a
FEA header of subtype FEA_STAT, then the program terminates with an
assertion failure. In *get_feastat_rec*, if an incomplete record is read
a message is printed on the standard error output. In *put_feastat_rec*,
if an I/O error occurs during the write, a message is written to
standard error and the program exits with status 1.

# BUGS

None known.

# SEE ALSO

    copy_header(3-ESPSu), eopen(3-ESPSu), new_header(3-ESPSu), 
    read_header(3-ESPSu), FEA_STAT(5-ESPS), FEA(5-ESPS), ESPS(5-ESPS)

# AUTHOR

Ajaipal S. Virdy.
