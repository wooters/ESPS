# NAME

sdcomp - listening program to compare two sampled data files

# SYNOPSIS

**sdcomp** \[ **-b** *shift-value* \] \[ **-c** *channel* \] \[ **-d**
*delay* \] \[ **-{fprs}** *range* \] \[ **-g** *gain* \] \[ **-i** \] \[
**-R** *nrepeat* \] \[ **-n** *step* \] \[ **-w** *width* \] \[ **-x**
*debug-level* \] *sdfile* \[ *sdfile ...* \]

# DESCRIPTION

*Sdcomp* cycles through one or more ESPS FEA_SD(5-ESPS) files playing a
portion from each file by means of the local play(1-ESPS) program.
*Sdcomp* assumes that the local play program has the same command line
options as *mcplay.*

After *sdcomp* starts and after a portion is played from each file, the
user is prompted for the next action. The following commands are then
accepted (\<CR\> refers to the "return" key):

> 
>     <CR>		play next portion from each file
>     r<CR>		repeat current portion from each file
>     b<CR>		back up and play previous portion from each file
>     c<CR>		continue playing portions without stopping for commands
>     q<CR>		quit

# ESPS PARAMETERS

The ESPS parameter file processing is the same as that for *mcplay.*

# ESPS HEADERS

ESPS headers are treated as in *mcplay.*

# OPTIONS

The flags **bcgirwx** are passed to the local play program every time
that program is invoked. In addition, the following options are
supported:

**-{prsf}** *range*  
Selects the first portion that will be played from each file, with
syntax as in *mcplay.* The default is **-s**0:1. If the part of the
range specification after the colon is omitted (giving only the starting
point), the defaults are as follows:


    	-p<start>:+7999
    	-r<start>:+7999
    	-s<start>:+1
    	-f<start>:+79

These give approximately the same length (1 second) when the sampling
frequency is 8000 Hz., but not otherwise.

The effect of the **-{psrf}** option is to select the starting position
and length of the portion. This length remains in effect for subsequent
portions that are played, while the starting positions of subsequent
portions are determined by the **-n** option. Note that **-p** and
**-r** are synonyms.

**-d** *delay*  
If **-d** is not specified, *sdcomp* passes all the filename arguments
to one invocation of the play program each time a portion is played from
the files. If **-d** is specified, then each filename is passed to a
separate invocation of the play program, which is followed by a pause of
*delay* seconds. (Note that specifying **-d0** is not equivalent to
omitting the option entirely.)

**-w** *width \[100\]*  
This option defines the frame width. The width is ignored unless the
**-f** option is also specified.

**-n** *step*  
Selects the amount by which the starting position is changed from one
portion of each file to the next portion of each file. If the *step* is
less than the portion length (determined by **-{prsf}** ), the portions
will overlap. If it is greater than the portion length, the portions
played will skip segments of the files. The *step* must be expressed in
the same units as the *range.* That is, if *range* is specified with
**-p** or **-r** (points), the *step* is assumed to be points, etc. The
default for *step* equals the length of the initial portion specified by
the **-{prsf}** option.

# FUTURE CHANGES

The user should be able to change the order in which files are played.

There should be an option that causes *sdcomp* to select the order in
which files are played and report that order after all of the speech has
been played.

The user should be able to change the position, portion length, and step
size dynamically.

The user should be able to specify a separate gain (**-g**) or
shift-value (**-b**) for each input file.

# SEE ALSO

play(1-ESPS), FEA_SD(5-ESPS)

# WARNINGS

# BUGS

*A* *range* or *step* value in seconds is restricted to integer values
(this reflects a bug in *play* ).

# AUTHOR

Manual page by John Shore; program by Rodney Johnson
