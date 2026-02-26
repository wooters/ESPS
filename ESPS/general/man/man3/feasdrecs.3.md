# NAME

    allo_feasd_recs   - allocate memory for FEA_SD file records
    get_feasd_recs    - get data records from an ESPS FEA_SD data file
    get_feasd_orecs    - get overlapping data from an ESPS FEA_SD data file
    init_feasd_hd    - initialize a FEA file header for subtype FEA_SD
    put_feasd_recs    - write data records to an ESPS FEA_SD file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/feasd.h>

    struct feasd *
    allo_feasd_recs(hd, data_type, num_records, data, make_ptrs);
        struct header   *hd;
        int	    	    data_type;
        long    	    num_records;
        char            *data;
        int		    make_ptrs;

    long
    get_feasd_recs(data, start, num_records, hd, file)
        struct feasd    *data;
        long    	    start, num_records;
        struct header   *hd;
        FILE    	    *file;

    long
    get_feasd_orecs(data, start, framelen, step, hd, file)
        struct feasd    *data;
        long    	    start, framelen, step;
        struct header   *hd;
        FILE    	    *file;

    int
    init_feasd_hd(hd, data_type, num_channels, start_time, mult_st_t, record_freq)
        struct header   *hd;
        int	    	    data_type, num_channels;
        double  	    *start_time;
        int		    mult_st_t;
        double	    record_freq;

    int
    put_feasd_recs(data, start, num_records, hd, file)
        struct feasd    *data;
        long    	    start, num_records;
        struct header   *hd;
        FILE    	    *file;

# DESCRIPTION

> *allo_feasd_recs*

This function allocates memory for a *feasd* structure, as described in
*FEA_SD*(5-ESPS), and fills in values for the structure members. If
requested, it will also allocate storage for the associated data array,
the pointer array for accessing the rows of the data array, or both. The
function allocates the data array if the argument *data* is (char \*)
NULL. If the argument is non-NULL, it should point to the beginning of a
suitable block of storage, and the supplied pointer value is simply
copied into the *data* member of the *feasd* structure. When the value
of the argument *make_ptrs* is YES, the function creates the pointer
array for accessing the rows of the data array. (see *FEA_SD*(5-ESPS)).
It does this whether the data array is allocated by *allo_feasd_recs* or
supplied by the calling function. When *make_ptrs* is NO, the structure
member *ptrs* is made NULL. The dimensions of the array are determined
by the argument *num_records* and the size of the "samples" field
defined in the header \**hd,* which gives the number of channels. The
data type of the array is determined by the *data_type* argument. Legal
values are given by the data-type constants BYTE, SHORT, LONG, etc.
defined in the include file *esps/esps.h.* Non-numeric ESPS data types
such as CHAR, CODED, EFILE, and AFILE are not allowed. The *data_type*
and *num_records* members of the structure are filled in with the values
of the corresponding function arguments. The returned value is a pointer
to the structure upon successful completion, or NULL in case of failure.

Since the structure of the data storage depends on values in the file
header, it is important to be sure that a given FEA_SD struct is
consistent with the header of the file it is being used with. A
programmmer who supplies a non_NULL value for the *data* argument
assumes the responsibility for its pointing to a storage area of
sufficient size. The size must be at least *num_records* \*
*num_channels* \* *typesiz*(*data_type*), where *num_channels* may be
obtained as the value of *get_fea_siz*( "samples", *hd,* (*short* \*)
*NULL,* (*long* \*\*) *NULL*).

> *get_feasd_recs*

This function attempts to read the next *num_records* FEA_SD records
from stream *file* and store the contents of the "samples" fields in the
the structure pointed to by *data,* beginning with element (or row)
number *start.* (Counting begins with 0 for the first element or row.)
If any fields besides "samples" are present, their contents are ignored;
they do, however, make reading slower. The sum of arguments
*start*+*num_records* must not exceed the limit *data-\>num_records.*
The function returns the actual number of records read. If no records
are read (end of file), 0 is returned. The ESPS file header \**hd* is
consulted for the type of data in the file, and if that differs from
*data-\>data_type,* the data are converted. If fewer than the requested
number *num_records* of records are read, the deficit is made up with
zero fill.

> *get_feasd_orecs*

Like *get_feasd_recs,* this function reads frames of sampled data from
an ESPS FEA_SD file. However, while *get_feasd_recs* moves a full frame
length between calls, *get_feasd_orecs* moves an arbitrary amount and is
therefore suitable for use by programs that analyze overlapping or
noncontiguous frames.

