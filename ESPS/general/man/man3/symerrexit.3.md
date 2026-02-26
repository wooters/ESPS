# NAME

symerr_exit - terminate program if any errors occurred while reading a
value of a symbol

# SYNOPSIS

**void**\
**symerr_exit();**

# DESCRIPTION

*symerr_exit* terminates a program if any errors occurred a value is
read from a symbol table.

# EXAMPLE

    /* create symbol table of the parameter file */
    read_param("params");

    /* now read in the values of the parameters from the symbol table */
    start = getsym_i ("start");
    nan = getsym_i ("nan");
    decrem = getsym_s ("decrem");
    harmonic_mult = getsym_d ("harmonic_mult");

    symerr_exit();      /* exit if any errors occurred */

# DIAGNOSTICS

None.

# BUGS

None.

# SEE ALSO

read_params(3-ESPSu), getsym(3-ESPSu), putsym(3-ESPSu)

# REFERENCES

\[1\] ETM-S-86-12:jtb, Parameter Files in the Speech Processing System

# AUTHOR

Joe Buck, Man page by Ajaipal S. Virdy
