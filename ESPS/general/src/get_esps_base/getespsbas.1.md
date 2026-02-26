# NAME

    get_esps_base - returns the name of the esps base directory. 

# SYNOPSIS

get_esps_base

# DESCRIPTION

Returns the name of the top of the ESPS base directory. No arguments.
The value returned is either the value of environment variable
**ESPS_BASE** or **/usr/esps** if the environment variable is empty.

The ESPS base directory is the top of the ESPS release tree. Examples of
the useful directories found here are *lib* , *bin*, *man* , and *demo*.

# EXAMPLES

\
if \[ -r \`get_esps_base\`/scripts/runesps \]; then\
\`get_esps_base\`/scripts/runesps\
fi\

# ERRORS AND DIAGNOSTICS

None known.

# FUTURE CHANGES

None known.

# BUGS

None known.

# REFERENCES

None.

# SEE ALSO

*find_esps_file*(3-ESPSu), *get_esps_base*(3-ESPSu),
*find_esps_file*(1-ESPS)

# AUTHOR

Ken Nelson wrote the routine and the man page.
