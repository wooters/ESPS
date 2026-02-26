# NAME

    exv_get_help - creates XView frame containing text of man page or help file

    exv_helpfile - return file name containing cleaned man page or plain text

    exv_make_text_window - create XVIEW frame containing text of ASCII file

# SYNOPSIS

    #include <stdio.h>
    #include <esps/esps.h>
    #include <esps/exview.h>

    extern int debug_level;
    extern int do_color; 

    int
    exv_get_help(item, event)
    Panel_item	item;
    Event           *event;  

    char *
    exv_helpfile(progfile)
    char *progfile;

    Frame
    exv_make_text_window(owner, window_title, icon_title, textfile, find, indep)
         Frame owner;		/* owning frame (may be NULL)*/
         char *window_title;	/* text window title */
         char *icon_title;		/* icon title (for independent windows)*/
         char *textfile;		/* text file */
         int  find;			/* whether or not to have find button */
         int indep;			/* if true, FRAME, else FRAME_CMD */

# DESCRIPTION

*exv_get_help* is a utility PANEL_NOTIFY_PROC suitable as a "Help"
button callback procedure, i.e., for creating help windows in ESPS XView
programs. The function creates and displays a help window containing the
contents of an ASCII help file or unix-style man page. The resulting
XView FRAME is returned by the function. The owner of the returned frame
is the frame containing the button that invokes *exv_get_help*.

*exv_get_help* assumes that an ASCII string is passed via the key
EXVK_HELP_NAME; this item should be set set by the calling program to
contain either the name of an ESPS program (for which the man page is
desired) or the name of a pure-ASCII help-file. If the string contains a
path specification (i.e., if it contains "/"), *exv_get_help* assumes
that the string contains a help file rather than the name of an ESPS
program. In the former case, *exv_get_help* just pops up a help window
(complete with "Search Forward", "Search Backward", and "Quit" buttons)
and returns its handle. In the latter case, *exv_get_help* runs *eman*
(1-ESPS) on the name, cleans the output with an *sed*() script, and pops
up a help window containing the cleaned text (again, complete with
"Search Forward", "Search Backward", and "Quit" buttons). In this case,
the temporary file containing the cleaned man page entry will be deleted
after the help-window is destroyed.

*exv_get_help* also assumes that a window title is passed via the key
EXV_HELP_TITLE and uses this in creating the help frame. If no such
title is passed, a default of "ESPS Help Window" is used. In both cases,
the window is given a standard ESPS icon with icon title set to "help".

The function *exv_helpfile* is used by *exv_get_help* to clean the man
page. If *progfile* contains a path specification (i.e., if it contains
"/"), a copy of the string *progfile* is returned by *exv_helpfile*.
Otherwise, *exv_helpfile* assumes that *progfile* is the name of an ESPS
program. It runs *eman* on *progfile*, cleans the output with a suitable
*sed* script, and returns the name of a temporary file containing the
cleaned text.

Much of the work needed for *exv_get_help*() is performed by
*exv_make_text_window*, which is generally useful for displaying the
contents of an ASCII file and allowing the user to browse through it. In
particular, *exv_make_text_window* creates a window containing the
contents of *textfile*, displays it, and returns it's handle to the
calling program. The frame's owner is set to *owner*, with the window
and icon titles set respectively to *window_title* and *icon_title*. The
icon used is a standard ESPS icon, as created by *exv_attach_icon*
(3-ESPSxu). If *indep* is set to USE_FRAME_INDEP, the new frame has no
owner. Otherwise (USE_FRAME_CMD), the new frame is created as a command
frame with a push-pin (FRAME_CMD) and the owner is set to *owner*.

IF *find* == WITH_FIND_BUTTON, the help frame created by
*exv_make_text_window* will have a button panel containing "Quit",
"Search Forward", and "Search Backward" buttons. Otherwise
(WITHOUT_FIND_BUTTON), the frame will just contain *textfile*.

# EXAMPLES



      Panel_item button;		
      Frame help_win, prog_frame; 
      char *title, *helpfile, *help_title, *helpname

      if (helpname != NULL) {
        button = xv_create(con_panel, PANEL_BUTTON,
    		       XV_KEY_DATA, EXVK_HELP_TITLE,  help_title,
    		       XV_KEY_DATA, EXVK_HELP_NAME, helpname,
    		       PANEL_LABEL_STRING,  "Help",
    		       PANEL_NOTIFY_PROC,   exv_get_help,
    		       NULL);
       }

       . . . 

       help_win = exv_make_text_window(prog_frame, title, "help", helpfile, 
    				WITH_FIND_BUTTON, USE_FRAME_CMD);

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

# BUGS

The algorithm for cleaning man pages doesn't work on HP300 and Masscomp
systems.

# REFERENCES

# SEE ALSO

*e_temp_name* (3-ESPSu), *exv_attach_icon* (3-ESPSxu)

# AUTHOR

Program and man page by John Shore. Program improvements by Alan Parker
