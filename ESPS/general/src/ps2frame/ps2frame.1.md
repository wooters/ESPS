# NAME

ps2frame - Modify PostScript Output for Framemaker Graphics Import

# SYNOPSIS

**ps2frame** *filename*

# DESCRIPTION

*Ps2frame* takes an embedded PostScript file produced by doing a
*graphic* export from *waves+* or other Entropic programs and modifies
it so that it can be imported into Framemaker. This is to work around a
bug in Framemaker. The particular problem is that Framemaker will not
allow the **Bounding Box** comment to be used with the **(atend)**
operator. This program is simply a script that moves the **Bounding**
Box statement from the end of the file to the beginning.

# OPTIONS

This program has no options.

# ESPS PARAMETERS

This program does not process any ESPS Parameters.

# ESPS COMMON

This program does not process ESPS Common.

# SEE ALSO

*xwaves* (1-ESPS), *plot3d* (1-ESPS)

# REFERENCES

PostScript Language Reference Manual, Second Edition, Adobe Systems Inc.

# AUTHOR

Alan Parker, after help from Ken Blackwell of Bristol Technology, Inc.
