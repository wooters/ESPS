# NAME

transpec - transform spectral parameters in a FEA file

# SYNOPSIS

**transpec** \[ **-i** *input_field* \] \[ **-m** *target_rep* \] \[
**-o** *output_field* \] \[ **-r** *source_rep* \]\
\[ **-s** *samp_freq* \] \[ **-w** *grid_width* \] \[ **-x**
*debug_level* \] \[ **-P** *parameter_file* \] *infile.fea outfile.fea*

# DESCRIPTION

*Transpec* transforms a numeric vector field containing spectral
information in a FEA file (*infile.fea*) to a different spectral
representation and outputs a FEA(5-ESPS) file (*outfile.fea*) that
contains the new spectral representation and all the other original
fields. By default the new spectral representation is written over the
old one in the *input_field*, but if an *output_field* is supplied (via
the **-o** option or the parameter file), then the original parameters
are left in the *input_field* and a new field is added to each record
that contains the transformed spectral parameters.

If *infile.fea* is equal to "-", then standard input is used. If
*outfile.fea* is equal to "-", standard output is used.

There is a program *spectrans*(1-ESPS) that performs similar parameter
transformations but is specialized to FEA_ANA files. One feature of
*spectrans* not available in *transpec* is handling parameter sets whose
order depends on the voicing class.

# OPTIONS

**-i** *input_field \[spec_param\]*  
This is the name of the field in *infile.fea* that contains the spectral
parameters. If a value is not specified on the command line or in the
parameter file, *transpec* checks to see if the field *spec_param*
exists, and if it does, *transpec* uses the elements of that field as
the input spectral parameters. The command line option values overrides
any parameter file value.

**-m** *target_rep*  
*Target_rep* is the type of spectral parameter to put in the output
FEA(5-ESPS) file. Legal values are defined in *\<esps/anafea.h\>,* but
they include the following: AUTO == normalized autocorrelations, RC ==
reflection coefficients, AFC == autoregressive filter coefficients, LAR
== log area ratios, CEP == cepstrum coefficients, and LSF == line
spectral frequencies. This value overrides any parameter file value.

**-o** *output_field*  
This is the name of the field in *outfile.fea* in which the transformed
spectral parameters are deposited. By default, the transformed
parameters are deposited in the *input_field* of *outfile.fea*, so if
you don't want the original parameters overwritten, a value for
*output_field* must be specified on the command line or in the parameter
file. Specifying an empty string ("") through the parameter file is
equivalent to omitting the specification. Thus a parameter-file entry
like

string output_field ?= "": "Field name for output spectral parameters";

makes overwriting the original parameters the default, but gives the
user the opportunity to specify an alternative output field
interactively.

**-r** *source_rep \[spec_rep value\]*  
*Source_rep* is the type of spectral parameter in the input FEA(5-ESPS)
file. Legal values are defined in *\<esps/anafea.h\>.* If no value is
specified (either on the command line or in the parameter file),
*transpec* checks to see if a generic header item called *spec_rep*
exists, and if it does, *transpec* gets the type of the input spectral
parameter from this header item. The command line option value overrides
any parameter file value.

**-s** *samp_freq \[src_sf value\]*  
The sampling frequency of the data from which the spectral parameters
were derived. The sampling frequency is needed only if LSFs are the
input or target spectral representations. If no value for the sampling
frequency is supplied on the command line or in the parameter file, and
one is required, *transpec* checks to see if the generic header item
*src_sf* is present, and if it is, its value is used as the sampling
frequency.

**-w** *grid_width \[4\]*  
*Grid_width* is the nominal spacing (in Hz.) of the grid used in the
search for LSFs. It is used only during computation of LSF values, and
if it is not specified, a default value of 4 Hz. is used. Reasonable
values for *grid_width* depend on the bandwidth of the original sampled
data, but for 4 kHz. data, values between 2 and 62 Hz. are reasonable.
The speed of the algorithm for computing LSFs depends strongly on this
quantity. The larger values are recommended for a quick look at the
output, and the smaller values are recommended when accuracy of the
results is more important than speed. The command-line value overrides
any parameter-file value.

