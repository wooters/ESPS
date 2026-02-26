# NAME

    ebanner - create sampled data whose spectrogram image displays ASCII text 

# SYNOPSIS

**ebanner** \[ **-f** *font* \] \[ **-l** *low* \] \[ **-h** *high* \]
\[ **-r** *sample_rate* \] \[ **-a** *amplitude* \] \[ **-d** *duration*
\] \[ **-s** *step* \] \[ **-x** *debug_level* \] *input.text output.sd*

# DESCRIPTION

*Ebanner* converts ASCII text into a sampled data waveform whose
wide-band spectrogram image shows the ASCII text in the form of
raster-graphics fonts. The characters are represented as a matrix of
dots - some on and some off. For each "on" dot, a wavelet with the
correct location in the time-frequency plane is generated. All of these
wavelets are then summed to produce the output.

The intput file *input.text* is a text file, and the output file
*output.sd* an ESPS sampled data (FEA_SD) file of data type float.
Standard input and standard output are not supported.

# OPTIONS

The following options are supported:

**-f** *font \[\$ESPS_BASE/lib/fixedwidthfonts/cour.r.24\]*  
The spectral-domain image is rendered using (Sunview) fixed width fonts.
If *font* is a full path to a file, that file is used as the font.
Otherwise, *ebanner* searches for the font first relative to the current
directory and then relative to \$ESPS_BASE/lib/fixedwidthfonts. This
search path is overriden by the contents of the Unix environment
variable EBANNER_FONTS, if it is defined.

**-l** *low \[.1\]*  
**-h** *high \[.9\]*  
The -**l** and -**h** options specify the lower and upper frequency
bounds of the top and bottom of the text display in terms of fractions
of the Nyquist rate. Thus, for a sample frequency of 16kHz, "-**l** .2"
means that the bottom of the descenders will be at 1600Hz on the
spectrogram. These options permit positioning a string of text anywhere
in the frequency range. It's then a simple matter of adding two (or
more) such signals together with *addsd* (1-ESPS) in order to create
multiple lines of text in the spectrogram.

**-r** *sample_rate \[8000\]*  
This specifies the sampling rate of the output file.

**-a** *amplitude \[500\]*  
This is the zero-to-peak amplitude of each in each individual wavelet.
The worst case overall signal amplitude, assuming all vertical pixels in
a font matrix are on and all components in phase, is therefore (*height*
\* *amplitude*), where *height* is the nominal character height
specified in the font file. This value is written as the *max_value*
generic in the output header.

**-d** *duration \[.02\]*  
The nominal duration of the wavelets (seconds).

**-s** *step \[.01\]*  
The time step between wavelets (dots in the matrix) (seconds).

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *ebanner* prints debugging messages and
other information on the standard error output. The messages proliferate
as *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The ESPS parameter file is not used.

# ESPS COMMON

ESPS Common is not read.

# ESPS HEADERS

The output file is a FEA_SD file.

# FUTURE CHANGES

Automatic translation to the language of your choice.

# EXAMPLES

The following commands create and display a 8Khz sampled data file whose
spectrogram reads "Hello, world!":


    	% echo " Hello, world!" > hw
    	% ebanner hw hw.sd
    	% sgram hw.sd hw.fspec
    	% xwaves hw.sd hw.fspec

The following commands create and display a 16Khz sampled data file
whose spectrum has two lines of text ("ebanner:", and "Hello, world!"):


    	% echo "   ebanner:   " > eb
    	% echo " Hello, world!" > hw
    	% ebanner -r 16000 -l .6 eb eb.sd
    	% ebanner -r 16000 -l .1 -h .5 hw hw.sd
    	% addsd hw.sd eb.sd ebhw.sd
    	% sgram ebhw.sd ebhw.fspec
    	% xwaves ebhw.sd ebhw.fspec

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

# SEE ALSO

# AUTHOR

David Talkin
