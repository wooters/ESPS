# NAME

    filt2fea - transform FILT file to FEA_FILT file 
    fea2filt - transform FEA_FILT file to FILT file 

# SYNOPSIS

**filt2fea** \[ **-P** *params* \] \[ **-r** *range* \] \[ **-x**
*debug_level* \] *filt_file fea_filt_file*

**fea2filt2** \[ **-P** *params* \] \[ **-r** *range* \] \[ **-x**
*debug_level* \] *fea_filt_file filt_file*

# DESCRIPTION

These programs convert filter data between ESPS file types FEA_FILT and
FILT. Note that the FEA_FILT file type is meant to replace the FILT file
type. *filt2fea* reads the header from the FILT file *filt_file*,
allocates an appropriate FEA_FILT header, reads the specified FILT
records from *filt_file*, and transforms them to FEA_FILT records which
are written to the new FEA_FILT file *fea_filt_file*. *fea2filt*
converts the FEA_FILT file *fea_filt_file* to a new FILT file
*filt_filt* in the same way. All header items, both generic and those
defined in the header, are copied from the source header to the
destination header.

Note that additional fields cannot be added to FILT records, so
*fea2filt* copies only the FEA_FILT record fields *num_degree,*
denom_degree, num_coeff, and *denom_coeff* to the destination FILT file.
Other fields in the FEA_FILT file are not copied.

# OPTIONS

The following options are supported:

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

**-r** *range*  
Select a range of records to be processed. The default is all the
records in the source file. (See *grange_switch(3-ESPS)* for full
details of generic range specification.)

**-x** *debug_level* **\[0\]**  
Increasing values provide a more detailed running commentary on the
program's progress. The default level is zero, which causes no debug
output.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*start - integer*  
> This is the first record of the source file to process. The default
> is 1. It is not read if an initial record is specfied by the **-r**
> option.

*nan - integer*  
> This is the number of records to process. It is not read if the **-r**
> option is used to specify the last record to be processed. A value of
> zero means all subsequent records in the file; this is the default.

*debug_level - integer*  
> Not read if the **-x** option is used.

# ESPS COMMON

The common file is not read.

# ESPS HEADERS

No information is lost when transforming a FILT file to a FEA_FILT file.
No information is lost when transforming a FEA_FILT file to a FILT file
if no additional fields have been added to the FEA_FILT file.
*copy_genhd* (3-ESPS) is used to duplicate the source generic header
items in the destination header.

# SEE ALSO

notch_filt(1-ESPS), FILT(5-ESPS), atofilt(1-ESPS), wmse_filt(1-ESPS),
iir_filt(1-ESPS), xpz(1-ESPS), init_feafilt_hd(3-ESPSu),
init_feafilt_hd(3-ESPSu), allo_feafilt_rec(3-ESPSu),
get_feafilt_rec(3-ESPSu), put_feafilt_rec(3-ESPSu), ESPS(5-ESPS),
FEA(5-ESPS), FEA_FILT(5-ESPS)

# AUTHOR

Man pages and program by Bill Byrne.
