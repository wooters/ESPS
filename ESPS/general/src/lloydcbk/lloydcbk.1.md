# NAME

lloydcbk - design a scalar quantization codebook by using lloyd's
algorithm

# SYNOPSIS

**lloydcbk** \[ **-x** *debug_level* \] \[ **-P** *params_file* \] \[
**-n** *codebook_size* \] \[ **-c** *convergence* \] \[ **-h** *history*
\] \[ **-o** *description* \] \[ **-s** *source_file* \] \[ **-d**
*distortion* \] \[ **-t** *codebook_type* \] \[ **-e** *element* \] \[
**-S** *source_list* \] *infile* *outfile*

# DESCRIPTION

*Lloydcbk* designs a scalar quantization codebook ( *outfile* ) from
training data that is in an ascii file ( *infile.* ) *Infile* must
contain only one floating number per line. The distortion measure (
*distortion* ), the convergence threshold ( *convergence* ), the
identity of the codebook ( *codebook_type* ), a description of the
origin of the codebook ( *description* ), and the number of codewords in
the codebook ( *codebook_size* ) must be specified. A summary of the
design process can be saved by specifying a *history* file name, the
source(s) of the data can be saved by using *source_file* or
*source_list,* and a particular element value can be identified by using
the *element* flag.

If *infile* is replaced by "-", standard input is read and used as
training data by *lloydcbk* to design a codebook. Similarly, if
*outfile* is replaced by "-", the codebook is written to standard
output.

Note that **-h, -o, -s, -t, -e** and **-S** are for recording keeping
purposes only; they do not affect the design of the codebook.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

*cbk_size* (an integer), *convergence* (a float), and *distortion* (a
string) may be specified in a *params* file. If any of these are
specified on the command line, the command line value over rides the
*params* file value.

# ESPS COMMON

The common file is not accessed.

# ESPS HEADER

The header from each of the source files is stored in the SCBK header.

The following values are written to the header of the SCBK file:
*common.prog, common.vers, common.progdate,* *hd.scbk-\>convergence,
hd.scbk-\>num_cdwds, hd.scbk-\>num_items,* *hd.scbk-\>codebook_type,
hd.scbk-\>element_num,* and *hd.scbk-\>distortion.*

# OPTIONS

The following options are supported:

**-x** *debug_level*  
*debug_levels* greater than 0 cause messages to be printed. The higher
the *debug_level* the greater the detail of the debug information. The
default level is zero, which causes no debug output.

**-P** *params_file*  
Use the ESPS parameter file *params_file* rather than the default
parameter file, which is *params.*

**-n** *codebook_size*  
Specifies the number of codewords in the codebook. It must be a positive
number.

**-c** *convergence*  
Convergence threshold (floating value) to use at each level of
clustering. When {1 - \[(new total distortion)/(old total distortion)\]}
is less than *convergence,* the clustering stops. If the current number
of codewords is equal to *codebook_size,* *lloydcbk* is done, otherwise
*lloydcbk* splits the current codewords and starts a new improvement
loop. Reasonable convergence values are data dependent, but .001 is
often reasonable.

**-h** *history*  
If a file name is specified, *lloydcbk* writes to it information about
each iteration of clustering.

**-o** *description*  
A description of the method used to generate the training data is
written here and stored in the TYP_TEXT field of the output file header.
If the **-o** option is not specified, *lloydcbk* prompts the user for a
description. The maximum length of this string is 32768 characters. (Not
supported yet)

**-s** *source*  
The name of the ESPS file from which the training data was derived.
Multiple sources may be specified by specifying them individually with
separate **-s** flags. The header of each source file is added to the
codebook file's header. (Not supported yet)

**-d** *distortion*  
The distortion measure used in the clustering. Currently, only
SQUARED_ERROR is supported.

**-t** *codebook_type*  
The name of the parameter, such as reflection coefficient, pulse power,
etc., that the codebook represents. Legal values are defined in
\<esps/header.h\>, and they include RC_VCD_CBK= voiced reflection
coefficients, RC_UNVCD_CBK = unvoiced reflection coefficients, RC_CBK =
reflection coefficients, PP_CBK = pulse powers, PD_CBK = pulse
durations, FL_CBK = frame lengths, EP_CBK = lpc error powers, PPR_CBK =
pulse power ratios, PPD_CBK = pulse power differences, PDD_CBK = pulse
duration differences, LAR_UNVCD_CBK = unvoiced log area ratios,
LAR_VCD_CBK = voiced log area ratios, and LAR_CBK = log area ratios.

**-e** *element*  
The element of the *codebook_type* that is being processed. Legal values
are integers greater than or equal to zero, and two negative values that
have special meaning. -1 means all elements of the specified
*codebook_type* are used, and -2 means that no record of element value
is being kept. For *codebook_type's* that imply two adjacent elements,
such as PPR, the element value is the first of the two adjacent
elements.

**-S** *source_list*  
An ascii file that lists all the sources of the input data may be
specified. This file contains one source file per line. *Lloydcbk* opens
this file, reads each source name, opens that file, and copies the
header into the output SCBK file. (Not supported yet)

# DIAGNOSTICS

A fatal error occurs if the specified source file does not exist, or if
it is not an ESPS file.

# EXPECTED CHANGES

Additional distortion measures will be added.

# SEE ALSO

lloyd(3-ESPS)

# BUGS

The **-o, -s,** and **-S** options are not yet supported.

# REFERENCES

Y. Linde, A. Buzo, R.M. Gray, An Algorithm for Vector Quantizer Design
IEEE Transactions on Communications, Vol. COM-28, No. 1, January, 1980

# AUTHOR

Manual page and code by David K. Burton
