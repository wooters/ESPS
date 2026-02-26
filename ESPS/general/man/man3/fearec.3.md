# NAME

    allo_fea_rec    - allocate memory for an ESPS FEA file record
    copy_fea_rec	- copy data from one ESPS FEA record to another
    get_fea_rec     - get the next data record from an ESPS FEA data file
    print_fea_rec   - print an ESPS FEA data record
    print_fea_recf  - print fields in an ESPS FEA data record
    put_fea_rec     - put an ESPS FEA data record onto the file
    free_fea_rec	- free storage for a FEA record

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    struct fea_data *
    allo_fea_rec(hd)
    struct header *hd;

    void
    copy_fea_rec(irec,ihd,orec,ohd,fields,trans)
    struct fea_data	    *ihrec;
    struct header	    *ihd;
    struct fea_data	    *orec;
    struct header	    *ohd;
    char  **fields;
    short **trans;

    int
    get_fea_rec(data, hd, file)
    struct fea_data *data;
    struct header *hd;
    FILE *file;

    void
    print_fea_rec(data, hd, file)
    struct fea_rec *data;
    struct header *hd;
    FILE *file;

    void
    print_fea_recf(data, hd, file, fields)
    struct fea_rec *data;
    struct header *hd;
    FILE *file;
    char *fields[];

    void
    put_fea_rec(data, hd, file)
    struct fea_rec *data;
    struct header *hd;
    FILE *file;

    void
    free_fea_rec(rec)
    struct fea_data *rec;

# DESCRIPTION

*allo_fea_rec* allocates memory for an FEA file record and returns a
pointer to it. Since the size of the allocated record depends on values
in the data file header, it is important to be sure that a given FEA
record is consistent with the header of the file it is being used with.
The FEA data read/write routines use these same values in the header to
determine the amount of data to read or write. A mismatch could cause
the program to fail in unpredictable ways. It is possible to allocate
only one record, for both input and output, if the programmer is certain
that the values of all header items are the same in both the input and
output files. If the record is being allocated for a new file (to be
written), then all fields in the Feature file must be created with
*add_fea_fld*(3-ESPSu) before this function is called.

*copy_fea_rec* copies data from the feature record to which *irec*
points into the one to which *orec* points. Since values in a file
header determine the format of the record structure, *irec* and *orec*
must be properly allocated according to the respective headers *ihd* and
*ohd* before the function is called. The value of *fields* controls what
data is copied. If *fields* points to the first element of a
NULL-terminated array of field names, then the contents of the named
fields are copied from *irec* to *orec.* If *fields* is (char \*\*)
NULL, then all fields defined in *ihd* are copied. Each field copied
must have compatible definitions in the two headers. This means at the
very least that the name and type are the same, and the size defined in
*ohd* is no less than the size defined in *ihd.* The latter size fixes
the number of elements copied, and they are simply copied in linear
order. Thus, if the rank defined in *ihd* is greater than 1, the rank
and dimensions defined in *ohd* had better match those defined in *ihd,*
or else the correspondence between array positions and subscripts will
be scrambled. (For indexing of a field as a multidimensional array, see
*marg_index*(3-ESPSu).) If *trans* is not (long \*\*) NULL, it must be
an array containing translation tables for coded fields. In that case
*trans*\[*i*\] is ignored unless *field*\[*i*\] names a coded field, and
then *trans*\[*i*\] must point to the beginning of a vector of long
integers; a code *c* in the named field in *irec* is translated to
*trans*\[*i*\]\[*c*\] in *orec.* If *trans* is (long \*\*) NULL, codes
are copied without translation. In that case information in coded fields
will be corrupted unless corresponding *enums* arrays in the two headers
contain the same strings in the same order. The function
*fea_compat*(3-ESPSu) will check field definitions in the two headers
for compatibility and will create a translation table if one is needed.

*get_fea_rec* reads the next Feature file record from stream *file* into
the data structure pointed to by *data*. Values in the file header
determine the format of the record structure, so it is important that
*data* be properly allocated using header *hd*. EOF is returned upon end
of file. A positive non-zero value is returned otherwise.

*print_fea_rec* prints the FEA record pointed to by *data* onto the
stream *file*. The Feature file header is consulted for the defined
fields and data types. *print_fea_recf* prints the FEA record pointed to
by *data* onto the stream *file*. The argument *fields* is a NULL
terminated array of field names in the record. Only those fields are
printed. If *fields* is NULL, then all fields are printed. If any names
in *fields* are not valid field names in this record, they are ignored.
These functions are useful for debug output in programs which process
FEA data files.

*put_fea_rec* writes a Feature file data record pointed to by *data*
onto the stream *file*, which should be an open ESPS FEA file. The
header must be written out to the file before calling this function.

*free_fea_rec* frees storage for a FEA data record. Most often used by
library functions to avoid the accumulation of inaccessible temporary
records. Use with CAUTION, it invalidated any pointers into the data
arrays of the FEA record.

# EXAMPLES

    struct fea_data *p;	
    struct header *ih;
    char *fields[] = {"alpha","beta",NULL};

    ih = read_header(file);	/* read fea file header */
    p = allo_fea_rec(ih);	/* allocate record */
    if(get_fea_rec(p,ih,file) == EOF) eof...	/* read a record */

    (void) print_fea_record(p,ih,stderr)	/* print the record (all fields) */
    (void) print_fea_recf(p,ih,stderr,fields)	/* print some fields (alpha & beta) */

    struct fea_data *p;	
    struct header *oh;

    oh = new_header(FT_FEA);	/* create file header */
     ... fill in some values ... see add_fea_fld(3-ESPSu) ...
    write_header(oh,file);	/* write out header */
    p = allo_fea_rec(oh);	/* allocate record */
     ... fill in desired data record values...
    put_fea_rec(p,oh,file);	/* write data record */

# DIAGNOSTICS

If *hd* does not point to a FEA header then a message is printed on
stderr and the program terminates with exit 1. *copy_fea_rec* does not
check the headers for compatibility; see *fea_compat*(3-ESPS). In
*get_fea_rec*, if an incomplete record is read a message is printed on
the standard error output. In *put_fea_rec*, if an I/O error occurs
during write, a message is output to standard error and the programs
exits with status 1.

# BUGS

None known.

# SEE ALSO

    add_fea_fld(3-ESPSu), copy_header(3-ESPSu), eopen(3-ESPSu),
    fea_compat(3-ESPSu), get_fea_ptr(3-ESPSu), new_header(3-ESPSu),
    read_header(3-ESPSu), FEA(5-ESPS), ESPS(5-ESPS)

# AUTHOR

Alan Parker
