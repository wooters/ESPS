# NAME

get_arspect - compute lpc spectra from lpc filter coefficients

# SYNOPSIS

get_arspect (c, order, res_power, samp_freq, y)\
int order, samp_freq;\
float c\[\], res_power, y\[\];

# DESCRIPTION

This routine computes the lpc power spectra from the lpc filter
coefficients and the residual power. Input to this routine are **order**
lpc filter coefficients **c\[1\]** to **c\[order\],** the residual power
**res_power** and sampling frequency **samp_freq.** A 1024-point fft is
used to obtain the lpc power spectra at 1024 points on the unit circle.

# BUGS

None

# SEE ALSO

get_fft (3-ESPSsp).

# AUTHOR

Shankar Narayan
