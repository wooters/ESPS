# NAME

scatplot - make a scatter plot

# SYNOPSIS

**scatplot** \[ **-e** *range* \] \[ **-r** *range* \] \[ **-s**
*symbols* \] \[ **-t** *text* \] \[ **-x** *debug_level* \]\
\[ **-H** *text* \] \[ **-V** *text* \] \[ **-X** *range* \] \[ **-Y**
*range* \] \[ **-W** *generic window system options* \] *file1* \[
*file2* \] . . .

# DESCRIPTION

*Scatplot* makes a scatter plot of pairs of elements from multiple ESPS
files *file1, file2, . . . .* When used as a file name, \`\`-'' denotes
standard input.

The plot is displayed in an X window. The display has three pull down
menus: **File**, **Views**, and **Help**. The **File** menu has two
items: **Print** and **Quit**. **Print** selects a dialog box that has
controls to produce a PostScript output of the plot. The **Quit** item
causes the program to exit.

The **Views** menu has selectors that enable or disable display of the
box around the plot, the horizontal grid, the vertical grid, any text
(usually the file name and date), and the tick marks on the reticle.
This menu also has buttons to enable all of the above items, to redraw
the original plot, and to refresh the plot as it is currently shown.

The **Help** menu has two items: **on Plot Tool** and **About** Plot
Tool. These display a help file and version information.

If the **-r** option is omitted, then the entire contents of all files
are plotted.

The **-e** option specifies which elements to plot. An even number of
elements must always be given since there are no default elements to
plot. The first pair of elements is associated with the first file, the
second pair with the second file, and so on up to the last file or until
no other pair of elements remains, in which case the last pair of
elements is associated with the remaining files. The first element in
the pair is plotted as the abscissa and the second element as the
ordinate. Default symbols are used to distinguish between multiple
files, but they can be overridden by the **-s** option.

*Scatplot* finds the maximum and minimum of the *x* values and the *y*
values in the specified ranges of the input files and computes
appropriate scales This automatic scaling can be overridden by the
**-X** and **-Y** options.

# OPTIONS

The following options are supported:

**-e** *elements*  
Determine which elements within a record to plot. The elements may be
separated by commas, or, more generally, any construct acceptable to
*grange_switch*(3-ESPSu) may be used, as long as the number of elements
specified is even. The first pair of elements is associated with the
first file, the second pair with the second file, and so on up to the
last file or until no other pair of elements remains, in which case the
last pair of elements is associated with the remaining files. The first
element in the pair is plotted as the abscissa and the second element as
the ordinate.

**-r** *first:last*  
**-r***"***first:+incr**  
Determines the range of records to be plotted. In the first form, a pair
of unsigned integers gives the first and last records of the range. If
*first* is omitted, 1 is used. If *last* is omitted, the last record in
the file is used. The second form is equivalent to the first with *last
= first + incr .*

This option may be repeated. The first **-r** option applies to the
first input file, the second **-r** option to the second input file, and
so on. If there are more files than **-r** options, then the last option
applies to all remaining files.

**-s** *symbols \[xo\*abcdefghijklmnpqrstuvwyz\]*  
Plot the scatter plot using the symbols specified. The first symbol is
used for the first file, the second symbol for the second file, and so
on up to the last file. There must be at least as many symbols as files.
The default symbols are given in brackets.

The positions of the symbols *\`x'* and *\`o'* have been modified so
that the plotting point falls very close to the "center" of the
character. Other characters will not have their centers exactly at the
plotting points.

**-t** *text*  
Print a line of text above the graph.

**-x** *level*  
If *level* is nonzero, debugging information is written to the standard
error output. Default is 0 (no debugging output).

**-H** *text*  
Print a line of text below the graph.

**-V** *text*  
Print a line of text along the left side of the graph going upwards.

**-X** *low:high*  
Specifies lower and upper limits for the x-axis, disables automatic
computation of limits.

**-Y** *low:high*  
Specifies lower and upper limits for the y-axis, disables automatic
computation of limits.

**-W**  
This option is followed by a character string consisting of the generic
window system options. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:

\
*scatplot -W "=300x250+50+200" file*.

# EXAMPLES

**scatplot -r***1:500* **-s***xo* **-e***5,6,15,19 file1 file2*  
makes a scatter plot (using the letter *x* for file1 and the letter *o*
for file2) of element 5 versus element 6 in *file1* and of element 15
versus element 19 in *file2* across the record range 1 to 500. The plot
is displayed on the graphics terminal.

# ESPS PARAMETERS

*Scatplot* does not read an ESPS parameter file.

# ESPS COMMON

*Scatplot* does not read or write the ESPS common file.

# ESPS HEADERS

*Scatplot* reads the following fields from the ESPS file headers:
*common.ndrec,* *common.tag.*

# DIAGNOSTICS

    scatplot: please give only one -e option.
    scatplot: -e option: even number of elements required.
    scatplot: please specify an element range with the -e option.
    scatplot: data is not tagged in file, cannot plot element 0.
    scatplot: please specify n_symbols symbols with the -s option.
    scatplot: start point after end point.
    scatplot: only n_points in file.
    scatplot: only n_records records read in file.
    scatplot: calloc: could not allocate memory for array.
    scatplot: d_mat_alloc: could not allocat memory matrix.
    scatplot: command line too long: truncating string.

# EXPECTED CHANGES

Allow range specifications of the form *\<field
name\>***\[***\<range\>***\]** with FEA files.

# SEE ALSO

mlplot(1-ESPS), genplot(1-ESPS), fea_element(1-ESPS),
grange_switch(3-ESPS).

# AUTHOR

    Ajaipal S. Virdy
    Generalized by Rodney Johnson to allow independent ranges in the input
    files.
