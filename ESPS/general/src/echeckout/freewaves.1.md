# NAME

freewaves - free a Waves+ License held by a lost Waves

# SYNOPSIS

**freewaves**

# DESCRIPTION

*freewaves*

releases a *waves+* license if one is held by the user that runs this
program. This is intended to be used to release a license that is held
by a zombied *waves+*, or to release a stuck license if *waves+* exits
abnormally. While this program could be used to release a license being
held by a *waves+* process while it is running, if another *waves+* is
started that causes the number of *waves+* in use to exceed the total
number of licenses, then one of the *waves+* will be terminated due to
its losing its license.

Note that if a license is held by a zombied or dead process it is
released by the license manager within 60 seconds (at least that is the
way the system is designed to work).

# ESPS HEADERS

This program ignores all header items.

# ESPS PARAMETERS

This program does not access the parameter file.

# OPTIONS

None.

# SEE ALSO

*elmd*(1-ESPS), *elmadmin*(1-ESPS)
