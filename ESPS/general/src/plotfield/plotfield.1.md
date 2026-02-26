# NAME

plotfield - plot arbitrary named field from a FEA file

# SYNOPSIS

**plotfield** **-f** *field* \[ **-r** *range* \] \[ **-t** *text* \] \[
**-x** *debug_level* \] \[ **-y** *range* \] \[ **-Y** *range* \]
*file.fea*

# DESCRIPTION

*plotfield* plots a named field from an ESPS FEA *file.fea.* Fields
containing complex data are not supported yet. If *file.fea* is "-", the
standard input is read.

The plot is displayed in an X window. The display has three pull down
menus: **File**, **Views**, and **Help**. See *plotsd(1-ESPS)* for a
description of these menus.

If the **-r** option is omitted, then the named *field* is plotted from
just the first record of *file.fea.* Use **-r1:** to plot the data for
the entire file.

*Plotfield* finds the maximum and minimum values of the points to be
plotted and computes appropriate scales for the *x*- and *y*-axes. These
automatic values for the y-axis can be overriden by the **-y** or **-Y**
options.

The fieldname to plot must be given with the **-f** flag. This is not
optional and there is no default.

# OPTIONS

The following options are supported:

**-r** *record*  
**-r** *first:last*  
**-r***"***first:+incr**  
Determines the records from which the named *field* is plotted. In the
first form, a single integer identifies one record from which *field* is
plotted. The *x*-axis shows element number within the field and the
*y*-axis shows element value.

In the second form, a pair of unsigned integers gives the first and last
points of the range. If *first* is omitted, 1 is used. If *last* is
omitted, the last record in *file.fea* is assumed. The third form is
equivalent to the first with *last = first + incr.* When more than one
record is plotted, the element values are catenated together before
plotting with the *x*-axis showing the cumulative element number. (For
example, if *field* has ten elements and two records are plotted, the
*x*-axis will be labelled 1-20).

**-t** *text*  
A line of text to be printed below the plot. By default, *plotfield*
prints a line giving the fieldname, record number, and file name. An
additional line may be printed via the **-t** option.

**-x** *debug_level*  
If *debug_level* is nonzero, debugging information is written to the
standard error output. Default is 0 (no debugging output).

**-y** *low:high*  
Specifies approximate lower and upper limits for the *y*-axis. The
values are adjusted by *plotfield* in an attempt to make an esthetically
pleasing plot. See also the **-Y** option. If neither **-y** or **-Y**
is specified, limits are calculated automatically.

**-Y** *low:high*  
Specifies exact lower and upper limits for the *y*-axis.

# EXAMPLES

**plotfield -f spec_param -r5** speech.fana

plots the *spec_param* field from record 5 of speech.fana.

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

ESPS Common processing is disabled.

# DIAGNOSTICS

*Plotfield* complains and exits if *file.fea* does not exist or is not a
FEA file. It also exits if the named field contains complex data.

# IMPLEMENTATION NOTE

The current version of *fieldplot* is implemented as a shell script that
pipes the output of *pplain* (1-ESPS) through *testsd* (1-ESPS) and
*plotsd* (1-ESPS). This is an example of how ESPS programs can be
combined with the "Unix tools approach" - see the simplified example on
the *pplain* (1-ESPS) man page.

# EXPECTED CHANGES

None contemplated.

# SEE ALSO

plotsd(1-ESPS) plotspec(1-ESPS), mlplot(1-ESPS),\
genplot(1-ESPS)

# AUTHOR

    Manual page by John Shore
    Program by Alan Parker
