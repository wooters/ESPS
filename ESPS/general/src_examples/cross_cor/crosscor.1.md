# NAME

    cross_cor - Cross-Correlation of Sampled Data

# SYNOPSIS

**cross_cor** \[ **-l** *frame_len* \] \[ **-o** *range* \] \[
**-**{**pr**} ***range*** \] \[ **-w** *window_type* \]\
\[ **-x** *debug_level* \] \[ **-P** *param* \] \[ **-S** *step* \] \[
**-N** \] *input1.sd* *input2.sd* *output.fea*

# DESCRIPTION

*cross_cor* takes as input a pair of single-channel, real ESPS
sampled-data (SD or FEA_SD) files and produces an ESPS feature (FEA)
file as output. The program reads a set of fixed-length frames from the
first input file. For each such frame, it reads a corresponding frame
from the second input file (see -N option), computes the cross
correlation between the two frames at a fixed set of lags, and writes an
output record containing the cross-correlation values.

All input frames have the same length *frame_len* (see **-l** option).
The initial point of the first frame from *input1.sd* is a specified
point in the file (see **-p** option). Initial points of any subsequent
frames follow at equal intervals *step* (see **-S** option). Thus the 3
cases *step* \< *frame_len,* *step* = *frame_len,* and *step* \>
*frame_len,* correspond to overlapping frames, exactly abutted frames,
and frames separated by gaps. The initial point of the first frame from
*input2.sd* is a specified point in that file (see **-p** option), and
subsequent frames follow at the same spacing as in *input1.sd.* The
number of frames is the minimum sufficient to cover a specified range of
*nan* points (see **-p** option). The last frame in each file may
overrun the range, in which case a warning is printed. If a frame
overruns the end of a file, it is filled out with zeros.

The output file is not of any special feature-file subtype. It is not
tagged, but has two ordinary *long* scalar fields named "tag1" and
"tag2", which give the starting sample numbers of the frames from the
two input files. The cross-correlation values are stored in a *float*
vector field named "cross_cor" of length *maxlag* - *minlag* + 1 where
*minlag* and *maxlag* are the least and greatest lags for which the
cross correlation is computed. Values are stored for lags *minlag,* . .
. , 0, . . . , *maxlag* in that order.

