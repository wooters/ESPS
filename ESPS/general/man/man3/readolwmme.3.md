# NAME

    read_olwm_menu - read a menu file in OPEN LOOK window manager (olwm) format
    print_olwm_menu - print a menu file read by read_olwm_menu

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/exview.h>

    menudata *
    read_olwm_menu(menu_file)
    char *menu_file;

    void
    print_olwm_menu(men)
    menudata *men;

# DESCRIPTION

*read_olwm_menu* reads the file *menu_file* and assumes that it is an
ASCII file containing a menu specification in the format as menu files
for the OPEN LOOK window manager *olwm* (same as *sunview* menu files).
For details about the format of menu files, see *olwm*(1) - the manual
page is included in the ESPS distribution. The simplest case for
*menu_file* is a file with two columns - item names are taken from the
first column and the corresponding execution strings are taken from the
second column. If blanks are needed in the button labels, use quotes to
surround the string in the first column. Do not use quotes in the
execution strings unless they are part of the command (you may have to
escape them). More complicated cases (e.g., with submenus) can be
created using the full syntax of *olwm*(1) menu files.

*read_olwm_menu* returns a menu structure defined as follows (these are
the definitions from Sun's *olwm*):


    typedef struct {
    	char *title;
    	char *label;
    	int idefault;		/* index of default button */
    	int nbuttons;
    	Bool pinnable;
    	buttondata *bfirst;
    } menudata;

    typedef struct _buttondata {
    	struct _buttondata *next;
    	char *name;
    	Bool isDefault;
    	Bool isLast;
    	FuncPtr func;
    	char *exec;    /* string to be executed, like "xterm" */
    	void *submenu; /* this really is type menudata - js */
    	} buttondata;

The function *print_olwm_menu prints the names and execution strings*
from menus read by *read_olwm_menu.*

# EXAMPLES

*read_olwm_menu is used within exv_bbox to read the menu* file whose
name is passed to that routine. It is also used in *fbuttons (1-ESPS) to
read the menu passed via the* **-M** *option. For examples of simple
menu files, see* *mbuttons (1-ESPS).*

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

*olwm(1), (3xu-ESPS), exv_bbox (3xu-ESPS)*

# AUTHOR

program and man page by John Shore. This is little more than a cover
function for the *olwm function menuFromFile.*
