# NAME

get_deriv_vec - derive a vector from elements in an ESPS FEA file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    char *
    get_deriv_vec (fields, fea_rec, hd, type, length, vec)
    char **fields;
    struct fea_data *fea_rec;
    struct header   *hd;
    int type;
    long *length;
    char *vec;

# DESCRIPTION

*get_deriv_vec* returns a pointer to a vector *vec* containing values
from fields *fields* in an ESPS Feature record *fea_rec*. The ESPS
header *hd* is the header associated with the record *fea_rec*. If *vec*
is NULL, then memory is allocated for the vector, otherwise *vec* is
taken as a pointer to the data area for storage. The length of the
returned vector is returned via *length*.

*Fields* is a null terminated array consisting of strings of the
following form:


    	field_name[generic_range]

Each *field_name* is the name of a feature field and each
*generic_range* is a range specification in a form suitable for
*grange_switch*(3-ESPSu). For each string of the above form, data from
*fea_rec* is taken from the field, *field_name*, at the element
locations given by *generic_range*, and placed into a contiguous array,
*vec*. Data is appended to the end of *vec* until a NULL is encountered
in *fields*.

If *field_name* is not defined or the generic range does not exist in
the header pointed to by *hd*, then the program prints a message on
stderr and exits with status code 1. A pointer to the data is returned
otherwise, and on return, the pointer must be coerced to type *type*.

Note that fields of type CODED are stored in records as SHORTs (length
1). To obtain the corresponding ASCII string, use *fea_decode*(3-ESPS).
Note also that complex types are not handled by *get_deriv_vec*.

# EXAMPLE

    #include <esps/esps.h>
    #include <esps/fea.h>

    FILE *file;
    struct fea_data *fea_rec;
    struct header *ih;
    char **srcfields = { "raw_power[0]", "spec_power[1,3:5]", NULL };
    float *vec;

    ih = read_header(file);
    fea_rec = allo_fea_rec (ih);
    get_fea_rec (fea_rec, ih, file);
    type = FLOAT;
    vec = NULL;	/* allocate memory for data */

    vec = (float *) get_deriv_vec(srcfields, fea_rec, ih, type, (char *) NULL)

    /*
     On return:
       vec[0] = raw_power[0]
       vec[1] = spec_power[1]
       vec[2] = spec_power[3]
       vec[3] = spec_power[4]
       vec[4] = spec_power[5]
    */

# DIAGNOSTICS

get_deriv_vec: range of field name %s is 0:%d, requesting element %d.\
get_deriv_vec: field name %s not found in ESPS Feature file.

# BUGS

Complex types are not handled yet.

# SEE ALSO

    classify(1-ESPS), fea_deriv(1-ESPS), get_fea_deriv(3-ESPSu),
    cover_type(3-ESPSu), set_fea_deriv(3-ESPSu), fea_decode(3-ESPS),
    ESPS(5-ESPS), FEA(5-ESPS)

# AUTHOR

Manual page and program by Ajaipal S. Virdy
