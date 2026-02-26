# NAME

rc_reps - transform reflection coefficients into other spectral
parameter sets\
reps_rc - transform spectral parameter sets into reflection coefficients

# SYNOPSIS

\#include \<esps/anafea.h\>

\
int\
rc_reps(rc, output, output_type, size, bwidth, frq_res)\
int size, output_type;\
float \*rc, \*output, bwidth, frq_res;

\
int\
reps_rc(input, input_type, rc, size, bwidth)\
int size, input_type;\
float \*input, \*rc, bwidth;

# DESCRIPTION

Each function transforms a set of coefficients that contain spectral
information into another equivalent set of coefficients. Valid spectral
types are defined in *anafea.h* under *spec_reps\[\]*, but they include
reflection coefficients (RC), log area ratios (LAR), normalized
autocorrelations (AUTO), autoregressive filter coefficients (AFC),
cepstrum coefficients (CEP), and line spectral frequencies (LSF).
*rc_reps* starts with RCs and converts them into LARs, AFCs, AUTOs,
CEPs, or LSFs; *reps_rc* transforms LARs, AFCs, AUTOs, CEPs, or LSFs
into RCs.

*rc_reps* transforms the input *rc*s into the parameter type
*output_type* and returns them in *output*. *Size* is the number of
input and output parameters. *Bwidth* and *frq_res* are parameters that
are only used when transforming to LSFs. *Bwidth* should equal the
bandwidth (Nyquist frequency) of the data that was used in estimating
the RCs. *Frq_res* specifies the resolution of the search grid that is
used in finding the LSFs. For signal bandwidths of 4000 Hz., *frq_res*
between 2 and 50 Hz. are reasonable.

*reps_rc* transforms the *input* from *input_type* parameters into RCs
and returns them in *rc*. *Size* is the number of input and output
parameters. *Bwidth* is the Nyquist frequency of the source sampled data
and is only used when converting from LSFs.

# WARNINGS

The leading -1 for AFCs and the leading 1 for normalized AUTOs are not
included in the input or output vectors. Neither is the first term =
ln{sqrt\[residual power\]} for CEPs.

# DIAGNOSTICS

Both functions return 0 for normal completion, and they return -1 if
they encounter invalid spectral types. If input and output parameters
are both RCs, a warning is issued, but RCs are returned in the output
array.

# EXAMPLES

        /*
         * Convert RCs to LARs
         */
    	#include <esps/anafea.h>
    	int size = 3, output_type = LAR, input_type = LAR;
    	static float rc[] = {.9, .5, .1};
    	float lar[3], bwidth, frq_res;

    	/* Ready to Convert */

    	if((rc_reps(rc, lar, output_type, size, bwidth, frq_res)) == -1) {
    	    TROUBLE WITH CONVERSION
    	}


        /*
         * Convert back to RCs
         */

    	if((reps_rc(lar, input_type, rc, size, bwidth) == -1){
    	    TROUBLE WITH CONVERSION
    	}

# BUGS

None known.

# SEE ALSO

auto_pefrc(3-ESPSsp), pc_to_lsf(3-ESPSsp),\
lsf_to_pc(3-ESPSsp)

# FUTURE CHANGES

Add cepstrum and area functions to the allowable spectral types.

# AUTHOR

Manual page and code by David Burton
