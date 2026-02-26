# NAME

btosps - convert headerless binary sampled data to an ESPS FEA_SD file

# SYNOPSIS

**btosps** \[ **-P** *param_file* \] \[ **-f** *sampling_rate* \] \[
**-T** *start_time* \] \[ **-n** *nchan* \] \[ **-t** *data_type* \] \[
**-S** *skip_bytes* \] \[ **-F** \] \[ **-c** *comment* \] \[ **-C**
*comment_file* \] \[ **-E** \] \[ **-x** *debug_level* \] *infile*
*outfile*

# DESCRIPTION

*Btosps* converts a headerless binary sampled data file into an ESPS
FEA_SD file. The input data can be of any ESPS supported data type
(DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX,
SHORT_CPLX, BYTE_CPLX); multi-channel data are supported.

If the first argument is "-", *btosps* will read from the standard
input. If the second argument is "-", it will write to the standard
output.

Use *addfeahd* (1-ESPS) for more general conversions to FEA files.

For record-keeping purposes, *btosps* stores an ASCII comment in the
header of of the output file. The comment should describe the origins of
the data. If a comment is not supplied in the parameter file or by means
of the **-c** or **-C** options, the user is prompted for one. If
*infile* is standard input, the comment must be supplied directly as the
user cannot be prompted.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
The name of the ESPS parameter file.

**-f** *sampling_rate \[8000\]*  
The sampling rate - the value is stored in the generic header item
*record_freq* in the output file.

**-T** *start_time \[0\]*  
The starting time of the data - the value is stored in the generic item
*start_time*.

**-n** *nchan \[1\]*  
The number of data channels. The data are assumed to be stored in the
same order as in an ESPS FEA_SD file, i.e., the first sample from all
channels, followed by the second sample from all channels, etc. The
dimension of the output field "samples" is *nchan*.

**-S** *skip_bytes*  
This many bytes will be skipped at the beginning of the input file. If
only a section of the raw input file is to be converted, the UNIX *dd*
program can be used to pre-process the raw data file. This option is
normally used to skip over an existing non-ESPS file header.

**-F**  
If this option is used, then the **-S** option described above must also
be used. This option causes the data skipped at the beginning of the
file to be saved in the output ESPS file, as a *foreign header*. Two
generic header items are created in the output file; *foreign_hd_length*
and *foreign_hd_ptr*. The item *foreign_hd_length* is given the value of
the **-S** option; i.e. the number of bytes to skip. The item
*foreign_hd_ptr* is set to the in memory address of this block of data
after it is read from the input file. This is used by
*write_header*(3-ESPS) to save this information in the ESPS file. The
intention here, is to allow a non-ESPS header that might already be on a
file, to be preserved as the file is converted to ESPS. On the ESPS
file, the foreign header is physically located between the ESPS header
and the data records. The program *bhd*(1-ESPS) can be used to remove
the ESPS header and leave the original foreign header. Also see
*read_header*(3-ESPS) and *write_header*(3-ESPS).

Note that the machine independent file I/O cannot operate on foreign
headers (since we have no way of knowing the internal structure). If an
ESPS file containing a foreign header is moved to a machine of a
different data format than the one on which it was created, the foreign
header will not be translated as the ESPS header and data is.

A user written program can use the value of the generic *foreign_hd_ptr*
in order to access any information that is in the foreign header. The
type of this generic is **long**, so it must be cast to a **(char \*)**
and then it can be used to address into the foreign header.

**-c** *comment*  
Specifies that the ASCII string *comment* be added as a comment in the
header of the output file.

**-C** *comment_file*  
Specifies that the contents of the file *comment_file* be added as a
comment in the header of the output file.

**-E**  
By default, the input file is assumed to be in the machine's native data
representation. If this option is used, the input is taken to be in ESPS
EDR representation. This would be the case, for example, if the input
file was an ESPS that was processed with *bhd* on a system that produced
EDR format files. Regardless of the format of the input file, the output
file format is controlled by the **ESPS_EDR** environment variable, as
are all programs which produce ESPS files. If the Unix environment
variable **ESPS_EDR** has the value of *on*, then the output file is in
Entropic's external data representation and can be read by any ESPS
implementation on any supported machine. If this variable is not
defined, then the output file is in the machine's native format. This
format can be read by some ESPS implementations, but not all.

**-t** *data_type \[short\]*  
Specifies the numberic type of the data in *infile*. Possible values are
DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX,
SHORT_CPLX, BYTE_CPLX.

**-x** *debug_level \[0\]*  
For *debug_level* values greater than 0, various debugging messages are
printed. The higher the value of *debug_level*, the more verbose the
messages.

# ESPS PARAMETERS

The following values are read from the parameter file if they exist.
Command line options override the parameter file values.:

> *sampling_rate - float*

> The data sampling rate, stored in the generic header item
> *record_freq*. Default is 8000 Hz.

> *nchan - int*

> The number of data channels. Default value is 1.

> *start_time - float*

> The starting time of the converted data. Default is 0.

> *data_type - string*

> The data_type of the input data; possible values are DOUBLE, FLOAT,
> LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX, SHORT_CPLX,
> BYTE_CPLX.

> *skip_bytes - int*

> The number of bytes to skip at the beginning of the input file.
> Default is 0.

# ESPS COMMON

ESPS Common is not read by *btosps*. The following items are written
into the ESPS Common file if the output is not standard output:

> *start - integer*

> The starting point, always 1 in this case.
>
> *nan - integer*

> The number of points in the output file.
>
> *prog - string*

> This is the name of the program (*btosps* in this case).
>
> *filename - string*

> The name of the output ESPS file.

These items are not written to ESPS COMMON if the output file is
\<stdout\>.

# ESPS HEADER

The universal part of the header if filled in in the usual way. The
generic *record_freq* is filled in with the sampling rate, and the item
*start_time* is filled in with the starting time. If the output is not
standard output, the generic header item *max_value* is filled in with
the maximum absolute value of the data in the file.

# DIAGNOSTICS

*Btosps* informs the user and quits if the input file does not exist.
*Btosps* informs the user and quits if no comment is supplied and if the
user cannot be prompted for one.

# BUGS

None known.

# SEE ALSO

    dd(1), addfeahd (1-ESPS), addfea(1-ESPS), mergefea (1-ESPS), 
    mux(1-ESPS), demux (1-ESPS), bhd(1-ESPS), comment (1-ESPS)

# AUTHOR

Original program by Ajaipal S. Virdy, Communications and Signal
Processing Laboratory, University of Maryland, College Park. ESPS
changes by Alan Parker and John Shore, Entropic Speech, Inc.
