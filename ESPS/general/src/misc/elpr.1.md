# ELPR

elpr - a standard way for ESPS/waves+ scripts to print

# SYNOPSIS

**elpr \[any lpr options\]**

# DESCRIPTION

Program **elpr(1)** provides a standard means for ESPS/waves+ scripts to
print. If environment variable ELPR is set then it is evaluated and
executed with any paramaters passed on the elpr command line. If the
enviroment variable ELPR is not set then lpr is called with the command
line parameters

# EXAMPLES

    %setenv ELPR "lpr -Php"
    %elpr -n -c 1 foobar.ps

# BUGS

None known.

# REFERENCES

# SEE ALSO

# AUTHOR

Ken Nelson
