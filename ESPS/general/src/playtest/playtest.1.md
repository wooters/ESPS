# NAME

playtest - step through an "A-B" listening test

# SYNOPSIS

**playtest** \[ *playfile* \]

# DESCRIPTION

*Playtest* provides a convenient means of stepping through a series of
*play* (1-ESPS) commands for "A-B" comparisons, and for recording the
listener's preferences. *Playtest* reads *playfile* (or standard input,
if *playfile* is missing), which should consist of a series of commands
to the *play* (1-ESPS) program, one command per line. Each command to
*play* should present a single "A-B" comparison. Suitable input files
can be generated with *randplay* (1-ESPS).

After running the first command from *playfile,* twice *playtest* pauses
for input from the user. The following commands are then accepted
(\<CR\> refers to the "return" key):

> 
>     <CR>		present the next comparison
>     r<CR>		repeat current comparison
>     s<CR>		run sdcomp (1-ESPS) on the current comparison
>     c<CR>		continue playing comparisons without stopping
>     q<CR>		quit

Although *playtest* is intended for use on scripts containing *play*
commands, it will run any commands contained in *playfile.* Hence, other
uses for *playtest* may arise.

# OPTIONS

No options are supported.

# ESPS PARAMETERS

The ESPS parameter file is not read by *playtest.*

# ESPS HEADERS

*Playtest* does not read any ESPS files.

# FUTURE CHANGES

*Playtest* may be modified so that special commands in the input file
can be used to do such things as print messages to the listener,
determine the maximum number of repetitions and calls to *sdcomp* that
will be permitted for any one comparison, etc. Such commands would be
embedded in lines that begin with "#", so that the input file can still
be used as a shell script. Alternative approaches include using command
line options or providing a special file of commands to *playtest.*

# SEE ALSO

play(1-ESPS), sdcomp(1-ESPS), randplay(1-ESPS)

# BUGS

# AUTHOR

Manual page by John Shore, program by Alan Parker
