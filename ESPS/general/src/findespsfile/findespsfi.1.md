# NAME

find_esps_file - finds full path to an ESPS or waves+ file.

# SYNOPSIS

find_esps_file filename defpath \[environment_variable_name\]

# DESCRIPTION

Looks along a path for **filename**. If the file is found and is
readable then place the the full Unix path to the file on the standard
output with exit status 0. If the file is not found then exit with
status 1.

The parameter **filename** should the basename of the file to be
discovered. If **filename** already specifies a full path (begins with /
or ./), then that path is returned.

Parameter **defpath** specifies the default search path . The syntax of
the search path (just like Unix) is given below.

The default search path can be overridden by the environment variable
specified in **env_var_name**. If the environment variable specified by
**env_var_name** is not set, or cannot be parsed then the default file
path (as specified by **defpath**) is used.

The syntax of the search path is a colon separated list of directories;
just like the normal Unix path. An example path is:


       $ESPS_BASE/bin:/usr/local/bin/$ARCH:/usr/esps/demo:$HOME/esps/bin

Environment variables may be used in the path by prefixing them with a
\$ sign. The value of environment variable **ESPS_BASE** is retrieved by
calling **get_esps_base**(3-ESPSu). If the environment variable is not
set then it is replaced in the path with nothing.

# EXAMPLES

    # Find waves along the path specified in ESPS_BASE, note that an empty
    # default path was given. The environment variable is an optional
    # parameter.
    #

    pathtowaves=`find_esps_file xwaves "" ESPS_BASE`

# ERRORS AND DIAGNOSTICS

Exit status of 0 means it found something, exit status of 1 means the
requested file was not found.

# FUTURE CHANGES

None known.

# BUGS

None known.

# REFERENCES

None.

# SEE ALSO

    get_esps_base(3-ESPSu), find_esps_file(3-ESPSu), 
    get_esps_base(1-ESPS), 

# AUTHOR

Ken Nelson wrote the routine and the man page.
