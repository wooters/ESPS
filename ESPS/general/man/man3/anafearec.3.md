# NAME

    allo_anafea_rec   - allocate memory for FEA_ANA file record
    get_anafea_rec    - get the next data record from an ESPS FEA_ANA data file
    init_anafea_hd    - initialize an FEA file header for subtype FEA_ANA
    put_anafea_rec    - write the next data record of an ESPS FEA_ANA file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>
    #include <esps/anafea.h>

    struct anafea *
    allo_anafea_rec(hd)
    struct header *hd;

    int
    get_anafea_rec(data, hd, file)
    struct anafea *data;
    struct header *hd;
    FILE *file;

    int
    init_anafea_hd(hd, order_vcd, order_unvcd, maxpulses, maxraw, 
    	maxlpc, filt_nsiz, filt_dsiz)
    struct	header *hd;
    long	order_vcd;
    long	order_unvcd;
    long	maxpulses;
    long	maxraw;
    long	maxlpc;
    short	filt_nsiz;
    short	filt_dsiz;

    void
    put_anafea_rec(data, hd, file)
    struct anafea *data;
    struct header *hd;
    FILE *file;

# DESCRIPTION

*allo_anafea_rec* allocates memory for a FEA_ANA file record and returns
a pointer to it. Since the size of the allocated record depends on
values in the data file header, it is important to be sure that a given
FEA_ANA record is consistent with the header of the file it is being
used with. (See *init_anafea_hd*(3-ESPSu)). Internally,
*allo_anafea_rec* calls *allo_fea_rec*(3-ESPSu) and then hooks the FEA
record up to a anafea struct.

*get_anafea_rec* reads the next FEA_ANA record from stream *file* into
the data structure pointed to by *data*, which must have been allocated
by means of a call to *allo_anafea_rec*(3-ESPSu). The parameter *hd*
points to the ESPS header in which the various FEA_ANA fields have been
defined. An EOF is returned upon end of file. A positive non-zero value
is returned otherwise.

*Init_anafea_hd* takes a pointer *hd* to an ESPS FEA header. It sets
*hd.hd.fea-\>fea_type* to FEA_ANA and initializes the record-field
definitions to define the fields that make up a file of subtype FEA_ANA.
It does this by means of calls to *add_fea_fld* (3-ESPSu). For a
description of the various FEA_ANA record fields, see FEA_ANA(5-ESPS).

*init_anafea_hd* also defines the generic header items described in
FEA_ANA(5-ESPS). The values of the following generic header items are
set equal to the values of the corresponding parameter to
*init_anafea_hd*: *order_vcd, order_unvcd, maxpulses, maxraw, maxlpc,
filt_nsiz*, and *filt_dsiz*. The value of the generic header item
*filters* is set to NO if both *filt_nsiz* and *filt_dsiz* are zero;
otherwise it is set to YES. *init_anafea_hd* also creates the generic
header items *spec_rep* and *src_sf*, but it is left to the calling
program to store appropriate values. *init_anafea_hd* returns 1 if any
of the internal calls to the function *add_fea_fld*(3-ESPSu) return an
error code. Otherwise, it returns 0. *init_anafea_hd* should only be
called when creating a new FEA_ANA file, after calling
*new_header*(3-ESPSu).

*put_anafea_rec* writes an FEA_ANA data record pointed to by *data* onto
the stream *file*, which should be an open ESPS FEA_ANA file. The header
must be written out to the FEA_ANA file before calling this function.

# EXAMPLE

**Reading an existing file:**

struct anafea \*p;\
struct header \*ih;\
ih = read_header(file); */\* read FEA_ANA file header \*/*\
p = allo_anafea_rec(ih); */\* allocate record \*/*\
if(get_anafea_rec(p,ih,file) == EOF) . . . */\* get next data record
\*/*\
\*p-\>frame_len = length; */\* record reference \*/*

    Creating a new file:

    struct header *ih;
    ih = new_header(FT_FEA);
    /*create FEA_ANA header for file without filters in the records*/
    if (init_anafea_hd(fea_oh, vord, uvord, pulses, raw, lpc, 0, 0) != 0) 
             ERROR_EXIT("error filling FEA header");
     .
     .
     .		
    write_header(ih);
    p = allo_anafea_rec(ih); 
     .
     .
     .
    put_anafea_rec(p,ih,file);

# DIAGNOSTICS

If *hd* does not point to a FEA header of subtype FEA_ANA, then the
program terminates with an assertion failure. In *get_anafea_rec*, if an
incomplete record is read a message is printed on the standard error
output. In *put_anafea_rec*, if an I/O error occurs during the write, a
message is written to standard error and the program exits with status
1.

# BUGS

None known.

# SEE ALSO

    allo_fea_rec(3-ESPSu), copy_header(3-ESPSu), eopen(3-ESPSu),
    new_header(3-ESPSu), read_header(3-ESPSu), FEA_ANA(5-ESPS), 
    FEA(5-ESPS), ESPS(5-ESPS)

# AUTHOR

John Shore
