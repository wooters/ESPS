# NAME

genhd_list - returns a list of defined generic header items

# SYNOPSIS

\#include \<esps/esps.h\>

char \*\*\
genhd_list(size, hd)\
int \*size;\
struct header \*hd;

# DESCRIPTION

*genhd_list* returns a pointer to a NULL terminated array of character
strings (really pointers) of the generic header item names in *hd*. The
number of generic header items is returned through the pointer *size*.
If no generic header items have been defined, then NULL is returned and
*size* is returned as zero.

# EXAMPLE

    char **array;
    int size;
    array = genhd_list(&size,hd);
    if (n >= 4) {
      printf("name: %s\n",*array[3]);	/* prints the name of the 4th item */
    }

# DIAGNOSTICS

If *hd* is NULL the a message is printed and the program is terminated.
There is an internal check to insure that the number of defined header
items is correct. If this fails, a message is printed and the program
terminates. This indicates an error in the library software.

# SEE ALSO

add_genhd(3-ESPSu), get_genhd(3-ESPSu), genhd_type(3-ESPSu),
copy_genhd(3-ESPSu)

# AUTHOR

Alan Parker
