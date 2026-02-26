# NAME

xloadimage, xsetbg, xview - load images into an X11 window or onto the
root window

# SYNOPSIS

*xloadimage* \[global_options\] {\[image_options\] image ...}

# DESCRIPTION

*Xloadimage* displays images in an X11 window or loads them onto the
root window. See the *IMAGE TYPES* section below for supported image
types.

If the destination display cannot support the number of colors in the
image, the image will be dithered (monochrome destination) or have its
colormap reduced (color destination) as appropriate. This can also be
done forcibly with the *-halftone* and *-colors* options.

If more than one image is to be loaded, they will be merged into a
single image. The *-at* and *-center* options control where subsequent
images will be loaded onto the initial image. Any combination of color
image depths and/or monochrome images may be loaded at one time. If
merging two color images would overload the number of available colormap
entries, the number of colors shared between the images will be
automatically reduced to fit.

A variety of image manipulations can be specified, including
brightening, clipping, dithering, depth-reduction, and zooming. Most of
these manipulations have simple implementations; speed was opted for
above accuracy.

If you are viewing a large image in a window, the initial window will be
at most 90% of the size of the display unless the window manager does
not correctly handle window size requests or if you've used the
*-fullscreen* option. You may move the image around in the window by
dragging with the first mouse button. The cursor will indicate which
directions you may drag, if any. You may exit the window by typing 'q'
or '^C' when the keyboard focus is on the window.

It's possible to have a "slideshow" of many images by specifying the
*-slideshow* or *-prog_slideshow* option.

A wide variety of common image manipulations can be done by mixing and
matching the available options. See the section entitled *HINTS FOR*
GOOD IMAGE DISPLAYS for some ideas.

*Xsetbg* is equivalent to *xloadimage -onroot -quiet* and *xview* is
equivalent to *xloadimage -view -verbose*.

# GLOBAL OPTIONS

The following options affect the global operation of *xloadimage*. They
may be specified anywhere on the command line.

-border *color*  
This sets the background portion of the window which is not covered by
any images to be *color*.

-display *display_name*  
X11 display name to send the image(s) to.

-fullscreen  
Use the entire screen to display images. This option is incompatible
with -onroot.

-geometry *WxH\[{+-X}{+-}Y\]*  
This sets the size of the window onto which the images are loaded to a
different value than the size of the image. When viewing an image in a
window, this can be used to reduce the size of the destination window.
When loading an image onto the root window, this option controls the
size of the pixmap which will be loaded onto the root. If the size is
smaller than that of the display, the image will be replicated.

-install  
Forcibly install the image's colormap when the window is focused. This
violates ICCCM standards and only exists to allow operation with naive
window managers. Use this option only if your window manager does not
install colormaps properly.

-list  
List the images which are along the image path.

-help  
Displays a short summary of xloadimage command line syntax.

-onroot  
Load image(s) onto the root window instead of viewing in a window. This
is the opposite of *-view*. *XSetbg* has this option set by default.
Loading with the -onroot option will fail if enough sharable colors
cannot be allocated from the default colormap.

-path  
Displays the image path and image suffixes which will be used when
looking for images. These are loaded from ~/.xloadimagerc and optionally
from a systemwide file (normally /usr/lib/xloadimagerc).

-prog_slideshow  
Show image arguments one at a time instead of merging them. While
*xloadimage* is running (say as a background process) running the
program *next_slide* will advance to the next image. Typing 'h' (for
"hold") will cause the next invocation of *next_slide* to wait
indefinitely before advancing to the next image. Typing 'c' (for
"continue") will undo the effect of 'h'. Typing 'q' will quit. This
option is useful for automated demo programs in which image display is
coordinated with other programmed activity such as recorded voice
output. See the manual page for *next_slide* for more information.

-quiet  
Forces *xloadimage* and *xview* to be quiet. This is the default for
*xsetbg*, but the others like to whistle.

-slideshow  
Show each image argument one at a time instead of merging them. Typing
'p' will back up to the previous image displayed, 'n' will go to the
next image, and 'q' or '^C' will quit. This option is often used in
conjunction with -fullscreen.

-supported  
List the supported image types.

-verbose  
Causes *xloadimage* to be talkative, telling you what kind of image it's
playing with and any special processing that it has to do. This is the
default for *xview* and *xloadimage*.

-version  
Print the version number and patchlevel of this version of *xloadimage*.
Versions prior to version 1, patchlevel 03 do not have this option and
should be updated.

-view  
View image(s) in a window. This is the opposite of *-onroot* and the
default for *xsetbg*.

# IMAGE OPTIONS

The following options may preceed each image. These options are local to
the image they preceed.

-at *X*,*Y*  
Indicates coordinates to load the image at on the first image. If this
is an option to the first image, and the *-onroot* option is specified,
the image will be loaded at the given location on the display
background.

