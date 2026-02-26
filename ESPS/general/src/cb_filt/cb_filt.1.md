# NAME

    cb_filt - design a constraint-based FIR filter using the 
    Simplex algorithm

# SYNOPSIS

**pkmc_filt** **-P** *param_file* \[ **-x** *debug_level* \]
*feafilt_file*

# DESCRIPTION

The program *cb_filt* designs a linear phase finite impulse response
(FIR) filter with its specifications defined in the parameter file
*param_file*. The filter coefficients are saved in the output file
*feafilt_file*. If *feafilt_file* is replaced by "-", the standard
output is written.

The filter is designed using the Simplex algorithm to solve for a
constraint-based problem. The constraints are expressed in terms of
upper/lower limits and concavity properties on the response, the
algorithm finds the shortest filter length which allows these
constraints to be met, and then find a filter of that order which is
farthest from the upper and lower constraint boundaries in a mini-max
sense.

The constraints have the following forms: bandedges, upper bounds and
lower bounds on the bands, concavity, and huggness constraints. They are
expressed in various combinations of parameters in *param_file*.

This program is more general than *pkmc_filt(1-ESPS)*. It can design
filter with nearly flat passband magnitude response by specifying the
concavity property on the band.

Also see the shell script *xfir_filt(1-ESPS)* that is a cover script for
this and other FIR filter design programs.

# OPTIONS

The following option is supported:

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *cb_filt* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following parameters are read from *param_file*.

*filt_length_L - int*  
The largest filter length allowed. It must be less or equal to 128

*filt_length_S - int*  
The smallest filter length allowed. It must be greater or equal to 1.
*cb_filt* will finds the shortest filter length that satisfies the
constraints. If fixed filter length is desired, set *filt_length_L*
equal to *filt_length_S*.

*ngrid - int*  
This is an optional parameter. It specifies the number of grid points
The default value is 10 \* (*filt_length_L* /2 ) + 1.

*samp_freq - float*  
The sampling frequency.

*nspec - int*  
Number of specifications. Each band needs at least two specifications,
one for lower bound constraint, one for upper bound constraint, and
possibly one for concavity constraint. For example, a lowpass filter may
have *nspec* equals 5 -- 2 constraints for upper and lower bounds in
passband, 2 constraints for upper and lower bounds in stopband, and 1
concavity constraint for passband.

*model - string*  
Specifies the symmetry property of the designed FIR impulse response.
Use the value *cosine* for even symmetry -- Type I or Type II FIR for
multiband filters. Use the value *sine* for odd symmetry -- Type III or
Type IV FIR for differentiators

The following set of the parameters have the forms of *spec\[i\]\_XXX*,
where *i* denotes the specification number, *XXX* denotes the kind of
specification. For example, *spec2_edge1* is a parameter for the left
edge of the second specification. *i* starts from 1.

*spec\[i\]\_type - string*  
Type of constraint on the *i*th specification. The value *"limit"*
denotes upper/lower bound limit specification for the *i*th spec. The
value *"concave"* denotes up/down concavity specification for the *i*th
spec. If *spec\[i\]\_type* is *"concave"*, then only *spec\[i\]\_sense*,
*spec\[i\]\_edge1*, and *spec\[i\]\_edge2* need be defined. Concavity
constraint to the passband of the filter gives nearly flat frequency
response. Otherwise, an upper/lower limit constraint gives an equiripple
frequency response.

<!-- -->

*spec\[i\]\_sense - string*  
If *spec\[i\]\_type* is *"limit"*, a value of "+" denotes an upper bound
spec; or "-" for a lower bound spec. If *spec\[i\]\_type* is
*"concave"*, "+" denotes concave up, "-" for concave down.

*spec\[i\]\_edge1 - float*  
The left bandedge for the *i*th spec.

*spec\[i\]\_edge1 - float*  
The right bandedge for the *i*th spec.

*spec\[i\]\_bound1 - float*  
The bound on *spec\[i\]\_edge1*.

*spec\[i\]\_bound2 - float*  
The bound on *spec\[i\]\_edge2*. Values in between *spec\[i\]\_bound1*
and *spec\[i\]\_bound2* over the *i*th spec will be interpolated
according to the parameter *spec\[i\]\_interp*.

*spec\[i\]\_hug - string*  
If it is *"not hugged"*, the response on the *i*th specification will be
pushed as far as possible from the specified bounds. If this constraint
needs not be optimized, then use the value *"hugged"*.

*spec\[i\]\_interp - string*  
If it is *"arithmetic"*, frequency response values from
*spec\[i\]\_bound1* to *spec\[i\]\_bound2* over the band
*spec\[i\]\_edge1* to *spec\[i\]\_edge2* is interpolated arithmetically
(linearly); if it is *"geometric"*, values are interpolated
geometrically (linearly in decibels).

*push_direction - string*  
If it is *"left"*, a set of bandedges are pushed as far left as possible
while still respecting the constraints for the fixed length (i.e.
*filt_length_L = filt_length_S*) specified by user. If it is *"right"*,
the set of bandedges are pushed right. If no pushing is desired, specify
*neither*. If *push_direction* is set to *"right"* or *"left"*, the
parameters *nspec_pushed*, *spec\[j\]\_pushed* must be specified.

*nspec_pushed - int*  
Number of bands to be pushed.

*spec\[j\]\_pushed - int*  
A single number corresponding the specification number that contains the
desired bandedges to be pushed. For example, if *spec1_pushed* equals to
4, *spec2_pushed* equals 3 means the bandedges specified in
specification number 3 and 4 are to be pushed. The specification numbers
can be assigned to *spec\[j\]\_pushed*, *1 \<= j \<= nspec*, in any
arbitrary order.

# ESPS COMMON

No ESPS common parameter processing is used.

# ESPS HEADERS

A new FEAFILT header is created for the output file. The program fills
in appropriate values in the common part of the header as well as the
following generic header items associated with the FEAFILT type.

The *cb_specs* generic header item is a string containing *nspec*
specifications. Each specification starts with *SPEC\[i\]*, followed by
*"limit"/"concave"*, *sense*, left edge, right edge, bound at left edge,
bound at right edge, huggness, and interpolation mode.

The *model* generic header item denotes whether *sine* or *cosine* model
is used.

If *push_direction* parameter is *"left"* or *"right*, the *nspec*
generic header item denotes numbers of specification pushed.

If *push_direction* parameter is *"left"* or *"right*, the
*push_direction* generic header item is a string that first starts with
the band direction pushed, followed by specification numbers that are
pushed.

In addition, the generic header item *delay_samples* (type DOUBLE) is
added to the header. *Delay_samples* is equal to (filter length - 1)/2.
This represents the delay to the center of the peak of the impulse
response.

# FUTURE CHANGES

# EXAMPLES

See its parameter setting example in *\$ESPS_BASE/lib/params/Pcb_filt*.

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

"METEOR: A Constraint-Based FIR Filter Design Program", Kenneth
Steiglitz, Thomas Parks, and James Kaier. IEEE Transaction on Signal
Processing, Vol. 40, No. 8, August 1992.

# SEE ALSO

    xfir_filt(1-ESPS), pkmc_filt(1-ESPS), win_filt(1-ESPS), 
    notch_filt(1-ESPS), FEA_FILT(5-ESPS), atofilt(1-ESPS), 
    wmse_filt(1-ESPS), iir_filt(1-ESPS), sfconvert(1-ESPS)

# AUTHOR

Thanks to Dr. Kenneth Steiglitz, Thomas Parks, and James Kaiser for
permission to use the original C codes. Program is made ESPS-compatible
by Derek Lin.
