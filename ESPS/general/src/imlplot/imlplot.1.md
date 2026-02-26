# NAME

imlplot - interactive and remote plotting using mlplot

# SYNOPSIS

**imlplot** \[ *mlplot options . . .* \] \[ *file.sd . . .* \]

# DESCRIPTION

*Imlplot* forms and displays a plot command line consisting essentially
of the command name *mlplot* followed by the given options and file
names. It then prompts the user for the next action. The following
commands are accepted (\<CR\> designates the *return* key).

\<CR\>  
no action (just redisplay current plot command line and prompt)

**m**\<CR\>  
plot on MASSCOMP or Sun graphics display using *mcd*

**i**\<CR\>  
plot on local Imagen laser printer

**-***option\<CR\>*  
add or change plot command line option

**~***letter\<CR\>*  
remove plot command line option

**fg** *filename\<CR\>*  
save plot in file in \`\`gps'' format

**ft** *filename\<CR\>*  
save plot in file in Imagen (Tektronix) format

**s** *filename\<CR\>*  
append plot command line to file

**?**\<CR\>  
list commands and options

**q**\<CR\>  
quit

The *m* command executes the plot command with the additional option
*-Tmcd.* The *i* command executes the plot command with the additional
option *-Timagen.*

On a Sun workstation, this program must be run from within the
*Suntools* window system. The plot will appear in a new window, which
can be moved, resized, closed (reduced to an icon), and removed by using
the functions on the *Suntools* menu. To get this menu, move the mouse
cursor to the title bar of the plot window and press the right mouse
button. Each time that the **m** command is used, a new plot window will
be created.

# OPTIONS

All *mlplot*(1-ESPS) options except *-T device* are accepted on the
*imlplot* command line and by the *-option* interactive command.

# ESPS PARAMETERS

The ESPS parameter file processing is the same as that for *mlplot.*

# ESPS COMMON

The ESPS common file processing is the same as that for *mlplot.*

# ESPS HEADERS

ESPS headers are handled by *mlplot.*

# DIAGNOSTICS

Diagnostics may be produced by any of the programs that *imlplot*
executes; see the individual manual pages for *mlplot* and the other
programs listed under \`\`See Also.'' In addition, *imlplot* may produce
the following messages directly.

    Usage: imlplot [ . . . ][file.sd . . . ]
    Option ltr requires argument.
    Option ltr takes no argument.
    Option ltr not recognized.
    Commands: list of commands.
    Options: list of options.

# SEE ALSO

*mlplot*(1-ESPS), *igenplot*(1-ESPS), *genplot*(1-ESPS),

# BUGS

Knowledge of the options accepted by *mlplot* is wired in; *imlplot* may
need to be changed if *mlplot* is changed.

The *m* command does not provide a convenient way to examine a multipage
plot one page at a time within *imlplot.*

# AUTHOR

Rodney W. Johnson
