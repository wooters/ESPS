# NAME

    get_esps_base - returns a string pointing to esps base directory. 

# SYNOPSIS

    #include <esps/esps.h>
    char *get_esps_base(char *base_name)

# DESCRIPTION

Returns a string (char \*) containing the path to the ESPS base
directory. Uses the environment variable ESPS_BASE if it exists, else
uses the default "/usr/esps". The path is placed in the string parameter
*base_name* which is also returned from the function. The argument
provided as *base_name* should be large enough to hold the maximum path
length of the Unix you are running. If *base_path* is NULL then a newly
allocated string containing the ESPS base path is returned. You should
deallocate the string when you are done with it.

The ESPS base directory is the top of the ESPS release tree. Examples of
the useful directories found here are *lib*, *bin*, *man*, and *demo*.

# EXAMPLES

char espsbase\[255\];\
(void) get_esps_base(espsbase); /\* string is provided \*/

char \*espsbase;\
espsbase = get_esps_base(NULL); /\* allocates new string \*/

# ERRORS AND DIAGNOSTICS

None. Always returns something unless too small a string is provided
which could cause problems if other memory addresses are overwritten.

# FUTURE CHANGES

None known.

# BUGS

If the user provided string is too small then who knows what will
happen.

# REFERENCES

None.

# SEE ALSO

    find_esps_file(3-ESPSu), build_filename(3-ESPSu), 
    get_esps_base(1-ESPS), find_esps_file(1-ESPS)

# AUTHOR

Ken Nelson wrote the routine and the man page.
