# NAME

exv_bbox - create panel with arbitrary screen buttons

# SYNOPSIS

    #include <stdio.h>
    #include <esps/esps.h>
    #include <esps/exview.h>

    extern int debug_level;

    bbox_par 
    *exv_bbox(bbox_params, bbox_frame, bbox_panel)
    bbox_par *bbox_params;
    Frame *bbox_frame;
    Panel *bbox_panel;

# DESCRIPTION

*exv_bbox* is a general function for creating an XView panel containing
screen buttons. The button labels can be specified by a list of button
titles, by an *olwm*(1) menu file, or by both. The action to take on
button selection is determined by an arbitrary data string associated
with each button, and by a user-defined function that is called to
operate on the string when the button is pressed. A default function is
available to *exec* the string (i.e., by default, it is assumed that the
string is an executable *unix* command). If button labels are specified
by a list of button titles, a list of corresponding button data strings
must also be provided. For button labels specified by an *olwm* menu
file, the button data strings are also taken from the menu file (as
further described below).

Input parameters are specified to *exv_bbox* by means of a structure
with the following definition:


    typedef struct _bbox_par {
    	char **but_labels;	/* button labels */
    	char **but_data;	/* button data strings */
    	char *menu_file;	/* olwm menu file name */
    	void (*but_data_proc)();	/* execution function for button data strings */
    	int quit_button;	/* if true, include QUIT button on panel */
    	char *quit_label;	/* if non-NULL, name for QUIT button */
    	char *quit_data;	/* QUIT button data string */
    	void (*quit_data_proc)();	/* execution function for QUIT data data */
    	int n_per_row;	/* number of buttons per row */
    	int button_choice;	/* if true, show submenus as panel choice 
    		items instead of button menus */
    	int choice_horizontal;	/* if true, panel choice items are 
    		displayed horizontally */
    	Frame owner;	/* owner of button panel (may be NULL) */
    	char *title;	/* title for button panel window */
    	char *icon_title;	/* icon title for button panel window */
    	int show;	/* if true, set XV_SHOW for frame containing panel */
    	int x_pos;	/* if positive, sets x position of new frame */
    	int y_pos;	/* if positive, sets y position of new frame
    	*/
    } bbox_par;

User programs need not (and should not) allocate space for variables of
type *bbox_par*, because if *exv_bbox* is called with the parameter
*bbox_params* == NULL, by convention it returns a pointer to an
allocated *bbox_par* structure initialized with default values. See the
EXAMPLES section. If *bbox_params* != NULL, *exv_bbox* returns a pointer
to this input parameter structure.

The button panel created by *exv_bbox* is returned via the parameter
*bbox_panel* (i.e., \**bbox_panel* is set to the new panel). Prior to
the return, the panel is fit to its natural size using the XView
function *window_fit*. If exv_bbox is not successful in creating a
button panel \**bbox_panel* is set to NULL.

# INPUT PARAMETERS AND DETAILED DESCRIPTION

As mentioned above, input parameters for *exv_bbox* are provided via the
function parameter *bbox_params*. If *bbox_params* == NULL, *exv_bbox*
returns a default parameter structure. Here is a discussion of the
various structure components:

**but_labels**  
This is a NULL-terminated string array (e.g., such as created via
*atoarrays* (3u-ESPS) or *addstr* (3u-ESPS)). Each string
*but_labels\[i\]* is used as the label for one button, provided that
*but_data\[i\]* contains a corresponding data string. If *but_labels* is
NULL or empty (*but_labels*\[0\] == NULL), or if *but_data* does not
contain corresponding data strings, then buttons are generated only from
*menu_file*. If buttons cannot be generated either from *but_labels* or
from *menu_file*, \*bbox_panel is set to NULL and *exv_bbox* returns the
input parameter structure. The default value for *but_labels* is (char
\*\*) NULL.

**but_data**  
This is a NULL-terminated string array containing a data string
*but_data\[i\]* for each button whose label was specified by
*but_labels*. When such a button *i* is pressed, a button execution
function is invoked on the string *but_data\[i\]*. If the caller of
*exv_bbox* does not provide such an execution function via the parameter
structure component *but_data_proc*, a default procedure runs
*exec_command* (3-ESPS) on the data string to *exec* it as a *unix*
command. The default value for *but_data* is (char \*\*)NULL.

