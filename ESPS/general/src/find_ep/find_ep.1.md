# NAME

find_ep - analysis to locate endpoints of a speech segment in a waveform
file

# SYNOPSIS

**find_ep** \[ **-b** *adbits* \] \[ **-c** *context* \] \[ **-e** \] \[
**-f** *final_thresh* \] \[ **-h** *high_thresh* \] \[ **-l**
*low_thresh* \] \[ **-n** \] \[ **-p** *start_point* \] \[ **-r**
*start_point* \] \[ **-s** *silence_req* \] \[ **-t** *time* \] \[
**-w** \] \[ **-x** *debug_level* \] \[ *infile.sd* \] \[ *outfile.sd*
\]

# DESCRIPTION

*Find_ep* uses thresholds to find isolated words or connected segments
of speech in a sampled-data file (FEA_SD(5-ESPS)) and sets *start* and
*nan* in ESPS Common to point to the beginning and end of the selected
utterance. These thresholds may be set by the user (via the **-l**,
**-h**, and **-f** options), or default values may be computed by the
program. If neither **-p** (or **-r**) nor **-n** is given, *find_ep*
starts computing statistics at the beginning of the sampled-data file.
If a *start_point* is given, *find_ep* starts there for determining
thresholds, but starts looking for words *silence_req* milliseconds
later in the file. If the **-n** option is set, *find_ep* looks in ESPS
Common for *start* and *nan* and starts processing the input file
(computing thresholds) 50 milliseconds beyond the point *start + nan*.

In brief, *find_ep* determines the endpoints of an utterance by moving
through the file in *context* millisecond chunks of speech. In each
*context* chunk, *find_ep* compares the average adjusted magnitude (AAM)
with one of the three thresholds. (See \[1\] for a definition of AAM.)
Once the AAM has exceeded the *low_thresh* and then the *high_thresh*,
and it has subsequently fallen below the *final_thresh* and remains
below the *low_thresh* for *time* milliseconds, *find_ep* declares that
a utterance has been detected.

*Find_ep* implements a heuristic method for detecting the beginning and
ending points of speech in low to moderate background noise
environments. It is not perfect, but it is often useful for finding
isolated words or segments of continuous speech.

By default, *find_ep* writes no output file; it simply updates *start*
and *nan* in common. If a sampled-data file containing only the selected
points is desired, the **-w** should be used and an output sampled-data
file name (*outfile.sd*) should be specified on the command line. This
will result in a new file that contains only the points between *start*
and *start* + *nan* -1 from the input sampled-data file (*i.e.* the
points selected by *find_ep*).

If *infile.fea* is equal to "-" and the **-n** option is not used, then
standard input is used.

# OPTIONS

**-b** *adbits* **\[12\]**  
Set the number of bits that were used by the A/D converter to record the
data. It is important to do this correctly. This number is used to scale
all the thresholds. If the data was not taken directly from an A/D
converter, try setting this value to the number of bits used in the
original A/D conversion. You may have to adjust this value in order to
get *find_ep* to work reliably, however.

**-c** *context* **\[10\]**  
The time interval in milliseconds that is used for computing AAM. Note:
*silence_req* and *time* will be rounded to an even multiple of
*context*.

**-e**  
If this option is set, *Possible word at end of file* is not considered
an error. A warning message is written to *stderr*, but *start* and
*nan* are set to the start of the word and the end of file respectively.

**-f** *final_thresh*  
Average magnitude threshold for the end of a word. The default value is
.8\**low_thresh*. Note *final_thresh* must be less than *low_thresh*.

**-h** *high_thresh*  
The second threshold that the potential speech utterance must exceed
before a speech utterance is detected. The default value is
4\**low_thresh*.

**-l** *low_thresh*  
Initial average magnitude threshold for detecting the start of an
utterance. A default value may be computed by the program from the
statistics of the first *time* milliseconds of data.

**-n**  
Get the next speech utterance after the current range as specified in
ESPS Common. If **-n** is given, **-p** and **-r** are ignored.

**-p** *start_point* **\[1\]**  
**-p** is a synonym for **-r**.

**-r** *start_point* **\[1\]**  
The starting point in the sampled-data file may be specified. Note that
this starting point is for computing statistics for threshold
computation. If *low_thresh* is manually set (**-l**), then the starting
point is for finding speech - that is, no data is used for computing
thresholds.

**-s** *silence_req***"***\[200\]*  
This is the time in milliseconds required to mark the end of an
utterance, and it is the time period required between adjacent
utterances in a single sampled-data file. Values below 150 milliseconds
are not recommended, but the only enforced lower bound is *context.*

**-t** *time* **\[*silence_req* - 50\]**  
The number of milliseconds of data used to compute thresholds. This is
ignored if *low_thresh* is supplied.

**-w**  
Write the selected segment of speech to the output sampled-data file
(*outfile.sd*). An output file name needs to be specified only if this
option is set.

**-x** *debug_level* **\[0\]**  
Values greater than 0 cause messages to print to stderr.

# ESPS PARAMETERS

The PARAMS file is not processed.

# ESPS COMMON

If no input file name is supplied, *find_ep* looks in ESPS Common for
the input file name. If **-n** is specified, *find_ep* checks the input
file name with that in Common, and if they are consistent, *find_ep*
determines the starting point by using the Common values for *start* and
*nan*. Finally, the Common values for *start* and *nan* are always
updated by *find_ep*.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

If the **-w** option is specified, values in the header of *outfile.sd*
are copied from the values in the header of *infile.sd.* In addition,
the generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the starting point of the word boundry.

# FUTURE CHANGES

Have parameters read from a parameter file.

# WARNINGS

*Find_ep* warns and exits if the input file is not a FEA_SD (or old
style SD) file, if the starting point is not in the file, or if the end
of file is encountered.

# EXAMPLE

This example uses the defaults and writes out a file *utterance.sd*
which contains the utterance extracted from the file *file.sd*. File
*file.sd* contains the utterance and surrounding silence, while
*utterance.sd* contains only the utterance. The flag -b signifies that
the file was digitized with 16-bit resolution.


             %find_ep -b 16 -w file.sd utterance.sd

# SEE ALSO

copysd(1-ESPS)

# BUGS

None known.

# REFERENCES

\[1\] L. Rabiner and M. Sambur, "An Algorithm for Determining the
Endpoints of Isolated Utterances," *Bell. Syst. Tech. J.*, Vol. 54, pp.
297-315, Feb. 1975

\[2\] L. Lamel *et. al.*, "An Improved Endpoint Detector for Isolated
Word Recognition," *IEEE Trans. Acoustics, Speech, and Signal
Processing*, vol. ASSP-29, pp. 777-785, Aug. 1981

# AUTHOR

Manual page by David Burton; code by David Burton.
