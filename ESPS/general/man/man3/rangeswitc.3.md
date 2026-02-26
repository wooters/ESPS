# NAME

    range_switch - parse an integer range argument
    lrange_switch - parse a long range argument
    frange_switch - parse a floating range argument
    grange_switch - parse a generic range argument
    fld_range_switch - parse a field name and generic subrange
    trange_switch - parse a time (in seconds) range argument

# SYNOPSIS


    #include <stdio.h>
    extern int debug_level;

    void
    range_switch (text, startp, endp, us)
    char *text;
    int *startp, *endp;
    int us;

    void
    lrange_switch (text, startp, endp, us)
    char *text;
    long *startp, *endp;
    int us;

    void
    frange_switch (text, startp, endp)
    char *text;
    double *startp, *endp;

    long *
    grange_switch (text, array_len)
    char *text;
    long *array_len;

    long *
    fld_range_switch(text, name, array_len, hd)
    char *text;
    char **name;
    long *array_len;
    struct header *hd;

    void
    trange_switch (text, hd, startp, endp)
    char *text;
    struct header *hd;
    long *startp, *endp;

# DESCRIPTION

These functions are used to parse range arguments.

For the functions *range_switch*, *lrange_switch*, *frange_switch*, and
*trange_switch*, the *text* argument may have any of the forms a:b,
a:+b, a:, :b, :, blank, or null. In the case of *range_switch* and
*lrange_switch*, a and b are integers. In the case of *frange_switch*
and *trange_switch*, a and b are floating point numbers. If the agument
*us* is nonzero (indicating unsigned ranges) in *range_switch* and
*lrange_switch*, then the minus sign is considered a field separator (it
can replace the colon) and only unsigned values are returned (thus we
can have a-b, a-, -b, or -).

The values of a and b specify the start and end of a desired range. The
functions *range_switch*, *lrange_switch*, and *frange_switch* return
these values. If If the start is specified (the input is in the form a:b
or a:), then the corresponding value is returned via *startp*. If the
end of the range is specified (the input is in the form a:b or :b) then
the corresponding value is returned via *endp*. For a null text
argument, or one containing invalid characters, neither endpoint is set.
In the case of *trange_switch*, a and b are interpreted as time offsets
into an ESPS file described by the header *hd*; the function obtains the
*start_time* and *record_freq* generics from *hd*, converts a and b into
record numbers, and returns them via *startp* and *endp*.

The form a:+b is equivalent to a:a+b for all functions.

*Grange_switch* is used to parse integer range arguments seperated by
commas. Each field in the *text* argument is seperated by a \`\`,'' and
may have any of the following forms, where a and b are integers:
\`\`a:b'', \`\`a:+b'', or \`\`a''. The minus sign is considered a field
separator (it can replace the colon) and only unsigned values are
returned (thus we can have a-b).

*Grange_switch* allocates memory for and returns a pointer to an array
containing the elements selected. The length of the array is returned in
*\*array_len*.

*Fld_range_switch* parses a range specification given in terms of a
feature-file field name and an optional bracketed generic subrange
specification. The argument *text* must point to the beginning of a
string, which may be of one of two forms:

*field_name*** \[ ***grange*** \] **  
*field_name*  

where *field_name* has the form of a field name (*i.e.* the same as a C
identifier) and *grange* is a general range specification acceptable to
the function *grange_switch*(3-ESPSu). Such strings are accepted on the
command line by various programs and also occur in the *srcfields*
arrays in feature-file headers and in the Ascii \`\`fieldfiles''
accepted by fea_deriv(1-ESPS).

The bracketed *grange,* if present, specifies a set of integers that
refer to positions within the named field, counting the first as
position zero. The returned value of the function and the value assigned
to *\*array_len* are the same as for the function *grange_switch()*
applied to the *grange* part of the *text* string. A copy of the
*field_name* part of the *text* string is assigned to the string
variable *\*name.*

The argument *hd* is ignored unless the bracketed *grange* specification
is omitted. In that case *hd* must point to a feature-file header
containing a definition of the named field, and all positions in the
field are implied.

# EXAMPLES

*lrange_switch* or *range_switch* may be used as follows:

        start = default_start;
        end = default_end;
        range_switch (text, &start, &end, us);
    or
        lrange_switch (text, &start, &end, us);

*Grange_switch* may be used as follows:

       char text[] = "1,3,5:+2,11";	   /* usually obtained from command line */
       long	array_len;
       long	*array;

       array = grange_switch (text, &array_len);

*array_len* will be set to 6 and on return, *array* will contain the
following elements:

    	array[0] = 1
    	array[1] = 3
    	array[2] = 5
    	array[3] = 6
    	array[4] = 7
    	array[5] = 11

*Fld_range_switch* may be used as follows.

       char text[] = "spec_param[3,5:7]";
       char *name;
       long array_len;
       long *array;

       array = fld_range_switch(text, &name, &array_len, (struct header *) NULL);

On return, *name* points to the beginning of a string containing
"spec_param", *array_len* is set to 4, and *array* contains the elements

    	array[0] = 3
    	array[1] = 5
    	array[2] = 6
    	array[3] = 7

Here is a second example for *fld_range_switch.*

       char text[] = "spec_param";
       char *name;
       long array_len;
       struct header *hd = read_header(input_file);
       long *array;

       array = fld_range_switch(text, &name, &array_len, hd);

Suppose *hd* points to a feature-file header in which *spec_param* is
defined as a field of size 10. Then on return *name* is as before,
*array_len* is set to 10, and *array* contains the integers 0 through 9
in order.

# SEE ALSO

get_deriv_vec(3-ESPSu), FEA(5-ESPS),

# DIAGNOSTICS

If the bracketed *grange* specification is omitted from the input string
and the named field is not defined in the header, *fld_range_switch*
returns (long \*) NULL and assigns 0 to \**array_len.* If
*fld_range_switch* cannot allocate memory, it prints a message and the
program exits. If *trange_switch* is passed a null ESPS header, a
warning is printed if *debug_level* is positive. In this case, or if the
*start_time* and *record_freq* generics are not present, values of 0 and
1 are used respectively.

# BUGS

None known.

# FUTURE CHANGES

Allow for negative values to be used in *grange_switch*.

# AUTHOR

Man page by Ajaipal S. Virdy. Fld_range_switch added by Rodney Johnson.
trange_switch by John Shore.
