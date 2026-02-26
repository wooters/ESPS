# NAME

randplay - create script of commands for randomized "A-B" listening
comparisons

# SYNOPSIS

**randplay** \[ **-a** \[ \[ **-s** \] \[ **-d** *path* \] \[ **-n**
*program* \] *compfile* \[ *play-options* \]

# DESCRIPTION

*Randplay* accepts an ASCII file containing ESPS FEA_SD file names and
produces on standard output a script that can be used for randomized
listening comparisons. The input file *compfile* lists groups of FEA_SD
files that are to be compared within the group. Groups are separated by
a line containing the single character "#". Within each group, FEA_SD
file names are separated by white space or white space followed by a
newline. Thus files can be listed one per-line or several per-line. It
is not necessary for the "#" marker to follow the final group.

For each group of FEA_SD files, *randplay* determines all possible
two-file comparisons. For each two-file comparison, *randplay* outputs a
command that plays the two files in random order using the specified
FEA_SD play program (see **-n** ). The entire set of output commands for
all groups (each causing two files to be played) is itself output in
random order.

If *compfile* is "-", standard input is read. All characters after
*compfile* in the command line are assumed to be option flags for the
play program and are passed on to the play program each time it is
called in the output script.

*Randplay* does not check to see if the FEA_SD files exist.

# ESPS PARAMETERS

The ESPS parameter file is not read by *randplay.*

# ESPS COMMON

The ESPS common file is not written by *randplay.*

# OPTIONS

The following options are supported:

**-a**  
Specifies that all "A-B" comparisons are to be made, including
comparisons of each file to itself. Otherwise, files are compared to
other files in the same line from *compfile* but not to themselves.

**-d** *path*  
Specifies a directory path that will be prepended to all of the file
names in the output script. A "/" is added to the *path* by *randplay.*
If the **-d** option is not used, file names will appear exactly as they
do in the input file *compfile.*

**-n** *program \[play\]*  
Determines the name of the play program that is used in the output shell
script.

**-s**  
Specifies that a scoring sheet be output in the file *scoresheet* in the
current directory. The scoring sheet is the sheet filled out by
listeners.

# EXAMPLES


         %cat > rtest
         jes.sd kle.sd 
         rap.sd 
         #
         jtb.sd sn.sd jpb.sd
         ^D
         %randplay rtest > rtestscript
         %cat rtestscript
         play rap.sd kle.sd
         play rap.sd jes.sd
         play kle.sd jes.sd
         play jpb.sd sn.sd
         play jtb.sd sn.sd
         play jpb.sd jtb.s

To play two files without knowing their order, one could do the
following:


         %echo "file1.sd file2.sd" | randplay - | sh

# FUTURE CHANGES

# SEE ALSO

play(1-ESPS), sdcomp(1-ESPS), ESPS(5-ESPS), FEA_SD(5-ESPS)

# WARNINGS

# BUGS

None known.

# AUTHOR

Manual page and program by John Shore
