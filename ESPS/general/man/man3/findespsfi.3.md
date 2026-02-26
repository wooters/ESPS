# NAME

find_esps_file - finds full path to an ESPS or waves+ file.

# SYNOPSIS

    #include <esps/esps.h>

    char *find_esps_file(fullpath,filename,defpath,env_var_name)
    char* fullpath;
    char* filename; 
    char *defpath;
    char *env_var_name

# DESCRIPTION

Looks along a path for *filename*. If the file is found and is readable
then return the the string containing the full Unix path to the file. If
the file is not found NULL is returned.

Environment variables may also be used in the requested file. Variable
**ESPS_BASE** is treated specially (see below). An example of this would
be:


       find_esps_file(fullpath,"bin/$ARCH/xwaves",defpath,env_var_name);

The parameter *filename* should the basename of the file to be
discovered. If *filename* already specifies a full path (begins with /
or ./), then that path is returned (if it points to a readable file).
The parameter *fullpath* should be a string large enough to hold the
longest path on your system, or NULL in which case a new string will be
allocated and returned containing the file path. You should deallocate
the string when you do not need it anymore. Parameter *filename*
(provided or a newly allocated) is returned.

The first two paramaters may be the same string. However, remember that
it is **VERY** important that the string be large enough to hold the
resulting path.

Parameter *defpath* specifies the default search path. The syntax of the
search path (just like Unix) is given below.

The default search path can be overridden by the environment variable
specified in **env_var_name**. If the environment variable specified by
**env_var_name** is not set, or cannot be parsed then the default file
path (as specified by *defpath* ) is used.

The syntax of the search path is a colon separated list of directories;
just like the normal Unix path. An example path is:


       $ESPS_BASE/bin:/usr/local/bin/$ARCH:/usr/esps/demo:$HOME/esps/bin

Environment variables may be used in the path by prefixing them with a
\$ sign. The value of environment variable **ESPS_BASE** is retrieved by
calling *get_esps_base*(3-ESPSu) . If the environment variable is not
set then it is replaced in the path with nothing.

# EXAMPLES


    /* provide string  */

    char datafile[255];
    (void) find_esps_file(datafile,"speech.sd","/usr/esps/bin:/usr/esps/demo","ESPS_PATH"); 

    /* allocate new string */

    char *datafile;
    datafile  = find_esps_file(NULL,"speech.sd","/usr/esps/bin:/usr/esps/demo","ESPS_PATH"); 

# CONVIENENCE MACROS

Several macros are provided in include file
\$ESPS_BASE/include/esps/epaths.h. They provide standard environment
variables to specify paths and standard default paths if the standard
environment variable is not set.

Parameter *a* is the string to fill the path in (or NULL) (corresponds
find_esps_file(3) parameter *fullpath*). Paramater *b* is the file
desired (corresponds to *find_esps_file*(3) parameter **filename***).*

FIND_ESPS_MENU(a,b) - find ESPS menu files.

FIND_ESPS_BIN(a,b) - find ESPS executable files.

IFIND_ESPS_PARAM_FILE(a,b) - find ESPS paramater files.

FIND_ESPS_FILTER(a,b) - find ESPS filter files.

FIND_ESPS_LIB(a,b) - search for files in the ESPS library.

FIND_ESPS_INPUT(a,b) - search for ESPS input files.

FIND_WAVES_INPUT(a,b) - search for waves+ input files.

FIND_WAVES_LIB(a,b) - search for files in the waves+ library directory.

FIND_WAVES_COMMAND(a,b) - find waves+ command files.

FIND_WAVES_MENU(a,b) - find waves+ menu files.

FIND_WAVES_COLORMAP(a,b) - find waves+ colormaps.

FIND_WAVES_PROFILE(a,b) - find a waves profile .

FIND_FAB2_BIN(a,b) - find FAB2 board binaries.

FIND_SURF_BIN(a,b) - find Surf board binaries.

# ERRORS AND DIAGNOSTICS

None. Always returns something unless too small a string is provided
which could cause problems if other memory addresses are overwritten.

# FUTURE CHANGES

Make environment variable handling match the way the shell handles them.
Things like \${foobar}, etc... .

# BUGS

If the user provided string is too small then who knows what will
happen.

# REFERENCES

None.

# SEE ALSO

    get_esps_base(3-ESPSu), get_esps_base(1-ESPS), 
    find_esps_file(1-ESPS), build_filename(3-ESPS)

# AUTHOR

Ken Nelson wrote the routine and the man page.
