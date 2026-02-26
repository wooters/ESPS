# NAME

read_header - read in an ESPS file header

# SYNOPSIS

struct header \*\
read_header (fd)\
FILE \*fd;

# DESCRIPTION

*read_header* allocates memory for an ESPS file header, reads in the
header from the stream *fp* and returns a pointer to it. The file stream
pointer, *fd*, is left pointing to the first data record.

If the file does not begin with an ESPS header, then *read_header*
checks to see if the file begins with a Sphere header (as used on the
NIST CD-ROM database). If the file is a Sphere file, then the Sphere
header is processed and an ESPS FEA_SD header is created with the
appropriate values filled in. The function returns a pointer to this new
ESPS header. ESPS Esignal files \[1\] are handled in the same way, as
are files in certain RIFF WAVE (\`\`PC .wav'') formats \[2\]:
*read_header* checks for the presence of an Esignal or WAVE header and,
if it finds one, converts it as nearly as possible to an equivalent FEA
header. (In the case of the WAVE format, only 16-bit PCM files are
supported, though multi-channel files are allowed.) The constructed FEA
header contains a special generic header item that enables the ESPS data
input functions (such as *get_fea_rec*(3-ESPS) and
*get_feasd_recs*(3-ESPS)) to give special treatment to the data if
necessary. In this way an ESPS program can read Sphere files or ESPS
files, without any prior knowledge of the file type.

If the file does not begin with either an ESPS header or a Sphere,
Esignal, or WAVE header, then the Unix environment variable
**DEF_HEADER** is checked. If this variable is defined, it is assumed to
be the filename of a default ESPS header to apply to the file. The
header named by **DEF_HEADER** is processed and then is returned by
*read_header* in the usual way. The file stream pointer is left pointing
to the first data record.

An ESPS header can be followed by a *foreign header*, which is an
arbitrary block of data of known size between the ESPS header and the
data records. This is usually a non-ESPS file header that was on a file
converted to ESPS by *addfeahd*(1-ESPS) or *btosps*(1-ESPS) with the
**-F** option. If, after the ESPS header has been processed, it is found
to contain the generic header items *foreign_hd_length* and
*foreign_hd_ptr*, and *foreign_hd_length* is greater than zero,
*read_header* will read an additional *foreign_hd_length* bytes into a
block of newly allocated memory. The header item *foreign_hd_ptr* will
be set to point to this block of memory containing the foreign header.
(The generic item *foreign_hd_length* is a long, so it must be cast to
(char \*) before use.) As in the other cases, the file stream pointer
*fd* will be left pointing to the first data record after the foreign
header.

Note that if a default header, picked up by the **DEF_HEADER**
environment variable mechanism contains *foreign_hd_length* and it is
greater than zero, then that many bytes will be skipped at the beginning
of the raw file and saved into the foreign header. In this way, one can
have a default header for non-ESPS files and also specify a foreign
header size for any ESPS programs. Note that *foreign_hd_length* can be
set with the program *addgen*(1-ESPS).

*read_header* returns NULL if an I/O error occurs, or if any of the
above processing fails to yield a valid ESPS header.

# EXAMPLE

in_fd = fopen (inputfile, "r");\
if ((in_hd = read_header (in_fd)) == NULL) *error...*\
in_hd-\>common.type /\* is equal to type of header \*/

# DIAGNOSTICS

There are a number of error messages might be output to stderr if parts
of the header are bad.

# BUGS

None known.

# REFERENCES

\[1\] \`\`The Esignal File Format'', Entropic Research Laboratory, Inc.,
1995.\
\[2\] \`\`Multimedia Programming Interface and Data Specifications
1.0'', IBM Corporation and Microsoft Corporation, 1991.

# SEE ALSO

*new_header*(3-ESPSu), *write_header*(3-ESPSu),\
*copy_header*(3-ESPSu), *get_fea_rec*(3-ESPS),\
*get_feasd_recs*(3-ESPS).

# AUTHOR

Original version by Joe Buck.\
Modified by Alan Parker for new header structures.
