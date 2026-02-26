# NAME

    ecc - compile simple ESPS programs 
    elint - run lint on simple ESPS programs

# SYNOPSIS

**ecc** \[ **cc options** \] *files*\
**elint** \[ **lint options** \] *files*

# DESCRIPTION

*ecc* is used just like *cc*(1) to compile simple ESPS programs. *ecc*
supplies the correct location of the ESPS include files to *cc* using
the **-I** option and supplies the correct library names on the *cc*
command line. The generated *cc* command is printed on standard output.

*elint* is used to run *lint*(1) on ESPS programs. The program supplies
the correct include file directories and lint library names to *lint*.

All of these program also search the Unix math library (-lm).

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS HEADERS

ESPS data files are not read or written.

# WARNINGS

No error messages are produced by these programs. Various error and
warning messages are possible from the C compiler or the loader.

# AUTHOR

Alan Parker
