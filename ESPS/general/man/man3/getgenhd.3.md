# NAME

    get_genhd - get a pointer to a generic header item
    get_genhd_c - get a pointer to generic header item of type char
    get_genhd_s - get a pointer to generic header item of type short or coded
    get_genhd_l - get a pointer to generic header item of type long
    get_genhd_f - get a pointer to generic header item of type float
    get_genhd_d - get a pointer to generic header item of type double
    get_genhd_coded - get a pointer to string representations of coded generic header items
    get_genhd_val - get the value of a numeric scalar generic header item
    get_genhd_efile - get a pointer to the header of an external ESPS EFILE
    get_genhd_efile_name - get a pointer to the name of an external ESPS EFILE
    get_genhd_afile - get a stream pointer to an AFILE generic header item
    get_genhd_afile_name - get a pointer to the name of an external ESPS AFILE

# SYNOPSIS

\#include \<esps/esps.h\>

    char *
    get_genhd(name, hd)
    char *name;
    struct header *hd;

    char *
    get_genhd_c(name, hd)
    char *name;
    struct header *hd;

    short *
    get_genhd_s(name, hd)
    char *name;
    struct header *hd;

    long *
    get_genhd_l(name, hd)
    char *name;
    struct header *hd;

    float *
    get_genhd_f(name, hd)
    char *name;
    struct header *hd;

    double *
    get_genhd_d(name, hd)
    char *name;
    struct header *hd;

    char **
    get_genhd_coded(name, hd)
    char *name;
    struct header *hd;

    double
    get_genhd_val(name, hd, default)
    char *name;
    struct header *hd;
    double default;

    struct header *
    get_genhd_efile(name, hd)
    char *name;
    struct header *hd;

    char *
    get_genhd_efile_name(name, hd)
    char *name;
    struct header *hd;

    FILE *
    get_genhd_afile(name, hd)
    char *name;
    struct header *hd;

    char *
    get_genhd_afile_name(name, hd)
    char *name;
    struct header *hd;

# DESCRIPTION

*Get_genhd* returns a pointer to the data associated with the generic
header item *name*. It is a "bare" form of these functions and should
rarely be used in normal programs. Programs should usually use one of
these type-specific versions. The functions *get_genhd_s*, *get_gehd_l*,
*get_genhd_f*, *get_genhd_d*, and *get_genhd_c* call *get_genhd* and
return a pointer value of the correct type.

The function *get_genhd_coded* returns a pointer to a list of character
strings that represent the text values of the coded item (if the size of
the coded item is greater than 1, there is one string for each element).
This is most often needed when it is desired to print a coded value. For
a list of all possible values, use *genhd_codes*. Note that when using a
coded value for program control (as in a *switch* statement), its
numeric must be used, and *get_genhd_s* should be used in this case.

The value returned by *get_genhd_val* is the value of the header item
*name* converted to DOUBLE, provided that the item has one of the
numeric types DOUBLE, FLOAT, LONG, SHORT, and CHAR (or BYTE). If *name*
is not defined as a generic header item in *hd,* or its data type is not
numeric the returned value is that of the argument *default.* If *name*
is not a scaler (i.e. its size is greater than 1) the the value returned
is the value of the first element of *name.*

*Get_genhd_efile* attempts to open the filename stored in the header
item *name* and returns a pointer to the header of that file. If the
file cannot be opened, or it is not a valid ESPS file, or *name* is not
of type EFILE, then the function returns NULL. Note that since this
function opens and processes file referenced by the header item each
time it is called, the function should not be called more than once for
a given value of *name*. The function does not keep the external ESPS
file open and no provision is made for reading the data in this file.
Note that this call can be expensive in the current implementation in
cases where the EFILE is on a remote host, as *rcp* is used to obtain a
local copy.

*Get_genhd_afile* attempts to open the filename stored in the header
item *name* and returns a file stream pointer (FILE \*) to that file. If
the file cannot be opened or *name* is not of type AFILE the function
returns NULL. Note that this call can be expensive in the current
implementation in cases where the AFILE is on a remote host, as *rcp* is
used to obtain a local copy.

*Get_genhd_efile_name* and *get_genhd_afile_name* return the name of the
file referenced by the generic header item *name*. (Do not confuse the
name of the generic header item, with that of the referenced filename.)
If *name* is not of type EFILE or AFILE, then NULL is returned.

These functions can only be called when the value of *hd* is a non-NULL
header pointer such as the result returned by *read_header*(3-ESPSu) (or
possibly *new_header*(3-ESPSu) or *copy_header*(3-ESPSu)).

All these functions except *get_genhd_val* return NULL if *name* does
not exist in the header.

# EXAMPLE

    float *p_zeta;
    /* read in the header */
    hd = read_header(file);
    /* get generic header item zeta, assume you already know its type */
    p_zeta = get_genhd_f("zeta", hd);
    /* use its value */
    y = *p_zeta*45.6;
    /* instead of using a pointer variable, you could do this */
    y = *get_genhd_f("zeta", hd)*45.6;
    /* print value (in ASCII) of generic header item spec_rep */
    fprintf (stdout, "spec_rep = %S", *get_genhd_coded("spec_rep", hd));

# DIAGNOSTICS

If *name* or *hd* is NULL, an assertion failure occurs (see
*spsassert*(3-ESPSu)) and a message is printed.

# SPECIAL NOTE

In earlier versions of ESPS, only *get_genhd* existed. Since it is typed
(char \*) the function return type should be coerced into the correct
type. Plain *get_genhd* should not be used in new programs.

# SEE ALSO

    add_genhd(3-ESPSu), genhd_list(3-ESPSu),
    genhd_type(3-ESPSu), genhd_codes(3-ESPSu),
    copy_genhd(3-ESPSu), read_header(3-ESPSu),
    new_header(3-ESPSu), copy_header(3-ESPSu),
    spsassert(3-ESPSu)

# AUTHOR

Alan Parker
