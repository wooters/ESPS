# NAME

    build_filename - expands environment variables into path name

# SYNOPSIS

    #include <esps/esps.h>

    char *build_filename(into_string,filename,dirname)
    char *into_string;
    char *filename;
    char *dirname;

# DESCRIPTION

Function *build_filename* builds a complete path to a filename. The
first argument, *into_string*, is a string that holds the resulting full
path. It should be large enough to hold the largest path your system
supports. This argument is also returned as the function result. NULL is
not a valid argument.

The second argument, *filename*, contains the basename of the file path.
Environment variables are not expanded in this component, so do not use
them. (See Future Changes.)

The third, argument, *dirname*, holds the directory name that is to be
expanded and concatenated with *filename* to form the full path.
Environment variables will be expanded. You do not need to place a / at
the end of *dirname*; it will be provided.

# EXAMPLES


     build_filename(expandedFilename,"","/usr/bin/$ARCH");

# ERRORS AND DIAGNOSTICS

None.

# FUTURE CHANGES

Add environment variable expansion to the basename (filename) argument.

# BUGS

None known.

# REFERENCES

# SEE ALSO

    find_esps_file(3-ESPS), build_esps_path(3-ESPS), get_esps_base(3-ESPS)

# AUTHOR

Ken Nelson wrote the routine and the man page.
