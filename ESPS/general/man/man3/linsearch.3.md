# NAME

    lin_search - case-insensitive search on a NULL-terminated array of strings
    lin_search2 - case-sensitive search on a NULL-terminated array of strings

# SYNOPSIS

int\
lin_search(array, text)\
char \*text, \*array\[\];

\
int\
lin_search2(array, text)\
char \*text, \*array\[\];

# DESCRIPTION

*lin_search* and *lin_search2* search *array,* which is assumed to be a
NULL-terminated array of character pointers. The functions return the
index of the string in *array* that matches the string *text.* If there
is no match, -1 is returned. *lin_search* ignores the case of letters in
*text,* but the strings in *array* must all be upper-case. *lin_search2*
requires the string in *array* to match *text* exactly.

*lin_search* is intended to be used to get the numeric values associated
with compile time **\#define**s used for analysis methods and codes. For
each header item defined in *\<esps/header.h\>* that takes a numeric
value associated with a compile time **\#define**, there is a NULL
terminated array of strings that contains the string representations of
those compile time values. This array provides a run-time mapping
between the **\#define** names and the values.

*lin_search2* is suitable for searching for field names in the array
*hd.fea*-\>*names* in a FEA-file header, searching for CODED values in
the arrays *hd.fea*-\>*enums*\[*i*\] in a FEA-file header, and searching
for CODED values in the array *codes* in a generic-header (*gen_hd*)
structure.

# EXAMPLE

For the header item *equip* the possible values are (from
*\<esps/header.h\>*):

    #define EF12M	1
    #define AD12F	2
    #define DSC		3
    #define LPA11	4

The following statement in the library defines the array *equip_codes*:

    static char *equip_codes[] = {"NONE", "EF12M", "AD12F", "DSC", "LPA11", NULL};

If the application program reads a string into *text* that should
contain an equipment type, the the program can get the numeric code by:

    /* say text is "EF12M" */
    equip_type = lin_search(equip_codes,text);
    /* the function will return 1 */

The programmer must consult *\<esps/header.h\>* to get the valid values
and the name of the array associated with each header item. The required
**extern** declarations are in *\<esps/header.h\>*.

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS), FEA(5-ESPS)

# AUTHOR

Alan Parker