**-x** *debug_level \[0\]*  
*Debug_levels* greater than 0 cause messages to print to stderr.

**-P** *parameter_file \[params\]*  
Specifies the name of the parameter file to use.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

The following parameters are read from the parameter file:

*input_field - string*  
> The field in *infile.fea* containing the spectral parameters. If this
> parameter value is not specified and the **-i** option is not used,
> the default value for the field name in *infile.fea* is *spec_param*;
> if it doesn't exist, *transpec* warns and exits.

*source_rep - string*  
> The name of the current spectral parameter type. Acceptable values
> include RC (reflection coefficients), LAR (log area ratios), AFC
> (autoregressive filter coefficients), CEP (cepstral coefficients), and
> LSF (line spectral frequencies). If this parameter value is not
> specified, and the **-r** option is not used, and the generic header
> item *spec_rep* exists, the value in *spec_rep* is used. If *spec_rep*
> doesn't exist and *source_rep* is not otherwise specified, *transpec*
> warns and exits.

*target_rep - string*  
> The name of the spectral type in the output file. Acceptable values
> are the same as for *source_rep*. There are no defaults; a value must
> be specified either on the command line or in the parameter file.

*output_field - string*  
> The name of the field in *outfile.fea* in which to put the transformed
> spectral parameters. If *output_field* already exists in *infile.fea*,
> *transpec* warns and exits. If *output_field* is not specified either
> on the command line or in a parameter file, *transpec* overwrites the
> values in the field *input_field*.

*samp_freq_name - string*  
> The name of a generic header item that contains the sampling
> frequency. Either this parameter or *samp_freq* must be explicitly
> specified, if the either the input or target spectral representation
> is LSF. If a sampling frequency is needed and this field is not
> specified and *samp_freq* is not specified on the command line or in
> the parameter file, a default value of *src_sf* is used for this
> header item. If it does not exist, *transpec* warns and exits.

*samp_freq - float*  
> A numerical value for the sampling frequency. This value is used
> unless the parameter *samp_freq_name* is defined and names a generic
> header item that exists in the file or the command line option **-s**
> is set to a valid value. The value of the generic header item takes
> precedence over the parameter value *samp_freq*, but the command line
> option value **-s** takes precedence over the value of the generic
> header item. Remember a value for the sampling frequency is required
> only if the input or target spectral representation is LSF.

*grid_width - float*  
> This specifies the nominal spacing (in Hz.) of the grid used in the
> search for LSFs. See the **-w** option for more details. This values
> is superseded by the command line option value of **-w**. This value
> is required only if the target (output) representation is LSF.

# ESPS COMMON

The ESPS Common file is not read by *transpec.*

# ESPS HEADERS

Values in the header of *outfile.fea* are copied from the values in the
header of *infile.fea,* except for *spec_rep* which is set equal to the
target spectral representation (and is added if not present). If the
parameter is being converted to LSFs, then a generic header item
*LSF_grid_width* (type "double") is added that contains the **-w**
value. If a generic header item called *LSF_grid_width* already exists,
*uniq_name*(3-ESPSu) is used to derive a new name. Finally, if the
sampling frequency was provided directly by the params file or the
command line (not via a generic header item), a generic header item
*src_sf* (type double) is added to the output file header. If a generic
header item called *src_sf* already exists, *uniq_name*(3-ESPSu) is used
to derive a new name.

# FUTURE CHANGES

Add support for AF (area functions) as spectral parameters. Handle
*voicing,* *order_vcd,* and *order_unvcd* in FEA_ANA files as a special
case.

# SEE ALSO

    refcof(1-ESPS), lpcana(1-ESPS), me_spec(1-ESPS),
    spectrans(1-ESPS), ESPS(5-ESPS), FEA_ANA(5-ESPS),
    FEA(5-ESPS)

# BUGS

The field *voicing* and the header items *order_vcd* and *order_unvcd*
in FEA_ANA files are ignored.

# AUTHOR

Manual page by David Burton.
