# wsystem

    wsystem - outputs the type of window system available to stdout.

# SYNOPSIS

**wsystem**

# DESCRIPTION

**Wsystem** tells you what window system is available. It first checks
to see if Sunview is available. If Sunview and X-Windows is available at
the same time then X11R2000 (the Openwindow server release) is returned.
If not it checks for X-Windows. If X is available it outputs "X11Rx",
where x is the release of X that is running. For example, X11R4, X11R3,
etc...

If Suntools only is present and it outputs "Sunview".

If no windowing system is present, then it outputs "none".

# OPTIONS

No options.

# FUTURE CHANGES

Add some options to say what Window manager, or which server.

# EXAMPLES


      echo `wsystem`
      case `wsystem` in
        X11R2) oldxtool;;
        X11*)  xtool;;
        Sunview) sunviewtool;;
        none) echo "error: no windowing system available";;
      esac

# ERRORS AND DIAGNOSTICS

Exit status of 0 if a window system is found. Exit status of 1 if no
window system is found.

# BUGS

None known.

# REFERENCES

# SEE ALSO

X(1), suntools(1)

# AUTHOR

Ken Nelson