-background *color*  
Use *color* as the background color instead of the default (usually
white but this depends on the image type) if you are transferring a
monochrome image to a color display.

-brighten *percentage*  
Specify a percentage multiplier for a color image's colormap. A value of
more than 100 will brighten an image, one of less than 100 will darken
it.

-center  
Center the image on the first image loaded. If this is an option to the
first image, and the *-onroot* option is specified, the image will be
centered on the display background.

-colors *n*  
Specify the maximum number of colors to use in the image. This is a way
to forcibly reduce the depth of an image.

-clip *X*,*Y*,*W*,*H*  
Clip the image before loading it. *X* and *Y* define the upper-left
corner of the clip area, and *W* and *H* define the extents of the area.
A zero value for *W* or *H* will be interpreted as the remainder of the
image.

-dither  
Dither a color image to monochrome using a Floyd-Steinberg dithering
algorithm. This is slower than *-halftone* but looks much better.

-foreground *color*  
Use *color* as the foreground color instead of black if you are
transferring a monochrome image to a color display. This can also be
used to invert the foreground and background colors of a monochrome
image.

-halftone  
Force halftone dithering of a color image when displaying on a
monochrome display. This happens by default when viewing color images on
a monochrome display. This option is ignored on monochrome images. This
dithering algorithm blows an image up by sixteen times; if you don't
like this, the *-dither* option will not blow the image up but will take
longer to process.

-name *image_name*  
Force the next argument to be treated as an image name. This is useful
if the name of the image is *-dither*, for instance.

-xzoom *percentage*  
Zoom the X axis of an image by *percentage*. A number greater than 100
will expand the image, one smaller will compress it. A zero value will
be ignored.

-yzoom *percentage*  
Zoom the Y axis of an image by *percentage*. See *-xzoom* for more
information.

-zoom *percentage*  
Zoom both the X and Y axes by *percentage*. See *-xzoom* for more
information. Technically the percentage actually zoomed is the square of
the number supplied since the zoom is to both axes, but I opted for
consistency instead of accuracy.

# EXAMPLES

To load the rasterfile "my.image" onto the background and replicate it
to fill the entire background:

xloadimage -onroot my.image

To load a monochrome image "my.image" onto the background, using red as
the foreground color, replicate the image, and overlay "another.image"
onto it at coordinate (10,10):

xloadimage -foreground red my.image -at 10,10 another.image

To center the rectangular region from 10 to 110 along the X axis and
from 10 to the height of the image along the Y axis:

xloadimage -center -clip 10,10,100,0 my.image

To double the size of an image:

xloadimage -zoom 200 my.image

To halve the size of an image:

xloadimage -zoom 50 my.image

To brighten a dark image:

xloadimage -brighten 150 my.image

To darken a bright image:

xloadimage -brighten 50 my.image

# HINTS FOR GOOD IMAGE DISPLAYS

Since images are likely to come from a variety of sources, they may be
in a variety of aspect ratios which may not be supported by your
display. The *-xzoom* and *-yzoom* options can be used to change the
aspect ratio of an image before display. If you use these options, it is
recommended that you increase the size of one of the dimensions instead
of shrinking the other, since shrinking looses detail. For instance,
many GIF images have an X:Y ratio of about 2:1. You can correct this for
viewing on a 1:1 display with either *-xzoom 50* or *-yzoom 200* (reduce
X axis to 50% of its size and expand Y axis to 200% of its size,
respectively) but the latter should be used so no detail is lost in the
conversion.

When merging images, the first image loaded is used to determine the
depth of the merged image. This becomes a problem if the first image is
monochrome and other images are color, since the other images will be
dithered to monochrome before merging. You can get around this behavior
by using the *-geometry* option to specify the size of the destination
image -- this will force *xloadimage* to use the default depth of the
display instead of 1. The standard behavior might be modified in the
future if it becomes a problem.

You can perform image processing on a small portion of an image by
loading the image more than once and using the *-at* and *-clip*
options. Load the image, then load it again and clip, position, and
process the second. To brighten a 100x100 rectangular portion of an
image located at (50,50), for instance, you could type:

xloadimage my.image -at 50,50 -clip 50,50,100,100 -brighten 150 my.image

One common use of *xloadimage* is to load images onto the root window.
Unfortunately there is no agreed-upon method of freeing some root window
resources, such as colormap entries, nor is there a way to modify the
root window colormap without confusing most window managers. For this
reason, *xloadimage* will not allow the loading of images onto the root
window if it cannot allocate shared colors from the root window's
colormap. I suggest the avoidance of multiple color image loads onto the
root window, as these eat up root window shareable colormap entries. If
you wish to have a slideshow, use the *-slideshow* or *-prog_slideshow*
option, possibly together with *-fullscreen*.