**menu_file**  
This is the name of an ASCII file that is assumed to contain a menu
specification in the format as menu files for the OPEN LOOK window
manager *olwm* (same as *sunview* menu files). If submenus are
specified, how they are treated depends on *button_choice*. If
*button_choice* == 0, the submenus result in menu buttons with pull-down
menus (if a DEFAULT is specified, it becomes the default selection in
the pull-down menu). If *button_choice* == 1, each submenu results in a
set exclusive panel choice buttons (if a DEFAULT is specified, the
corresponding button comes up depressed); the buttons are displayed
vertically or horizontally, depending respectively on whether
*choice_horizontal* is 0 or 1. The default value for *menu_file* is
(char \*) NULL. The default value for *button_choice* is 0 (menu
buttons). The default value for *choice_horizontal* is 0 (vertical
choice buttons).

The simplest case for *menu_file* is a file with two columns - the
button labels are taken from the first column and the corresponding
button data strings (commands, in the default case) are taken from the
second column. If blanks are needed in the button labels, use quotes to
surround the string in the first column. Do not use quotes in the
command string unless they are part of the command (you may have to
escape them). More complicated cases can be created using the full
syntax of *olwm*(1) menu files. The only restriction is that there can
only be one level of submenus - i.e., each entry in the *menu_file* can
itself specify a menu (either directly or by giving the full path to
another menu file), but the specified submenu cannot have additional
submenus. Also, while the *olwm* command keyword DEFAULT is handled,
others (PROPERTIES, REFRESH, FLIPDRAG, etc.) are treated as ordinary
strings by *mbuttons*. For details about the format of menu files, see
*olwm*(1) - the manual page is included in the ESPS distribution. Also,
see *mbuttons*(1-ESPS) for example menu files.

**button_choice**  
If a *menu_file* is used, this parameter determines whether submenus are
displayed as menu buttons with pull-down menus (*button_choice* == 0) or
as a set of exclusive panel choice buttons (*button_choice* == 1). The
default is 0.

**choice_horizontal**  
If a *menu_file* is used and submenus are displayed as exclusive panel
choice buttons (*button_choice* == 1), this determines whether the
buttons are laid out vertically (*choice_horizontal* == 0) or
horizontally (*choice_horizontal* == 1). The default is 0.

**but_data_proc**  
This is a function pointer to a button execution function that is to be
called when any button is pressed or (when a button menu item is
selected). Any such button execution function must have the following
synopsis:

<!-- -->


      void
      exec_data(data_string, button)
      char *data_string;
      Panel_item button;

The argument data_string is the button data string from the button that
was pressed. The argument *button* is an XView handle for the button
that was pressed. If *but_data_proc* == NULL, a default function is
called; it ignores the argument *button* and invokes the function
*exec_command*(3-ESPS) on *data_string*. User-supplied functions for
*but_data_proc* might use the parameter *button* for such actions as
greying out the button or busying out the window while certain
operations take place. Note that a handle to the panel containing the
button can be obtained via *xv_get(button, XV_OWNER)*, that a handle to
the button's label can be obtained via *xv_get(button,
PANEL_LABEL_STRING)*, etc.

> By default, *but_data_proc* points to the default function described
> above (i.e., this is the value in the default structure returned by
> *exv_bbox* when *bbox_params* == NULL). However, the default function
> will also be invoked if the parameter structure is passed with
> *but_data_proc* == NULL.

**quit_button**  
If non-zero, *quit_button* specifies that there be a "QUIT" button that
precedes the buttons specified by *but_labels*, *but_data*, and
*menu_file*. The default value for *quit_button* is 0 (no quit button).
If the *unix* environment variable BBOX_QUIT_BUTTON is defined, this
forces *exv_bbox* to add a "QUIT" button even if *quit_button* is 0. The
main reasons for providing global control via BBOX_QUIT_BUTTON is to
facilitate usage on systems with window managers that do not provide an
independent means for killing windows.

