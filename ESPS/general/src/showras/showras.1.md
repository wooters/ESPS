# NAME

showras - display Sun rasterfile image

# SYNOPSIS

**showras** \[ **-x** *debug_level* \] *input.ras*

# DESCRIPTION

This program runs only on Sun systems under SunView. The input file
contains an image in Sun rasterfile format. (Files in this format can be
made with image(1-ESPS).) The program reads the file, creates a window,
and displays the image in the window. If the file name is given as
\`\`-'', standard input is read.

# OPTIONS

The following option is supported. A value in brackets is a default.

**-x** *debug_level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).
The default level of zero suppresses all debugging messages.

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

The ESPS common file is not accessed.

# SEE ALSO

image(1-ESPS)

# DIAGNOSTICS

    showras: unknown option -letter
    Usage: showras [-x debug_level] input.ras
    showras: no file name.
    showras: too many file names.
    showras: can't open input file
    showras: m-plane image incompatible with n-plane screen.

# BUGS

None known.

# WARNINGS

# FUTURE CHANGES

# AUTHOR

Rodney Johnson, ESI
