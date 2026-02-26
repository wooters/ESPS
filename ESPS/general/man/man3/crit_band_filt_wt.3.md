# NAME

crit_band_filt_wt - Compute the critical band filter weight for a bark
value

# SYNOPSIS

double\
crit_band_filt_wt (barkValue)\
double barkValue;

# DESCRIPTION

This function evaluates the critical-band filter-weight function at a
point and returns the filter weight corresponding to that bark value
(\[1, 2\] with a small alteration). The input *barkValue* specifies the
distance from the filter peak. Note that the critical band filter
function is not symmetric around the peak, so both positive and negative
values need evaluation.

The critical band filtering function *F* is determined by the following
equation:

> 10 log10 F(b) = 7 - 7.5 (b - 0.210)\
> - 17.5 \[0.196 + (b - 0.210)2\] 1/2
