# NAME

copysps - copies selected records of an ESPS file to a new ESPS file

# SYNOPSIS

**copysps** \[ **-x** *debug_level* \] \[ **-f** \] \[ **-r** *range* \]
\[ **-g** *gen_range* \] \[ **-s** *time_range* \] \[ **-z** \] \[
*infile* \] *outfile*

# DESCRIPTION

*Copysps* copies selected records of an ESPS file to another ESPS file.
If *outfile* exists, then the selected records of *infile* are appended
to *outfile* provided that the input file and the output file are
compatible (see below for details). If *outfile* doesn't exist, it is
created. Appending data to *infile* is not allowed. If *outfile* is "-",
then stdout is used as output. If a single file name is given on the
command line, *copysps* uses that name as the output file and retrieves
the input file from ESPS Common (see EXAMPLES). Note that reading stdin
is not supported.

For FEA_SD files, additional capabilites are offered by *copysd*
(1-ESPS), which permits scaling the data and changing the numerical data
type.

If *outfile* already exists, then *copysps* checks the input file header
and the output file header for compatibility. Two ESPS files are
considered compatible if they satisfy the following conditions:

For ESPS FEA files:  
Feature header items fea_type, field count, names, sizes, ranks, types,
and enums must be the same in both files. If a field is a derived field,
then the names pointed to by srcfields must also agree in both files.
Since *copysps* does not require compatibility of generic header items
(indeed, none are copied from the input to the output file if the output
file exists already), you should be careful when copying records of
FEA_SD, FEA_ANA, FEA_SPEC, FEA_STAT, and FEA_VQ files. Refer to section
5 man pages for more information about these special feature files.

For ESPS FEA_SD files:  
The sampling rate of both files must be the same.

For ESPS SPEC files:  
Spectral header items order_vcd, order_unvcd, spec_an_meth, dcrem,
voicing, freq_format, spec_type, and contin must all be the same for
both files. If win_type, sf, spec_an_meth, or dcrem are not the same in
both files, then a warning message is printed on stderr and in the
comment field of the output file. (Note: SPEC files are obsolete and
have been replaced by FEA_SPEC files.)

For ESPS FILT files:  
Filter header items max_num, max_den, func_spec, nbands, npoints, nbits,
type, bandedges, points, gains, and wts must all be the same in both
files.

ESPS SCBK files not supported, yet.  

When updating an existing file without the **-f** option, a temporary
file is generated in the directory specified by the environment variable
ESPS_TEMP_PATH (default /usr/tmp). The operation will be faster if the
destination file is on the same file system as ESPS_TEMP_PATH. This is
not a significant difference unless the destination file is very large.

# OPTIONS

The following options are supported:

**-f**  
This option causes a fast copy to be done. This is done by appending the
selected records onto the end of the destination file. Use of this
option causes embedded headers not to be included in the output file.
Also, the command line is not saved as a comment in the output header
(the output header size cannot change). However, note that
*comment*(1-ESPS) can always be used to add comments to an existing ESPS
file. This option should not be used to produce archival files where the
entire processing history is needed.\

If the header version (*common.hdvers*) is not the same for the input
and output file, then a fast copy is not done. This is because the size
or the exact format of the header might be different and the write may
fail. The program checks the versions, and simply turns the **-f** flag
off if the versions do not match.

Note that two segment labeled files are not compatible unless they both
refer to the same set of sampled data files. Also, if you use copysps to
copy tagged records to a tagged file, it will become difficult to
determine which file the output tags refer to in cases where the input
file has tags refering to a different file than the tags in the output
file. To deal with such problems for now, use select instead of copysps.

**-r** *start:end*  
**-r***"***start:+incr**  
Determines the range of data records to process. In the first form, a
pair of unsigned integers gives the first and last points of the range.
If *start* is omitted, 1 is used. If *end* is omitted, the last point in
the file is used. The second form is equivalent to the first with *end =
start + incr .*

**-g** *range*  
Select a "generic" range of records to be processed. The default is all
the records in *infile*. (See *grange_switch(3-ESPS)* for full details
of generic range specification.)

**-s** *start_time:end_time*  
**-***"***start_time:+time_incr**  
Determines the range of records to be copied from *infile* by in units
of time (seconds). In the first form, a pair of signed real numbers
gives the start and end time of the range. If *start_time* is omitted,
the first record is used. *end_time* is omitted, the last record in the
file is used. The second form is equivalent to the first with *end_time
= start_time + time_incr .*

**-x** *debug_level*  
Only debug level 1 is defined in this version; this causes several
messages to be printed. The default level is zero, which causes no debug
output.

**-z**  
Suppresses messages that inform the user when any of the input filename,
the starting record, or number of records is taken from ESPS Common (see
ESPS COMMON).

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

The following items are read from the ESPS Common File provided that
only one input file or no input file is given on the command line and
provided that standard input isn't used.

> *filename - string*

> This is the name of the input file. If no input file is specified on
> the command line, *filename* is taken to be the input file. If an
> input file is specified on the command line, that input file name must
> match *filename* or the other items (below) are not read from Common.

