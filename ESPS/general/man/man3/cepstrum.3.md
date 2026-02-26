# NAME

afc2cep - transform autoregressive filter coefficients into cepstrum
coefficients

cep2afc - transform cepstrum coefficients into autoregressive filter
coefficients

# SYNOPSIS

\
int\
afc2cep (afc, cep, order)\
int order;\
float \*afc,\*cep;

\
int\
cep2afc (cep, afc, order)\
int size;\
float \*afc,\*cep;

# DESCRIPTION

Each function transforms a set of coefficients that contain spectral
information into an equivalent set of coefficients.

*Afc2cep* transforms the input autoregressive filter coefficients
(*afc*) into the cepstrum coefficients (*cep*). *Order* is the number of
input and output parameters.

*Cep2afc* transforms the *cep*s into *afc*s. *Order* is the number of
input and output parameters.

# WARNINGS

The first cepstral coefficient = ln{sqrt\[residual power\]} is not
returned in the cep\[\] array by *afc2cep*, nor is it passed into
*cep2afc*. The first autregressive filter coefficient (= 1) is neither
passed into *afc2cep* nor returned by *cep2afc*.

# DIAGNOSTICS

None.

# EXAMPLES

        /*
         * Convert afc to cep
        */
    	int size = 3;
    	static float afc[] = {.9, .5, .1};
    	float cep[3];

    	/* Ready to Convert */

    	(void)afc2cep(afc, cep, size);

    		.
    		.
    		.

        /*
         * Convert back to afc
        */

    	(void)cep2afc(cep, afc, size);

# BUGS

None known.

# SEE ALSO

rc_reps(3-ESPSsp), spectrans(1-ESPS), transpec(1-ESPS)

# AUTHOR

Manual page and code by David Burton
