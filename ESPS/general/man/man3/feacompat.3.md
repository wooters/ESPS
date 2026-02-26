# NAME

fea_compat - check compatibility of field definitions in FEA file
headers

# SYNOPSIS

    int fea_compat(ihd, ohd, fields, trans)
    struct header	*ihd, *ohd;
    char	**fields;
    short	***trans;

# DESCRIPTION

*fea_compat* checks field definitions in two ESPS feature-file (FEA)
headers for compatibility in the sense required for use of
*copy_fea_rec*(3-ESPS). *fea_compat* may also create a translation table
for *copy_fea_rec*(3-ESPS) to use in copying CODED data and add
necessary items to the *enums* arrays of CODED fields in *ohd.*

The arguments *ihd* and *ohd* should point to two ESPS header structures
of type FEA. It is assumed that information is to be copied from a
record described by *ihd* (the \`\`input header'') to a record described
by *ohd* (the \`\`output header'').

The argument *fields,* if not NULL, should point to the beginning of a
NULL-terminated list of strings that contains the names of the fields to
be checked. If *fields* is (*char* \*\*) NULL, all fields defined in
*ihd* are checked.

The argument *trans* must point to a variable of type (*short* \*\*) in
which the function stores an output value: either a pointer to the
beginning of a translation table or else the value (*short* \*\*) NULL,
indicating that no translation table is necessary.

The value returned by the function is an integer code that indicates the
\`\`level of compatibility.'' Three values are possible: -1, for
\`\`incompatibility''; 0, for \`\`minimal compatibility''; and 1, for
\`\`full compatibility.''

The returned value is -1 unless every field being checked (as determined
by *fields*) satisfies three conditions:

\(a\)  
The field must be defined in both headers.

\(b\)  
Both headers must define the field as having the same type.

\(c\)  
The size of the field as defined in *ohd* must be at least as great as
the size as defined in *ihd* (that is, the field in the output records
must be large enough to hold the data from the input records).

If every field checked satisfies (a), (b), and (c), the level of
compatibility is 0 unless the fields each also satisfy two more
conditions:

\(d\)  
Both headers must specify the same rank for the field.

\(e\)  
Both headers must specify the same dimensions (and therefore the same
size) for the field.

The function returns the value 2 if every field checked satisfies all
five conditions (a)-(e).

In copying a field of CODED type, *copy_fea_rec* requires a translation
table unless the encodings defined for the field in the two headers are
the same. The encodings are the same provided the *enums* arrays for the
field in both headers (see *FEA*(5-ESPS)) contain the same strings in
the same order; if the two *enums* arrays differ, the encodings differ,
since the code for a string is its position in the *enums* array. If
*fea_compat* finds that any field being checked is CODED and has
different encodings defined in the two headers, it creates a translation
table and stores a pointer to the beginning of the table in the location
\**trans.* The table is an array of pointers, one for each field named
in *fields* (or one for each field defined in *ihd,* if *fields* is
NULL). The elements of the array corresponding to non-CODED fields are
NULL. For each CODED field, the array element is a pointer to the
beginning of an array of shorts that is used in translating data in the
field. See *copy_fea_rec*(3-ESPS) for additional information.

If, for some CODED field, the *enums* array in the input header contains
strings that are not in the *enums* array in the output header, the
missing strings must be added to the array in the output header before
the field can be copied. In addition to providing the translation table,
*fea_compat* will make the necessary additions to the *enums* array in
*ohd* for any field that is checked. New items are added at the end of
the array, and the positions of existing items are not changed.

# EXAMPLE

Appending one FEA file to another.

Given the inclusions

> 
>     #include <stdio.h>
>     #include <esps/esps.h>
>     #include <esps/fea.h>

and the declarations

> 
>     struct header	*hd1, *hd2;
>     struct fea_data	*rec1, *rec2;
>     FILE		*file1, *file2;
>     short		**table;

the following code checks files *file_one.fea* and *file_two.fea* for
compatibility. If the check succeeds, it copies *file_one.fea* to
*stdout,* followed by records containing the same information as the
records of *file_two.fea* but in the format of *file_one.fea.* The
program fails and exits if the format of *file_one.fea* will not
accommodate all the information in *file_two.fea.* If *file_two.fea* has
fields that are not defined in *file_one.fea,* their contents in the
appended output records are undefined.

> 
>     eopen("ProgName", "file_one.fea", "r", FT_FEA, NONE, &hd1, &file1);
>     eopen("ProgName", "file_two.fea", "r", FT_FEA, NONE, &hd2, &file2);
>     rec1 = allo_fea_rec(hd1);
>     rec2 = allo_fea_rec(hd2);
>
>     /* Check compatibility */
>
>     switch(fea_compat(hd2, hd1, (char **) NULL, &table))
>     {
>     case -1:
>         fprintf(stderr, "Failure: incompatible files.\n");
>         exit(1);
>         break;
>     case 0:
>         fprintf(stderr, "Warning: minimally compatible files.\n");
>         break;
>     case 1:
>         break;
>     }
>
>     /* Copy file_one.fea */
>
>         /* Should add history-keeping information to hd1. */
>     write_header(hd1, stdout);
>     while (get_fea_rec(rec1, hd1, file1) != EOF)
>         put_fea_rec(rec1, hd1, stdout);
>
>     /* Append file_two.fea */
>
>     while (get_fea_rec(rec2, hd2, file2) != EOF)
>     {
>         copy_fea_rec(rec2, hd2, rec1, hd1, (char **) NULL, table);
>         put_fea_rec(rec1, hd1, stdout);
>     }

# DIAGNOSTICS

If *ihd* or *ohd* does not point to a FEA header, a message is printed
on *stderr,* and the program exits with status 1.

# BUGS

None known.

# WARNINGS

This function may alter the header that the argument *ohd* points to.

# SEE ALSO

copy_fea_rec(3-ESPSu), FEA(5-ESPS), ESPS(5-ESPS)

# AUTHOR

Rodney Johnson
