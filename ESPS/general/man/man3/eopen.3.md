# NAME

eopen - open ESPS file, read header, and check type

# SYNOPSIS

    #include <esps/header.h>
    #include <esps/ftypes.h>
    #include <esps/fea.h>
    #include <stdio.h>

    char *
    eopen(prog_name, file_name, mode, type, subtype, header, stream)
    char	*prog_name, *file_name, *mode;
    int	type, subtype;
    struct header	**header;
    FILE	**stream;

    eopen2(prog_name, file_name, mode, type, subtype, header, stream)
    char	*prog_name, *file_name, *mode;
    int	type, subtype;
    struct header	**header;
    FILE	**stream;

# DESCRIPTION

The following are input parameters:

*prog_name*  
the name of the calling program or other string to be put at the
beginning of error messages.

*file_name*  
the name of the file to be opened or "-" for standard input or output.

*mode*  
the string "r" for *read,* "w" for *write,* or any other string
acceptable as the second argument of *fopen*(3S).

*type*  
one of the file-type codes, such as FT_SD and FT_SPEC, defined in
*\<esps/ftypes.h\>,* or NONE.

*subtype*  
one of the feature-file subtype codes, such as *FEA_ANA*(5-ESPS) and
*FEA_STAT*(5-ESPS), defined in *\<esps/fea.h\>,* or NONE; ignored unless
*type* is FT_FEA.

The following are output parameters.

*header*  
points to a variable in which a pointer to the file header is stored.

*stream*  
points to a variable in which a file pointer for the opened file is
stored.

The function value returned by *eopen* is ordinarily just *file_name;*
but if *file_name* is "-", the returned value is "\<stdin\>" or
"\<stdout\>".

If the first letter of *mode* is 'r', *eopen* opens the file for
reading. The function is most useful in that case, as it takes care of
reading the header and checking the ESPS file type. However, *eopen* can
also open a file for writing or appending, and that simpler case is
described first.

If *mode* begins with any letter but 'r', and *file_name* is "-",
*eopen* just assigns the value *stdout* to \**stream* and returns the
string "\<stdout\>".

If *mode* begins with a letter other than 'r', and *file_name* is an
ordinary file name, *eopen* attempts to open the file by executing
*fopen*(*file_name*, *mode*). Upon success, it assigns the resulting
value to \**stream* and returns *file_name;* upon failure, *eopen* exits
with an error message.

If *mode* begins with 'r', and *file_name* is "-", *eopen* assigns the
value *stdin* to \**stream* and attempts to read the header and (if
required) check the file type, as described below. Upon successful
completion, *eopen* returns the string "\<stdin\>".

If *mode* begins with 'r', and *file_name* is an ordinary file name,
*eopen* attempts to open the file by executing *fopen*(*file_name*,
*mode*). Upon failure, the program exits with an error message; upon
success, *eopen* assigns the resulting value to \**stream* and attempts
to read the header and (if required) check the file type, as described
below. Upon successful completion, *eopen* returns *file-name.*

*Eopen* uses *read_header*(3-ESPS) to attempt to read the file header.
If it fails, the program exits with a message; otherwise *eopen* assigns
the resulting value of *read_header* to \**header.*

Then, if *type* is NONE, type checking is skipped, and *eopen* returns.
Otherwise, if *common.type* in the header has a different value from
*type,* the program exits with a message, except for the case where
*common.type* == FT_SD, *type* == FT_FEA, and *subtype* == FEA_SD. If
the type is correct and is not FT_FEA, there is no further checking to
be done, and *eopen* returns. Also, if *subtype* is NONE, further
checking is skipped. However, if *type* is FT_FEA and *subtype* is not
NONE, the value of *hd.fea*-\>*fea_type* is checked; if the value of
*subtype* is different, the program exits with a message. Otherwise
*eopen* returns.

If the file to be opened is an old format SD file (FT_SD), and *eopen*
is called with *type* == FT_FEA and *subtype* == FEA_SD, then the SD
header is converted to a FEA_SD header and returned. This is to allow a
program designed to handle FEA_SD files to read old SD files also.

The alternate function *eopen2* is identical to *eopen* except that
*eopen2* does not exit after detecting a problem. Instead, after
detecting a problem, it sets \*header to NULL, outputs an error message,
and returns the appropriate file name (*file_name*, "\<stdout\>", or
"\<stdin\>"). It is the responsibility of the caller to check the
*header* after *eopen2* returns.

# EXAMPLE

A program that reads a sampled-data file and a statistics feature file
and writes one output file might contain the following code. Assume that
at this point in the program the value of the variable *optind* is one
greater than the index of the last optional argument in the program's
argument vector.

    if (optind < argc)
        input_sd = eopen(ProgName, argv[optind++], "r", FT_FEA, FEA_SD,
    		&sd_ihd, &inputsd_strm);
    else
    {
        Fprintf(stderr, "%s: no input SD file specified.\n", ProgName);
        SYNTAX;
    }

    if (optind < argc)
        input_stat = eopen(ProgName, argv[optind++], "r", FT_FEA, FEA_STAT,
    		&stat_ihd, &inputstat_strm);
    else
    {
        Fprintf(stderr, "%s: no input FEA_STAT file specified.\n", ProgName);
        SYNTAX;
    }

    if (inputsd_strm == stdin && inputstat_strm == stdin)
    {
        Fprintf(stderr, "%s: input files can't both be <stdin>.\n", ProgName);
        exit(1);
    }

    if (optind < argc)
        out_fea = eopen(ProgName, argv[optind++], "w", NONE, NONE,
    		(struct header **) NULL, &outfea_strm);
    else
    {
        Fprintf(stderr, "%s: no output file specified.\n", ProgName);
        SYNTAX;
    }

    if (optind < argc)
    {
        Fprintf(stderr, "%s: too many files specified.\n", ProgName);
        SYNTAX;
    }

# DIAGNOSTICS

The invocation of *read_header*(3-ESPSu) may produce various diagnostic
messages. The following are generated directly by *eopen.*


    prog_name: can't open file_name: reason
    prog_name: filename is not an ESPS file
    prog_name: filename is not an ESPS filetype file

# WARNING

To prevent *stream* from becoming *stdin* or *stdout,* the program
should either check that *strcmp*(*file_name,* "-") != 0 before *eopen*
is called or check that *stream* != *stdin* or *stream* != *stdout*
after *eopen* is called.

# BUGS

None known.

# SEE ALSO

fopen(3S), read_header(3-ESPSu), ESPS(5-ESPS), FEA(5-ESPS)

# AUTHOR

Rodney Johnson
