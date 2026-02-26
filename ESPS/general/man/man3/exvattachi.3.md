# NAME

    exv_attach_icon -  attaches one of a number of available XView to frame. 

# SYNOPSIS

    #include <stdio.h>
    #include <esps/esps.h>
    #include <esps/exview.h>
    #include <xview/cms.h>

    extern int debug_level;
    extern int do_color; 

    Icon
    exv_attach_icon(frame, icon_id, label, trans)
    Frame frame;			/* frame to which epi icon gets attached */
    int  icon_id;			/* indicates which icon is wanted */
    char *label;			/* text label for icon*/
    int  trans;			/* flag for transparent icon */

# DESCRIPTION

*exv_attach_icon* attaches one of a number of available XView icons to
*frame*. The icon's title is set to *label*, and it is created with a
transparent background if *trans* is non-zero. The icon is returned by
the function; NULL is returned if the icon could not be created. The
choice of icon is determined by *icon_id*, with these currently
available:


        ERL_BORD_ICON	Standard ESPS icon with border
        ERL_NOBORD_ICON	Standard ESPS icon without border
        HIST_ICON	Histogram icon
        IMAGE_ICON	Shaded rectangle icon (used by image (1-ESPS)
        SINE_ICON	Sinusoid icon (generic waveform)
        SPEC_ICON	Spectral slice icon (generic smooth spectrum) 
        P3D_ICON	3D plot icon (used by plot3d (1-ESPS)

# EXAMPLES


      Frame frame; 

      (void) exv_attach_icon(frame, ERL_NOBORD_ICON, "params", TRANSPARENT);

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

Additional icons.

# BUGS

None known

# REFERENCES

# SEE ALSO

*exv_get_help* (3-ESPSxu), *exv_make_text_window* (3-ESPSxu)

# AUTHOR

Program and man page by John Shore.
