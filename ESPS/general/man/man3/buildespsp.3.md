# NAME

    build_esps_path - builds a path to a file within the ESPS base directory

# SYNOPSIS

    #include <esps/esps.h>
    char *build_esps_path(char *path_inside_base)

# DESCRIPTION

Builds and returns a path by appending the ESPS base path provided by
*get_esps_base(3-ESPS)* and the argument *path_inside_base*. If
*path_inside_base* does not start with a / then one will be provided. A
newly allocated string is returned, so deallocate it after use.

You might think that *find_esps_file(3-ESPS)* would do this, and it
does. However, *find_esps_file(3-ESPS)* does not work with partial
filenames. Hence this routine.

# EXAMPLES


    build_esps_path("lib/tmac.an");
    build_esps_path("man/man");

# ERRORS AND DIAGNOSTICS

None known.

# FUTURE CHANGES

None known.

# BUGS

None known.

# REFERENCES

None.

# SEE ALSO

*find_esps_file* (3-ESPSu), *find_esps_file* (1-ESPS), *get_esps_base*
(1-ESPS), *get_esps_base* (3-ESPS)

# AUTHOR

Ken Nelson wrote the routine and the man page.
