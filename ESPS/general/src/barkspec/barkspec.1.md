# NAME

barkspec - Bark scaled critical band spectrum

# SYNOPSIS

**barkspec** \[ **-a** *add_const* \] \[ **-m** *mult_const* \] \[
**-n** *num_freqs* \] \[ **-r** *range* \] \[ **-x** *debug_level* \] \[
**-B** *bark_range* \] \[ **-H** *freq_range* \] \[ **-P** *param_file*
\] \[ **-S** *spec_type* \] \[ **-X** \] *input.spec* *output.spec*

# DESCRIPTION

This program reads an ESPS spectrum (FEA_SPEC) file containing power
spectra on a linear frequency scale. To each input spectrum it applies a
bank of critical-band filters with uniform spacing on the Bark scale. It
writes the resulting Bark spectra to an output FEA_SPEC file.

If *input.spec* is \`\`-'', standard input is read. If *output.spec* is
\`\`-'', results are written to standard output. The input and output
should not be the same file; however, it is okay to run the program as a
filter by specifying \`\`-'' for both input and output.

For the input file, *freq_format* must be SYM_EDGE (see
*FEA_SPEC*(5-ESPS)). This is the normal output format used by
*fft*(1-ESPS) (for real spectra) and by *me_spec*(1-ESPS). The output
file is in ARB_FIXED format, meaning that the header contains an
explicit list of the frequencies corresponding to the spectral values in
the records. The output values may be written either in units of power
or log power (dB)see **-S** under Options. (That is, the output
*spec_type* may be either PWR or DBsee *FEA_SPEC*(5-ESPS).) In either
case a further arbitrary linear scaling of the output values may be
specifiedsee options **-a** and **-m**.

The computation of the Bark spectrum follows that presented in ref.
\[1\]. The frequency *f* in hertz corresponding to a Bark-scale value
*b* is given by:

> f = 600 sinh (b/6)
