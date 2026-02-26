# NAME

    e_temp_name - make a unique ESPS file name

    e_temp_file - create and open a unique ESPS file

# SYNOPSIS

    #include <stdio.h>

    extern int debug_level;

    char *
    e_temp_name(template)
    char	*template;

    FILE *
    e_temp_file(template, new_file)
    char	*template;
    char    **new_file;

# DESCRIPTION

*e_temp_name* creates a unique file name, typically in a temporary
filesystem. If *template* is not NULL, its contents are used in forming
the new file name as described below. In all cases, the address of the
new file name is returned by *e_temp_name*.

If *template* is NULL, the default string "espsXXXXXX" is used. If
*template* is not NULL, the string in *template* should contain six
trailing Xs; in either case, *mktemp*(3) is used to replace the Xs in a
copy of *template* with a letter followed by the current process ID.

The file name returned by *e_temp_name* depends on whether *template*
contains a path specification - i.e., on whether *template* contains one
or more instances of the character '/'. If *template* does contain a
path specification, *e_temp_name* returns the result of applying
*mktemp* to a copy of *template*. In this way, *e_temp_name* can be used
to generate a unique file name in a directory specified as part of the
call. (This is not the recommended approach.)

If *template* does not contain a path specification, then *e_temp_name*
returns a string containing the contents of the *unix* environment
variable ESPS_TEMP_PATH, followed by '/', followed by the result of
applying *mktemp* to a copy of *template*. This provides global control
over the location of temporary files. If ESPS_TEMP_PATH is not defined,
then a compiled in default is used (usually "/usr/tmp").

Unlike *mktemp*(3), *e_temp_name* does not change the contents of
*template*. Thus repeated calls to *e_temp_name* can be made using the
same *template*. *e_temp_name* uses *malloc*(3) to allocate space for
the constructed file name and returns a pointer to this area. Thus, any
pointer returned by *e_temp_name* can be serve as an argument to
*free*(3).

e_temp_name will return NULL if it cannot construct a file name
(*malloc* fails), or if the constructed file name is not a writable
file.

*e_temp_file* creates a new file name using *e_temp_name*, opens the
file for update, and returns the corresponding file pointer. The
argument *template* is passed to *e_temp_name*, which interprets it as
described above. *e_temp_file* will return NULL if the call to
*e_temp_file* fails or if it is unable to open the resulting file name
for updating. *e_temp_file* sets \**new_file* to the address of the file
name constructed by the call to *e_temp_name*. This makes it possible
for the the user to remove the temporary file (e.g., with *unlink*(3))
after it is no longer needed, as well as to free the space used for the
file name.

Normally, ESPS programs should call *e_temp_name* or *e_temp_file* with
a *template* that does not contain a path specification. This is to
allow global control of temporary file location by means of the
environment variable ESPS_TEMP_PATH.

# EXAMPLES

    	char *name;
    	char *tmp_name;
    	FILE *tmp_strm;

    	/* use defaults - if ESPS_TEMP_PATH is not defined, 
    	 * will generate as /usr/tmp/espsXXXXXX; otherwise, 
    	 * will generate as ESPS_TEMP_PATH/espsXXXXXX. */

    	name = e_temp_name(NULL); 

    	/* If ESPS_TEMP_PATH is not defined, 
    	 * will generate as /usr/tmp/PLTXXXXXX; otherwise, 
    	 * will generate as ESPS_TEMP_PATH/PLTXXXXXX. */

    	name = e_temp_name("PLTXXXXXX"); 

    	/* Force generation as /h1/shore/tmp/PLTXXXXXX;
             * considered bad practice */

    	name = e_temp_name("/h1/shore/tmp/PLTXXXXXX"); 
    	     
    	/* open temporary file */

    	tmp_strm = e_temp_file("PLTXXXXXX", &tmp_name);

    	 . . . 

    	(void) fclose(tmp_strm);
    	(void) unlink(tmp_name); 

# ERRORS AND DIAGNOSTICS

If *debug_level* is non-zero, an error message will be printed to stderr
in the following cases: *e_make_name* cannot allocate sufficient space
to construct the file name, *e_make_name* constructs a file name that is
not writable, or *e_make_file* cannot open the file for update.

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

*mktemp*(3), *tmpfile*(3), *fopen*(3S)

# AUTHOR

Manual page and programs by John Shore.