> *start - integer*

> This is the starting point in the input file to begin copying. It is
> not read if the **-r** option is used.
>
> *nan - integer*

> This is the number of points to copy from the input file. It is not
> read if the **-r** option is used. A value of zero means the last
> point in the file.

Again, the values of *start* and *nan* are only used if the input file
on the command line is the same as *filename* in the common file, or if
no input file was given on the command line. If *start* and/or *nan* are
not given in the common file, or if the common file can't be opened for
reading, then *start* defaults to the beginning of the file and *nan*
defaults to the number of points in the file.

The following items are written into the ESPS Common file:

> *start - integer*

> The starting point from the input file.
>
> *nan - integer*

> The number of points in the selected range.
>
> *prog - string*

> This is the name of the program (*copysps* in this case).
>
> *filename - string*

> The name of the input file.

These items are not written to ESPS COMMON if the output file is
\<stdout\>.

# ESPS HEADER

If the output file is new (i.e. not appending to an existing file) then
the source ESPS header structure is copied into the new file header
(including generic header items). For exiting output files, the input
ESPS file name is added to the list of sources. The command line and
compatibility warnings, if any, are added in the comment field of the
header.

Also, if the output file is new and the generic header item
*record_freq* exists in the input file, the generic header item
*start_time* is written in the output file. The value written is
computed by taking the *start_time* value from the header of the input
file (or zero, if such a header item doesn't exist) and adding to it the
offset time (from the beginning of the input file) of the first record
processed. If *record_freq* doesn't exist in the input file,
*start_time* is not written in the output file. If it exists in the
input file header, the generic header item *record_freq* is copied to
the output file header. This item gives the number of records per second
of original data analyzed.

If the output file already exists and it is is being appended to,
*start_time* is not modified and the *record_freq* values in the two
files are checked for agreement. If they agree, no change is made to it;
If they don't agree, the *record_freq* value is changed to zero.

In update mode, the input and the output files must both be in EDR
(Entropic's external data representation) or the the machine's native
format.

# EXAMPLES

To copy records 1 to 5, 9, and 12 to 15 from *file1.sps* to *file2.sps*
(assuming *file2.sps* does not already exist), type the following:

        % copysps -r1:5,9,12:15 file1.sps file2.sps

Note that *file1.sps* and *file2.sps* can be any ESPS file. Only ESPS
FEA, FILT, SPEC, or SCBK files can be updated (i.e. have data appended
to them). Continuing our example above, if *file2.sps* is an ESPS FEA
file, then we can append records from *file3.sps* by typing:

        % copysps file3.sps file2.sps

If only *file2.sps* is given on the command line, as in the following
example:

        % copysps file2.sps

then *copysps* gets the input file name from ESPS Common.

# DIAGNOSTICS

A fatal error occurs if the input file does not exist, if it is not an
ESPS file, or if a requested range includes records that do not exist.

    copysps: no output file specified.
    Usage: copysps [-x debug] [-f] [-r gen_range] [-z] [infile] outfile
    copysps: infile and outfile cannot be the same.
    copysps: input file name infile taken from ESPS Common.
    copysps: fea_compat: feature fields in infile and outfile incompatible.
    copysps: cannot handle ESPS SCBK file type.
    copysps: cannot update ESPS file type code: type_code
    copysps: could not open outfile for appending.
    copysps: could not open temp_file
    copysps: could not open outfile for writing.
    copysps: only num_rec records in infile
    copysps: record sizes in infile and outfile are different.
    copysps: calloc: could not allocate memory for dbuf.
    copysps: read error on infile
    copysps: write error on temp_file
    copysps: seek error on infile
    copysps: write error on outfile
    copysps: could not rename temp_file to outfile

If the versions of the headers do not match when the **-f** flag is
used, a message is printed and the **-f** flag is turned off.

# SEE ALSO

    espsenv (1-ESPS), mergefea (1-ESPS), addfea (1-ESPS),
    copysd(1-ESPS), comment(1-ESPS), select(1-ESPS),
    grange_switch(3-ESPSu), fea(5-ESPS), fea_ana(5-ESPS),
    fea_stat(5-ESPS), fea_vq(5-ESPS), filt(5-ESPS), 
    scbk(5-ESPS), spec(5-ESPS)

# BUGS

Owing to the way that *grange_switch* is used, this might fail on very
large files.

When a new output file is created, it will always be the same data
format (either NATIVE or EDR) as the input. This is considered a bug and
will be changed in a future version. Note that you can use *select* to
copy the file and convert from NATIVE to EDR.

*Copysps* does not work correctly if the input and output files are not
both in field order or both in type order. For example, if the input
file is in type order (the default) and the environment variable
FIELD_ORDER is set to "on" before running *copysps*, the output file
will be garbage.

Compressed Sphere files are not supported. Files in Esignal format are
not supported.

# FUTURE CHANGES

Handle tagged and segment labeled FEA files properly.

Revise to handle MIIO properly.

# AUTHOR

Ajaipal S. Virdy, Entropic Speech, Inc.
