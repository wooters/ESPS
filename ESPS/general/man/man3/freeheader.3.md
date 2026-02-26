# NAME

free_header - free storage for an ESPS header

# SYNOPSIS

void\
free_header(hdr, flags, ptr)\
struct header \*hdr;\
unsigned long flags;\
char \*ptr;

# DESCRIPTION

If *hdr* points to an ESPS header, *free_header* attempts to free
storage for all parts of the header, including embedded headers. If
*hdr* is NULL, *free_header* simply returns immediately. The arguments
*flags* and *ptr* are reserved for future elaboration of the function
and are ignored by the present version.

**Use with CAUTION. This function is DANGEROUS.** A header may share
storage with other data structures in a C program, including other
headers. Using *free_header* on such a header will destroy part or all
of the other data structures. Moreover, a header may contain pointers to
storage that has not been allocated by *malloc.* Using *free_header* on
such a header will disrupt the memory-allocation mechanism by causing
*free* to be called with inappropriate arguments; \`\`grave disorder''
will result, according to the *malloc*(3) manual page.

Here are some examples, by no means exhaustive, of problem situations.
After

add_source_file(hdr_1, "name_2", hdr_2);

freeing all of *hdr_1* will destroy *hdr_2,* and freeing all of *hdr_2*
will destroy part of *hdr_1.* After

add_genhd_d("name", ptr, size, hdr);

if the pointer argument *ptr* is non-NULL, it is incorporated into the
structure of *hdr;* if *ptr* points to a variable in the C program,
rather than *malloc*ed storage, freeing *hdr* will bring disaster.

When *can* you use *free_header*? The safest rule is to use it only on
headers that have been freshly read in by *read_header*(3-ESPS) and have
not been modified or included in other headers. With one exception, it
is also safe to free a header that has been read by *eopen*(3-ESPS) and
has not been modified or included in another header. The exception is a
header that *eopen* has read from an old-style SD file and converted to
FEA_SD (see the *eopen*(3-ESPS) manual page). The resulting FEA_SD
header should not be freed with *free_header.*

# EXAMPLE

# DIAGNOSTICS

# FUTURE CHANGES

Allow use of the last two arguments to specify parts of the header that
*read_header* should not attempt to free.

# BUGS

This function can do great damage to a program's data structures if used
incautiously. Please read the advice in the \`\`Description'' section
above.

# SEE ALSO

    read_header(3-ESPSu), eopen(3-ESPSu),
    free_fea_rec(3-ESPSu), skip_header(3-ESPSu), 
    add_source_file(3-ESPSu), add_genhd(3-ESPSu),
    malloc(3), free(3)

# AUTHOR

Rodney Johnson.