One common complaint is that *xloadimage* does not have a *-reverse*
function for inverting monochrome images. In fact, this function is a
special-case of the foreground and background coloring options. To
invert an image with a black foreground and white background (which is
standard), use *-foreground white* -background black. This will work on
both color and monochrome displays.

# PATHS AND EXTENSIONS

The file ~/.xloadimagerc (and optionally a system-wide file) defines the
path and default extensions that *xloadimage* will use when looking for
images. This file can have two statements: "path=" and "extension=" (the
equals signs must follow the word with no spaces between). Everything
following the "path=" keyword will be prepended to the supplied image
name if the supplied name does not specify an existing file. The paths
will be searched in the order they are specified. Everything following
the "extension=" keyword will be appended to the supplied image name if
the supplied name does not specify an existing file. As with paths,
these extensions will be searched in the order they are given. Comments
are any portion of a line following a hash-mark (#).

The following is a sample ~/.xloadimagerc file:

      # paths to look for images in
      path= /usr/local/images
            /home/usr1/guest/madd/images
            /usr/include/X11/bitmaps

      # default extensions for images; .Z is automatic; scanned in order
      extension= .csun .msun .sun .face .xbm .bm

Versions of *xloadimage* prior to version 01, patchlevel 03 would load
the system-wide file (if any), followed by the user's file. This
behavior made it difficult for the user to configure her environment if
she didn't want the default. Newer versions will ignore the system-wide
file if a personal configuration file exists.

# IMAGE TYPES

*Xloadimage* currently supports the following image types:

      Faces Project images
      GIF images
      Portable Bitmap (PBM) images
      Sun monochrome rasterfiles
      Sun color RGB rasterfiles
      X10 bitmap files
      X11 bitmap files
      X pixmap files
      G3 FAX images

Normal, compact, and raw PBM images are supported. Both standard and
run-length encoded Sun rasterfiles are supported. Any image whose name
ends in .Z is assumed to be a compressed image and will be filtered
through "uncompress".

# AUTHOR

    Jim Frost
    Saber Software
    jimf@saber.com

Other contributing people include Barry Shein (bzs@std.com), Kirk
Johnson (tuna@athena.mit.edu), Mark Snitily (zok!mark@apple.com), W.
David Higgins (wdh@mkt.csd.harris.com), and Dave Nelson
(daven@gauss.llnl.gov). The *next_slide* program and *-prog_slideshow*
option are by Rod Johnson, Entropic Research Laboratory
(johnson@wrl.epi.com).

# FILES

    xloadimage              - the image loader and viewer
    xsetbg                  - pseudonym which quietly sets the background
    xview                   - pseudonym which views in a window
    next_slide		- program to trigger advance to next slide
    /usr/lib/X11/Xloadimage - default system-wide configuration file
    ~/.xloadimagerc         - user's personal configuration file

# COPYRIGHT

Copyright (c) 1989, 1990 Jim Frost and others.

*Xloadimage* is copywritten material with a very loose copyright
allowing unlimited modification and distribution if the copyright
notices are left intact. Various portions are copywritten by various
people, but all use a modification of the MIT copyright notice. Please
check the source for complete copyright information. The intent is to
keep the source free, not to stifle its distribution, so please write to
me if you have any questions.

# BUGS

Zooming dithered images, especially downwards, is UGLY.

Images can come in a variety of aspect ratios. *Xloadimage* cannot
detect what aspect ratio the particular image being loaded has, nor the
aspect ratio of the destination display, so images with differing aspect
ratios from the destination display will appear distorted. See *HINTS
FOR GOOD IMAGE DISPLAYS* for more information.

The GIF format allows more than one image to be stored in a single GIF
file, but *xloadimage* will only display the first.

Only PseudoColor, GrayScale, StaticColor, and StaticGray visuals are
supported. These are the most common visuals so this isn't usually a
problem.

You cannot load an image onto the root window if the default visual is
not supported by *xloadimage*.

One of the pseudonyms for *xloadimage*, *xview*, is the same name as Sun
uses for their SunView-under-X package. This will be confusing if you're
one of those poor souls who has to use Sun's XView.

Some window managers do not correctly handle window size requests. In
particular, many versions of the twm window manager use the MaxSize hint
instead of the PSize hint, causing images which are larger than the
screen to display in a window larger than the screen, something which is
normally avoided. Some versions of twm also ignore the MaxSize
argument's real function, to limit the maximum size of the window, and
allow the window to be resized larger than the image. If this happens,
*xloadimage* merely places the image in the upper-left corner of the
window and uses the zero-value'ed pixel for any space which is not
covered by the image. This behavior is less-than-graceful but so are
window managers which are cruel enough to ignore such details.

The order in which operations are performed on an image is independent
of the order in which they were specified on the command line. Wherever
possible I tried to order operations in such a way as to look the best
possible (zooming before dithering, for instance) or to increase speed
(zooming downward before compressing, for instance).
