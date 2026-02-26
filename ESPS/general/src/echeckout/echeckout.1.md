# NAME

echeckout - checkout an ESPS license for a host

# SYNOPSIS

**echeckout** **\[-w\]**

# DESCRIPTION

*Echeckout*

checks out an ESPS license for the host on which this command is run.
Only one ESPS license needs to be checked out for a given host. This
version of the program does not check to see if another license is
already assigned to this host. You can check for this with *elmadmin
-l*.

The Unix environment variable, **ELM_HOST** must be set to contain the
name of the host on your network that the ESPS license manager daemon is
running on, unless it is running on the same host that you are checking
the license out on. In this case **ELM_HOST** can be undefined.

The license can be freed with the *efree* command by the same user that
checked it out. If it is necessary to free a license that was checked
out by another user, the super-user will have to find the process id of
the *echeckout* and kill that process.

# ESPS HEADERS

This program ignores all header items.

# ESPS PARAMETERS

This program does not access the parameter file.

# OPTIONS

The following options are supported:

**-w**  
Causes *echeckout* to emit an hourly reminder that an ESPS license is
checked out. This message goes to the standard error for the tty or
window first running *echeckout*. In some cases, the warning message
might end up on an unrelated device after the initial user logs out.

# SEE ALSO

    efree(1-ESPS), elmd(1-ESPS), elmadmin(1-ESPS), 
