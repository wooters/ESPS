# NAME

v32record - mono or stereo record to disk or pipe for VME AT&T or
Heurikon Surf board with Ariel Pro Port

# SYNOPSIS

**v32record** \[ **-d** *duration* \] \[ **-f** *sample rate* \] \[
**-r** \] \[ **-s** \] *file*

# DESCRIPTION

*V32record* provides mono or stereo sampling at selected rates up to at
least 48kHz when recording to local disk. Direct recording onto network
disks is often feasible as well. Output files have ESPS FEA_SD headers.
Output may optionally be directed to *stdout*.

When stereo recording is selected (see the -s option) channels 0 and 1
alternate in the file, with channel 0 being first. Note that processes
consuming the output of *v32record* on a pipe must be able to keep up
with the average aggregate sampling frequency.

# OPTIONS

The following options are supported:

**-d** *duration***\[10\]**  
Specifies the maximum duration of the recording session in seconds.
Recording may be interrupted before this time expires with SIGINT. The
default *duration* is 10 seconds. The upper limit is set only by disk
space.

**-f** *frequency***\[16000\]**  
Specifies the sampling frequency. The closest frequency to that
requested will be selected from those available and the user will be
notified if the selected value differs from that requested. If -f is not
specified, the default sampling frequency of 16kHz is used (assuming the
standard Ariel crystal).

**-r**  
By default v32record samples and stores single-channel data from
channel A. Setting the **-r** option, causes v32record to record from
channel B.

**-s**  
This option enables dual channel recording.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# WARNINGS

The maximum rate over the network is unpredictable in general, but we
routinely achieve 16kHz stereo at Entropic Research Laboratory. Of
course rate limitations due to network speed will be less severe for
single-channel recording.

# FILES

**ESPS_BASE/32cbin/** the directory that contains the DSP32C board code.

# BUGS

There is currently no reliable notification in the event of loss of
realtime.

# EXPECTED CHANGES

Implement a locking mechanism to prevent collision of multiple
simultaneous attempts to use the Ariel board.

Implement a robust check for loss of real-time operation.

# SEE ALSO

SD (5-ESPS), *testsd* (1-ESPS), *copysd* (1-ESPS), *v32play* (1-ESPS),
*sfconvert* (1-ESPS)

# AUTHORS

David Talkin
