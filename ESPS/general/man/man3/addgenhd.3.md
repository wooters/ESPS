# NAME

    add_genhd_d - add a new generic header item of type double
    add_genhd_f - add a new generic header item of type float
    add_genhd_l - add a new generic header item of type long
    add_genhd_s - add a new generic header item of type short
    add_genhd_c - add a new generic header item of type char
    add_genhd_e - add a new generic header item of type enumerated (coded)
    add_genhd_efile - add a new generic header item of type EFILE (external ESPS file)
    add_genhd_afile - add a new generic header item of type AFILE (external ASCII file) 

# SYNOPSIS

\#include \<esps/esps.h\>

    double *
    add_genhd_d(name,ptr,size,hd)
    char *name;
    double *ptr;
    int size;
    struct header *hd;

    float *
    add_genhd_f(name,ptr,size,hd)
    char *name;
    float *ptr;
    int size;
    struct header *hd;

    long *
    add_genhd_l(name,ptr,size,hd)
    char *name;
    long *ptr;
    int size;
    struct header *hd;

    short *
    add_genhd_s(name,ptr,size,hd)
    char *name;
    short *ptr;
    int size;
    struct header *hd;

    char *
    add_genhd_c(name,ptr,size,hd)
    char *name;
    char *ptr;
    int size;
    struct header *hd;

    short *
    add_genhd_e(name,ptr,size,codes,hd)
    char *name;
    short *ptr;
    int size;
    char **codes;
    struct header *hd;

    char *
    add_genhd_efile(item_name,file_name,hd)
    char *item_name;
    char *file_name;
    struct header *hd;

    char *
    add_genhd_afile(item_name,file_name,hd)
    char *item_name;
    char *file_name;
    struct header *hd;

# DESCRIPTION

These functions create a new header item in the generic header item
space of the ESPS file header pointed to by *hd* and return a pointer to
it.

The following description applies to all of these functions, except
*add_genhd_efile* and *add_genhd_afile*. For those functions, see below.

If *ptr* is NULL, then memory is allocated for the data. If *ptr* is not
NULL, then no memory is allocated and *ptr* is taken as a pointer to the
data area to use for the header item. In either case, a pointer to the
data area is returned by the function. Note that in the case of *ptr* !=
NULL, it is not the *value* of the data at *ptr* that is put into the
header item, but its address is used as the data area. So the value at
the location pointed to by *ptr* at the time of the *write_header* call
will be the one saved in the header. The size of the data area (number
of elements in a vector, for example) must be given by *size*.

If *name* is already defined as a generic header item in *\*hd,* the
existing definition is lost and replaced by a new definition. Data
storage for the existing definition is not freed by *add_genhd,* so it
is possible for storage allocated by *malloc*(3C) or *calloc*(3C) to be
left unfreed but inaccessible.

If it is important to know whether *name* is already defined, use
*genhd_type*(3-ESPSu). For example, to conserve storage, one might want
to use *genhd_type* and, if the result is not HD_UNDEF, apply *free*(3C)
to the pointer returned by *get_genhd*(3-ESPS) befor calling
*add_genhd.* This procedure is safe if the existing data storage was
allocated by *read_header*(3-ESPS), by *copy_header*(3-ESPS), or by
*add_genhd* with a NULL value for the argument *ptr.* It must not be
followed if the existing data storage was explicitly supplied to a
previous call of *add_genhd* and was not obtained from *malloc* or
*calloc.*

In the case of *add_genhd_c*, if the *size* argument is zero, then *ptr*
is assumed to be a NULL-terminated character string and its length is
used.

*add_genhd_e* is used to create a header field of type CODED. It must be
passed a pointer to an array of character strings giving the possible
values for the field (*codes*). This array, in a form required by
*lin_search*(3-ESPSu), is a NULL terminated array of character strings
(NULL terminated as usual). A pointer to the user supplied data is
stored in the header until the header it written out, so *codes* should
not be altered until after the *write_header*(3-ESPSu) has been done.
Note that when the value of a coded generic is obtained, the value is a
short (i.e., use *get_genhd_s*); for the string representation, use
*get_genhd_coded*.

*Add_genhd_efile* is used to create a generic header item of type EFILE
(external ESPS file). The name of an ESPS data file is stored by the
header item. By using *get_genhd_efile*, a pointer to the header of this
file can be accessed. Just the name can be returned with
*get_genhd_efile_name*.

*Add_genhd_afile* is used to create a generic header item of type AFILE
(ascii file). This file is normally an ascii data file that contains
some additional reference information associated with the ESPS data
file. A *get* function is available that attempts to open the file and
returns a file stream pointer.

*Add_genhd_efile* and *add_genhd_afile* require three arguments.
*Item_name*, is the name of the header item to create, *file_name* is
the name of the ESPS data file to become an external ESPS file, and *hd*
is a pointer to the header to put this generic header into. The filename
stored in the header item must be a full path. If the character string
pointed to by *file_name* does not begin with a "/", then
*add_genhd_efile* prepends the current working directory onto the front
of the supplied character string to form a full path. The function
returns a pointer to the name of the external ESPS file (full path
name).

The external filename can also be in the form of *host:path*, where
*host* is the hostname of a node on a network and *path* is a full path
filename relative to that host. When a hostname is used, the filename
given must be a full path.

These functions should only be used on a header that is to be written
out. In particular, they must be called after the creation of the
header, either by *new_header*(3-ESPSu), *copy_header*(3-ESPSu), or
*read_header*(3-ESPSu), but before *write_header*(3-ESPSu) is called.

# EXAMPLE

    /* Create header */
    double *p_zeta;
    float beta;
    char *mycodes[] = {"AD", "FILE", "DISK", NULL);
    short source;
    hd = new_header(FT_SD);
    /* Add a header item called "zeta" that is a single (double *)/
    /* In this case, have the function allocate memory */
    p_zeta = add_genhd_d("zeta",NULL,1,hd);
    /* store some stuff into zeta */
    *p_zeta = 56.4;
    /* In another case, use beta, which is already allocated */
    /* beta may be given a value before or after the call */
    (void)add_genhd_f("beta",&beta,1,hd);
    (void)add_genhd_e("source",&source,1,mycodes,hd);
    /* create an item with an external ESPS file */
    (void)add_genhd_efile("ext_file1","/usr/esps/data/file1",hd);
    /* write the header out (after doing some other stuff, of course) */
    write_header(hd,file);

# DIAGNOSTICS

An assertion failure occurs (see *spsassert*(3-ESPSu)), and a message is
printed, if *hd* or *name* is equal to NULL, or if *size* is less than
1.

# SEE ALSO

    genhd_list(3-ESPSu), genhd_type(3-ESPSu), get_genhd(3-ESPSu), 
    genhd_codes(3-ESPSu), get_genhd_efile(3-ESPSu), 
    get_genhd_efile_name(3-ESPSu), get_genhd_afile(3-ESPSu), 
    get_genhd_afile_name(3-ESPSu), copy_genhd(3-ESPSu),
    new_header(3-ESPSu), copy_header(3-ESPSu), read_header(3-ESPSu), 
    spsassert(3-ESPSu), calloc(3C), malloc(3C), free(3C)

# AUTHOR

Alan Parker