A frame consists of the data from the "samples" fields of *framelen*
records of the file. Each frame after the first begins *step* records
further along in the file than the previous frame; thus frames overlap
when *step*\<*framelen,* are exactly abutted when *step*==*framelen,*
and are separated by gaps when *step*\>*framelen.* Each call of the
function stores a frame in a buffer that consists of a segment of the
structure pointed to by *data,* beginning with element or row number
*start.* The sum *start*+*framelen* must not exceed
*data-\>num_records,* and any elements or rows preceding number *start*
or following number *start*+*framelen*-1 are left unchanged by the
function. All data read are converted, as necessary, from the type
indicated in the header to the type indicated in *data-\>data_type.* If
a read attempt yields fewer records than required (because the end of
file is reached), the deficit is made up by zero fill. The function
returns the number of valid samples in the buffer. This equals
*framelen* when the requested number of records are successfully read;
otherwise it is some smaller number.

The buffer is assumed to contain data from a prior invocation of
*get_feasd_orecs* or *get_feasd_recs.* Then, if *step*\<*framelen,* the
function drops the first *step* elements or rows of the buffer, shifts
the rest *step* positions toward the beginning, and attempts to read
*step* more records to fill out the vacated positions at the end of the
buffer. The returned value is the number of records read plus
(*framelen*-*step*).

If *step*\>=*framelen,* the function ignores the previous contents of
the buffer, skips *step*-*framelen* records in the file, and then
attempts to read the next *framelen* records--- *i.e.,* after skipping a
gap of *step*-*framelen* records between frames, *get_feasd_orecs*
operates like *get_feasd_recs.* Note that if *step*==*framelen,* the
result is adjacent, non-overlapping frames such as *get_feasd_recs*
produces.

The normal pattern of usage of *get_feasd_orecs* is to read an initial
frame with *get_feasd_recs* and then read each following frame with
*get_feasd_orecs.* The function does not maintain any internal memory;
calls for reading one file into one buffer may therefore be intermixed
with calls for reading other files into other buffers. For any one given
file, the arguments other than *step* should normally remain the same
from one call to the next. However, *step* may be varied freely. It is
permissible to call *get_feasd_orecs* with *step*==*0.* It then simply
returns *framelen,* and the buffer is not altered. Negative values for
*step* are not allowed.

> *init_feasd_hd*

This function takes a pointer *hd* to an ESPS FEA header and sets
*hd-\>hd.fea-\>fea_type* to FEA_SD. By calling *add_fea_fld*(3-ESPSu) it
initializes the header to define the field "samples". The data type of
the field is determined by the argument *data_type:* legal values are
given by the data-type constants BYTE, SHORT, LONG, etc. defined in the
include file *esps/esps.h.* Non-numeric ESPS data types such as CHAR,
CODED, EFILE, and AFILE are not allowed. The size of the field is given
by the argument *num_channels.* The arguments *start_time* and
*record_freq* initialize the required generic header items described in
*FEA_SD*(5-ESPS). If the argument *mult_st_t* is YES, there is a
starting time for each channel, and *start_time* points to the beginning
of an array of length *num_channels* containing the values, which are
copied into an array in the header item. If *mult_st_t* is NO, there is
just one starting time for the file, and *start_time* is a pointer to a
single element. By contrast, *record_freq* holds the actual value, not a
pointer to it. The value returned by the function is 0 upon successful
completion and a nonzero error code otherwise.

> *put_feasd_recs*

This function takes data from the structure pointed to by *data,*
starting with element (or row) number *start.* (Counting begins with 0.)
It puts the data into the "samples" fields of *num_records* FEA_SD
records and writes the records to the stream *file.* Unlike
*get_feasd_recs* and *get_feasd_orecs,* this function will not handle
records containing fields other than "samples". (It was felt that while
reading such records and ignoring the extra fields was a useful, writing
them and filling the extra fields with arbitrary values was not.)
Programs that need to write FEA_SD files with additional fields should
use *put_fea_rec(3-ESPSu).* The sum of arguments *start + num_records*
must not exceed the limit *data-\>num_records.* The ESPS file header
*\*hd* is consulted for the data type of the data in the file; if it
differs from the data type *data-\>data_type,* appropriate conversions
are performed. The file should be an open FEA_SD file. The header must
be written to the file before this function is called. The returned
value is 0 upon successful completeion and a non-zero error code
otherwise.

# EXAMPLE

# DIAGNOSTICS

# BUGS

None known.

# SEE ALSO

    copy_header(3-ESPSu), eopen(3-ESPSu), new_header(3-ESPSu), 
    read_header(3-ESPSu), ESPS(5-ESPS), FEA(5-ESPS), FEA_SD(5-ESPS)

# AUTHOR

Man page by Rodney Johnson, ESI.
