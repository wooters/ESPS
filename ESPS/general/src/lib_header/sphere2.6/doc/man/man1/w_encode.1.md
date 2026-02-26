# NAME

    w_encode - Encode the input file into the output format specified by "-o".

# SYNOPSIS

    w_encode [-mvf] [ -t ENC ] file_in file_out
    w_encode [-mvi] [ -t ENC ] file1 file2 . . .

# DESCRIPTION

Compress/Encode the file as the type defined by the "-t" option. The
output compression/encodings may be:

> wavpack \| shorten \| ulaw

The program will use the header information to optimize the compression
scheme. The default operation is to encode the file specified in
"file_in" and place the contents into the file specified in "file_out".
If the filenames specified in "file_in" or "file_out" are "-", then
stdin and stdout are used respectively. In addition, an error will be
generated if "file_out" already exists. The "-f" option causes an
existing "file_out" to be overwritten.

The waveform I/O routines automatically convert the byte order of a file
to the host machine's natural format. The "-m" option forces the
encoding to maintain the original byte order of "file_in".

The "-i" option forces w_encode to replace the input file with it's
encoded version. When this "in place" option is used, the header is
modified to indicate the new encoding as well. This option also allows
more than one input file to be specified on the command line.

The "-v" option gives verbose output.

# EXAMPLES

**w_encode -o wavpack uncomp.wav comp.wav**  
compress a SPHERE headered file into *comp.wav*.

# SEE ALSO

w_decode(1)

# AUTHOR

Jon Fiscus (jon@jaguar.ncsl.nist.gov)
