# NAME

decrecord - mono or stereo record to disk

# SYNOPSIS

**decrecord** \[ **-s** *duration_to_record* \] \[ **-f** *sample_rate*
\] \[ **-c** *number_of_channels* \] \[ **-S** \] \[ **-P** \]
*filename*

# DESCRIPTION

*decrecord* provides mono or stereo sampling at selected rates up to
48kHz when recording to local disk. Direct recording onto network disks
is often feasible as well. Output files have ESPS FEA_SD headers.
*Decrecord* has special adaptations that permit display of the recorded
file in *xwaves* (see -S option below).

This program is for the DEC Alpha with multimedia extensions. To be more
precise, the DEC utility audiorecord must exist, because
*decrecord*(1-ESPS) is simply a wrapper around it. The DEC supplied
audio capabilities are typically in /usr/bin/mme.

Use the DEC tool "audiocontrol" in the DEC multimedia extensions kit to
set the input and output controls (level, balance, port).

# OPTIONS

The following options are supported:

**-s** *duration* **\[5\]**  
Specifies the maximum duration of the recording session in seconds. Note
that the record duration is specified as an integer, and truncation of
the value takes place if specified as a non-integer. (That is, *-s 1.9*
gets interpreted as record for 1 second.)

**-f** *frequency* **\[8000\]**  
Specifies the sampling frequency. Only a limited set of sample rates are
available: 8000, 11025, 16000, 22050, 32000, 33075, 44100, and 48000.
Specifying a value other than one of these is an error.

**-c** *channel* **\[1\]**  
By default *decrecord*(1-ESPS) samples and stores single-channel data
from the left channel. Dual-channel (stereo) recording is selected by
setting *channel* to 2. When stereo recording is selected channels 0 and
1 alternate in the file, with channel 0 being first.

**-S**  
This option enable the *xwaves* (1-ESPS) "make" command via
*send_xwaves* (1-ESPS) after the requested recording time has elapsed.
This permits immediate examination of the recorded passage using
*xwaves* (1-ESPS).

**-P**  
This option enable shell prompting for the start of recording.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# WARNINGS

decrecord does not work if another process has control of the audio
device, such as DECsound (decsound) or the VU meter of Audio Control.
You will get the following errors

        
        audiorecord: <error> Error opening Wave device
        audiorecord: <error> Unsupported wave format

The maximum rate over the network is unpredictable in general, but we
routinely achieve 16kHz stereo at Entropic Research Laboratory. Of
course rate limitations due to network speed will be less severe for
single-channel recording.

# FILES

# BUGS

# SEE ALSO

*copysd*(1-ESPS), *decplay* (1-ESPS), *sfconvert* (1-ESPS)

# AUTHOR

David Burton
