# EINFO

    einfo - tool for reading Entropic technical and release notes. 
    winfo - tool for reading Entropic waves+ technical and release notes. 

# SYNOPSIS

**einfo** documentnumber\
**winfo** documentnumber

# DESCRIPTION

Program *einfo* (or *winfo*) is a tool for reading Entropic technical
bulletins and release notes. We wrote this program to make it easier to
disseminate new information to the users, and to save tons of paper in
shipments.

If the X11 window system is running then *einfo* will pop up a control
panel with the names of the documents that you can read listed as
buttons of the panel. Just click on the document to read it.

If the X11 window system is NOT running then *einfo* will list every
document it knows about. Type "einfo documentnumber" to view the desired
document.

# EXAMPLES


    # X11 not running example
    %einfo
                    List of ESPS/waves+ Documents

    		1  XView Fonts
    		2  ESPS Release Notes
    		3  waves+ Release Notes
    		4  Installation Instructions
    		5  ESPS Tech Notes
    		6        Introduction to ESPS
    		7        Parameter Files
    		8        File Conversions

    		To view one or more of these: einfo number

    %einfo 3

# BUGS

None known.

# SEE ALSO

**eman(1-ESPS)** , **elogo(1-ESPS)**

# AUTHOR

Ken Nelson, John Shore
