# NAME

next_slide - cause *xloadimage* to advance to the next slide.

# SYNOPSIS

**next_slide** \[ *wait* \]

# DESCRIPTION

*next_slide* is used with a modified version of the *xloadimage* program
to control advancing from one image to the next in a program-controlled
slideshow. The programs are used in a shell script as follows.

    next_slide 0
    xloadimage -prog_slideshow file_1 ... file_n &
    ... <commands> ...
    next_slide
    ... <more commands> ...
    next_slide
    ... <etc.> ...

The reason for the initial *next_slide 0* is explained further down. The
*xloadimage* line starts the program as a background process and with
the images to be displayed as arguments; *xloadimage* displays the first
image. The first group of commands following the *xloadimage* line is
executed; execution begins while *xloadimage* is still processing the
first image. The first *next_slide* command *after* the invocation of
*xloadimage* causes *xloadimage* to begin processing the second image,
which replaces the first on the screen. The second group of commands,
indicated by *\<more commands\>,* begins execution while the second
image is being processed. The second next_slide command causes
*xloadimage* to begin processing the third image. Execution of the shell
script continues in this way, with invocations of *next_slide*
alternating with other commands. The number of *next_slide* commands
after the *xloadimage* line (*i.e.* not counting the initial *next_slide
0*) should be the same as the number of image files to be displayed. The
last *next_slide* causes the last image to be taken down, and
*xloadimage* terminates.

The two programs communicate with a semaphore that has four states:
"Busy", "Ready", "Pause", and "Quit". (For those who care about the
details, this is implemented as a property named "XLOADIM_READY" that is
set on the root window. See section 10.1 of the *Xlib Programming
Manual* for more information.) The value is normally supposed to be
"Busy" when *xloadimage* is not running or is processing an input file
in preparation for displaying it. The value is normally supposed to be
"Ready" when a slide is on the screen and *xloadimage* is waiting for
the command to begin processing the next image. To this end *xloadimage*
sets the value to "Busy" during initialization and just before exiting;
it sets the value to "Ready" just after sending an image to the screen.
When *next_slide* runs, it waits, if necessary, for the value to become
"Ready" and then changes the value to "Busy". When the value changes,
the window system automatically notifies *xloadimage* of the change, and
*xloadimage* begins processing the next file, if any, or else exits.

*next_slide* normally does not wait indefinitely for the semaphore to
become "Ready". After a maximum waiting time in the "Busy" state, 60
seconds by default, *next_slide* concludes that *xloadimage* is not
running and simply exits. However, if the semaphore state is "Pause",
*next_slide* will wait indefinitely, regardless of the maximum. Typing
'h' (for "hold") to *xloadimage* sets the semaphore to "Pause" and
prevents a subsequent invocation of *next_slide* from causing an advance
to the next image. Typing 'c' (for "continue") changes the semaphore to
"Ready", and any waiting invocation of *next_slide* then triggers the
advance. A non-default value for the maximum waiting time can be
specified in seconds on the command line.

Typing 'q' (for "quit") to *xloadimage* sets the semaphome to "Quit" and
exits from *xloadimage.* If *next_slide* detects the "Quit" state, it
changes the semaphore to "Busy" and exits.

*next_slide* returns exit status 0 after setting the semaphore from
"Ready to "Busy" to bring up the next image. It returns exit status 1
after detecting a "Quit", after timing out, and in case of various other
errors. Thus writing

    next_slide || exit 1

in the shell script in place of simply

    next_slide

will cause an exit from the shell script at that point if "Quit" is
detected.

As a special case, a command-line argument of 0 causes *next_slide* to
set the semaphore to "Busy" and return exit status 0 immediately,
without a timeout message. The reason for putting *next_slide 0* in the
shell script before the invocation of *xloadimage* is to guard against
confusion that is possible when an earlier run of *xloadimage* has been
terminated abnormally or with a typed 'q', leaving the semaphore in a
state other than "Busy" with *xloadimage* not running.

# FUTURE CHANGES

# SEE ALSO

xloadimage(1)

# BUGS

After *next_slide* runs, there may be a processing delay of several
seconds before the next image actually becomes visible. During that
period, an 'h' typed to *xloadimage* will cause the image being
processed to remain visible once it comes up; it will not affect the
image that is actually visible at the time. Similarly, a 'q' typed to
*xloadimage* during a processing period does not take effect until the
processing is complete.

# REFERENCES

A. Nye, *Xlib Programming Manual for Version 11 of the X Window System,*
O'Reilly & Associates, Sebastopol, Calif., 1990.

# AUTHOR

Rod Johnson, Entropic Research Laboratory, Inc.

# COPYRIGHT

Copyright (c) 1990 Entropic Research Laboratory, Inc.

The *next_slide* program is copyrighted material covered by a copyright
and disclaimer of liability similar to that used by the MIT X
Consortium. Briefly, unlimited free use, copying, and distribution are
allowed provided that the copyright notice and disclaimer are left
intact. See the source files for complete information. The *next_slide*
program is free software; it is *not* a part of ESPS or the *waves+*
software package, and fees paid to ERL as part of ESPS or *waves+*
license agreements do *not* include any payments for *next_slide.*
