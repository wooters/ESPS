# NAME

    w_decode - Decode the input file into the output format specified by "-o".

# SYNOPSIS

    w_decode [-vf] [ -oOUT ]  file_in file_out
    w_decode [-vi] [ -oOUT ]  file1 file2 . . . 

# DESCRIPTION

Decode the input file into the output format specified by "-o". The
output formats may be:

> ulaw

> pcm_01 \| short_01

> pcm_10 \| short_10

> pcm \| short_natural

If the file is already encoded as specified, no action is taken.

**w_decode** reads the header and sample data and performs conversions
on the output as necessary. The default operation is to decode the file
specified in "file_in" and place the contents into the file specified in
"file_out". If the filenames specified in "file_in" or "file_out" are
"-", then stdin and stdout are used respectively. In addition, an error
will be generated if "file_out" already exists.

The "-o" option specifies the output format. The qualifiers "\_10" and
"\_01" on the output types "short" and "pcm" stand for byte orders
MSB/LSB and LSB/MSB respectively. The output types "pcm" and
"short_natural" forces the byte order to be converted if necessary to
the local machine's natural byte order.

The "-f" option causes an existing "file_out" to be overwritten.

The "-i" option forces w_encode to replace the input file with it's
encoded version. When this "in place" option is used, the header is
modified to indicate the new encoding as well. This option also allows
more than one input file to be specified on the command line.

The "-v" option gives verbose output.

# EXAMPLES

**w_decode -o short_01 comp.wav uncomp.wav**  
uncompress a SPHERE headered file into *uncomp.wav*.

# SEE ALSO

w_encode(1)

# AUTHOR

Jon Fiscus (jon@jaguar.ncsl.nist.gov)