The input files must be different. One of the input file names may be
replaced by \`-', indicating standard input. Likewise the output file
name may be replaced by \`-', indicating standard output.

# OPTIONS

The following options are supported:

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame. If the option is omitted, the
parameter file is consulted. A value of 0 (from either the option or the
parameter file) indicates that a single frame of length *nan* (see
**-p**) is processed; this is also the default value in case *frame_len*
is not specified either with the **-l** option or in the parameter file.

**-o** *minlag***:***maxlag* **\[-10:10\]**  
**-o** *minlag***:+***incr*  
The range of lags for which the cross correlation is computed. In the
first form of the option, a pair of integers specifies the first and
last lags of the range. If *maxlag* = *minlag* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If the
option is omitted, the parameter file is consulted, and if no value is
found there, the default range of -10 to 10 is used.

**-p** *first***:***last* **\[1:(last in file)\]**  
**-p** *first***:+***incr*  
Specifies the range of sampled data to analyze in each file. This option
may be specified at most twice. If it is omitted, the ranges are
determined by the parameters *start1,* *start2,* and *nan* if they are
present in the parameter file, and by default values for the parameters
if they are not present. If the option is specified once, it applies to
both input files. If it is specified twice, the first instance applies
to *input1.sd* and the second to *input2.sd.* If the option is specified
twice, and the two range specifications imply different values of *nan,*
the smaller is used. In the first form of the option, a pair of unsigned
integers specifies the first and last samples of the range to be
analyzed. If *last* = *first* + *incr,* the second form (with the plus
sign) specifies the same range as the first. If *first* is omitted, the
default value of 1 is used. If *last* is omitted, the default is the
last sample in the file.

**-r** *first***:***last*  
**-r** *first***:+***incr*  
The **-r** option is synonymous with **-p**.

**-w** *window_type***\[RECT\]**  
The name of the data window to apply to the data. If the option is
omitted, the parameter file is consulted, and if no value is found
there, the default used is a rectangular window with amplitude one.
Possible window types include rectangular ("RECT"), Hamming ("HAMMING"),
Hanning ("HANNING"), cosine to the fourth power ("COS4"), and triangular
("TRIANG"); see the manual page for window(3-ESPSsp) for the complete
list.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

**-P** *param* **\[params\]**  
The name of the parameter file. The default name is "param". The
parameter file is optional (see ESPS Parameter).

**-S** *step* **\[***frame_len***\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted, the parameter file is consulted, and if no
value is found there, a default equal to *frame_len* is used (resulting
in exactly abutted frames).

**-N**  
If this option is used a single frame is read from *input2.sd.* Frames
are read from *input1.sd* as described above and for each of them a
single correlation (of lag 0) with the fixed frame of *input2.sd* is
computed. The default value of *frame_len* is the length of *input2.sd*
and the default value of *step* is then *frame_len.* Note that there
must be at least as many records in *input1.sd* as in *input2.sd.*

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
values for all parameters. If the file exists, the following parameters
may be read if they are not determined by command-line options.

*frame_len - integer*  
The number of points in each frame. This parameter is not read if the
**-l** option is specified. A value of 0 indicates that a single frame
of length *nan* (see below) is processed; this is also the default value
in case *frame_len* is specified neither with the **-l** option nor in
the parameter file.

*nan - integer*  
The total number of points to process. This parameter is not read if the
**-p** option is specified. If the option is not specified and the
parameter is not present, the default used is the length of a range
extending either from *start1* to the end of *input1.sd* or from
*start2* to the end of *input2.sd,* whichever is shorter.

*minlag - integer*  
The first lag for which the cross correlation is computed. This value is
not read if the command-line option **-o** is specified. If the option
is omitted and no value is found in the parameter file, a default of -10
is used.

*maxlag - integer*  
The last lag for which the cross correlation is computed. This value is
not read if the command-line option **-o** is specified. If the option
is omitted and no value is found in the parameter file, a default of 10
is used.

*start1 - integer*  
The first point from the input file *input1.sd* that is processed. A
value of 1 denotes the first sample in the file. This parameter is not
read if the **-p** option is specified. A default value of 1 is used if
the option is not specified and the parameter is not present.

*start2 - integer*  
The first point from the input file *input2.sd* that is processed. A
value of 1 denotes the first sample in the file. This parameter is not
read if the **-p** option is specified. A default value of 1 is used if
the option is not specified and the parameter is not present.

*step - integer*  
Initial points of consecutive frames differ by this number of samples.
This parameter is not read if the **-S** option is specified. If the
option is omitted and no value is found in the parameter file, a default
equal to *frame_len* is used (resulting in exactly abutted frames).

*window_type - string*  
The data window to apply to the data. This parameter is not read if the
command-line option **-w** is specified. If the option is omitted and if
no value is found in the parameter file, the default used is "RECT", for
a rectangular window with amplitude one. Other acceptable values include
"HAMMING", for Hamming, and "TRIANG", for triangular; see the
window(3-ESPSsp) manual page for the complete list.

# ESPS COMMON

The ESPS common file is neither read nor written.

# ESPS HEADERS

*Cross_cor* reads the value of *common.type* from the input sampled_data
files *input1.sd* and *input2.sd* for type checking.

The two input files are given as source files in the output file header,
but neither is given as the reference file. The output header contains
field definitions for *tag1,* *tag2,* and *cross_cor,* and generic
header items that record the values of the parameters listed in the ESPS
Parameters section. The parameter *window_type* is recorded in an item
of type CODED; the other parameters are recorded in items of type LONG.

In addition, The generic header item *start_time* (type DOUBLE) is
written in the output file. The value written is computed by taking the
*start_time* value from the header of the first input file (or zero, if
such a header item doesn't exist) and adding to it the offset time (from
the beginning of the first input file) of the first point processed plus
one half of *frame_len*. (Thus, *start_time* is in the middle of the
first frame, which is appropriate since the output data represent the
entire frame; without this adjustment for *frame_len*, *waves*+ displays
would not line up properly.) Also, the generic header item *record_freq*
(type DOUBLE) is written in the output file. The value is the number of
output records per second of input data from the first input file.

# SEE ALSO

auto(1-ESPS), window(3-ESPSsp), FEA_SD(5-ESPS), SD(5-ESPS), FEA(5-ESPS)

# BUGS

None known.

# FUTURE CHANGES

Accommodate multichannel and complex data.

# AUTHOR

Manual page by Rodney Johnson.