**quit_label**  
If a quit button is specified (see above, *quit_label* is the label used
for the button. The default is "QUIT".

**quit_data**  
If there's a QUIT button (see above), this string is associated with it
(and executed by *quit_data_proc* when the QUIT button is pressed).

**quit_data_proc**  
This is a function pointer to an execution function that is to be called
when the QUIT button is pressed (if the button is present). Like the
*but_data_proc*, the *quit_data_proc* must have the following synopsis:

<!-- -->


      void
      exec_data(data_string, button)
      char *data_string;
      Panel_item button;

If called, it is called with *data_string* given by *quit_data* (see
above). The argument *button* is an XView handle for the QUIT button
that was pressed. If *quit_data_proc* == NULL, a default function is
called; it ignores the argument *button* and invokes the function
*exec_command*(3-ESPS) on *quit_data*. Note that a handle to the panel
containing the button can be obtained via *xv_get(button, XV_OWNER)*.

> By default, *quit_data_proc* points to the default function described
> above (i.e., this is the value in the default structure returned by
> *exv_bbox* when *bbox_params* == NULL). However, the default function
> will also be invoked if the parameter structure is passed with
> *quit_data_proc* == NULL.

**n_per_row**  
Specifies the number of buttons per row in the button panel, which
provides control over the approximate geometry of the button panel. For
example, if *n_per_row* == 1, the result is a single column of buttons.
The default setting is *n_per_row* == 10. The optional quit button is
excluded from this control over the geometry; if a quit button is
included in the panel, it appears on a row by itself at the top of the
panel. Thus, a quit button may be added or removed (via user-level
command line options or via the environment variable BBOX_QUIT_BUTTON)
without affecting the layout of the other buttons (see *quit_button*).

**owner**  
If *owner* == NULL, *exv_bbox* creates a new Xview frame (complete with
default ESPS icon, and with optional frame positioning via *x_pos* and
*y_pos*) and then creates the button panel as a child of the new frame.
A handle to the new frame is returned via the *exv_bbox* parameter
*bbox_frame* (i.e., \**bbox_frame* is set to the new frame). If *owner*
!= NULL, the button panel is created as a child of *owner*; for
consistency, \**bbox_frame* is set to *owner*. In both cases, the new
button panel is returned by *exv_bbox* via the parameter *bbox_panel*
(i.e., \**bbox_panel* is set to the new panel). If the button panel was
not created successfully by *exv_bbox*, \**bbox_panel* is set to NULL.

**title**  
If *exv_bbox* creates a new frame (i.e., if *owner* == NULL), the new
frame's title is set to *title*. The default value for *title* is "ESPS
Button Panel".

**icon_title**  
If *exv_bbox* creates a new frame (i.e., if *owner* == NULL), the title
for the frame's icon is set to *icon_title*. The default value for
*title* is "buttons".

**show**  
If *exv_bbox* creates a new frame (i.e., if *owner* == NULL), then
*xv_set(\*bbox_frame, XV_SHOW, show, 0)* is executed before *exv_bbox*
returns. Thus, the new frame will be created as visible if *show* is
non-zero.

**x_pos**  
If *exv_bbox* creates a new frame (i.e., if *owner* == NULL), and if
both *x_pos* and *y_pos* are non-negative, then the x-position of the
new frame is set to *x_pos* (relative to the root window). **y_pos** If
*exv_bbox* creates a new frame (i.e., if *owner* == NULL), and if both
*x_pos* and *y_pos* are non-negative, then the y-position of the new
frame is set to *y_pos* (relative to the root window).

# EXAMPLES

As mentioned earlier, user programs need not (and should not) allocate
space for variables of type *bbox_par*, because if *exv_bbox* is called
with the parameter *bbox_params* == NULL, by convention it returns a
pointer to an allocated *bbox_par* structure initialized with default
values.


    	static void run_cmd_on_file();
    	bbox_par *bbox_params = NULL;
    	char **labels;
    	char **data_strings;
    	Frame frame;
    	Panel but_panel;	

    	. . .

    	/* get default parameter set for button box */

    	bbox_params = exv_bbox((bbox_par *)NULL, &frame, &but_panel);

    	/* change the relevant defaults */

    	bbox_params->n_per_row = 3;
    	bbox_params->but_labels = labels;
    	bbox_params->but_data = data_strings;
    	bbox_params->title = "Demo buttons";
    	bbox_params->quit_button = 0;	

    	/* create button box */

    	bbox_params = exv_bbox(bbox_params, &frame, &but_panel);

# ERRORS AND DIAGNOSTICS

If the global *debug_level* is non-zero, *exv_bbox* prints a variety of
messages useful for debugging; the larger the value of *debug_level*,
the more verbose the messages. If *exv_bbox* is unable to create a
button panel from the supplied parameters, it prints a message to stderr
before returning.

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

    addstr(3-ESPS), atoarrays(3-ESPS), 
    exec_command(3-ESPS), read_olwm_menu(3-ESPS), 
    print_olwm_menu (3-ESPS), mbuttons(1-ESPS), 
    fbuttons(1-ESPS)

# AUTHOR

program and man page by John Shore
