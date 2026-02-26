# NAME

spectrans - transform spectral parameters in a FEA_ANA file

# SYNOPSIS

**spectrans** \[ **-x** *debug_level* \] \[ **-w** *grid_width* \] \[
**-m** *spec_rep* \] *infile.fea outfile.fea*

# DESCRIPTION

*Spectrans* transforms the spec_param field of a FEA_ANA file
*infile.fea* to a different spectral representation and outputs the
FEA_ANA file *outfile.fea.* The output spectral representation is is
determined by the **-m** option. If *infile.fea* is equal to "-", then
standard input is used. If *outfile.fea* is equal to "-", standard
output is used. If the **-m** option specifies the current spectral
representation of *infile.fea,* *spectrans* exits with a warning message
and without creating *outfile.fea.*

See *transpec*(1-ESPS) for transforming paramters from ordinary
FEA(5-ESPS) files.

# OPTIONS

**-x** *debug_level*  
*Debug_levels* greater than 0 cause messages to print to stderr.

**-w** *grid_width*  
*Grid_width* is the nominal spacing (in Hz.) of the grid used in the
search for LSFs. It is used only during computation of LSF values, and
if not specified, a default value of 4 Hz. is used. Reasonable values
for *grid_width* depend on the bandwidth of the original sampled data,
but for 4 kHz. data, values between 2 and 62 Hz. are reasonable.

**-m** *spec_rep*  
*Spec_rep* is the type of spectral parameter to put in the output
FEA_ANA file. Legal values are defined in *\<esps/anafea.h\>,* but they
include the following: AUTO == normalized autocorrelations, RC ==
reflection coefficients, AFC == autoregressive filter coefficients, LAR
== log area ratios, CEP == cepstrum coefficients, and LSF == line
spectral frequencies.

# ESPS PARAMETERS

The ESPS parameter file is not read by *spectrans.*

# ESPS COMMON

The ESPS Common file is not read by *spectrans.*

# ESPS HEADERS

Values in the header of *outfile.fea* are copied from the values in the
header of *infile.fea,* except for the spec_rep type. It takes on the
**-m** specified value. Also, if the parameter is being converted to
LSFs, then a generic header item *LSF_grid_width* of type double is
added that contains the **-w** value.

# FUTURE CHANGES

Add AF (area functions) as spectral parameters that are supported.

# SEE ALSO

    refcof(1-ESPS), lpcana(1-ESPS), me_spec(1-ESPS),
    ESPS(5-ESPS), FEA_ANA(5-ESPS), transpec(1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page and program by David Burton. Converted to ESPS 3.0 by John
Shore.
