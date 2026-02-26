# NAME

decplay - send sampled data (PCM) to DEC Alpha audio device

# SYNOPSIS

**decplay** \[ **-r** *sample_range* \] \[ **-S** *time_range* \] \[
*file1* \[ *file2 ...* \] \]

# DESCRIPTION

*decplay* sends all or a portion of one or more ESPS sampled data files
(or files with ESPS default headers defined) to the audio device of a
DEC Alpha.

This program is for the DEC Alpha with multimedia extensions. To be more
precise, the DEC utility audioplay must exist, because *decplay*(1-ESPS)
is simply a wrapper around it. The DEC supplied audio capabilities are
typically in /usr/bin/mme.

Use the DEC tool "audiocontrol" in the DEC multimedia extensions kit to
set the input and output controls (level, balance, port).

# OPTIONS

The following options are supported:

**-r** *sample_range*  
Select a subrange of points to be played, using the format *start:end*
or *start:+count*. Either the start or the end may be omitted; the
beginning or the end of the file are used if no alternative is
specified. To specify a range in seconds, use -S (see below) instead of
-r. -r may not be used with -S.

**-S** *time_range*  
Select a subrange of the file to be played, using the format
*start_time:end_time* or *start_time:+time_incr.* Either the start or
the end may be omitted; the beginning or the end of the file are used if
no alternative is specified. To specify a range in seconds, use -S (see
below) instead of -r. -r may not be used with -S.

-S is similar to -r, except that the range limits are interpreted as
times (in seconds). If start_time is omitted, it is set to the value of
the start_time generic header item. If end_time is omitted, it is set to
the time corresponding to the end of the file. No more than one of the
options -r and -S should be used.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. See *copysd*(1-ESPS) for further
details.

# WARNINGS

decplay does not work if another process has control of the audio
device, such as DECsound (decsound) or the VU meter of Audio Control.
You will get the following errors

        
        audioplay: <error> Error opening Wave device
        audioplay: <error> Unsupported wave format

    Only a limited set of sample rates are available:
    8000, 11025, 16000, 22050, 32000, 33075, 44100, and 48000.
    Specifying a value other than one of these is an error.

# FILES

# BUGS

# SEE ALSO

*copysd*(1-ESPS), *decrecord* (1-ESPS), *sfconvert* (1-ESPS)

# AUTHOR

Alan Parker, man page by Gayle Ayers Elam.
