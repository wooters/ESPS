# NAME

    estimate_covar - estimate sample covariance matrix

# SYNOPSIS


    #include <stdio.h>
    #include <esps/esps.h>

    extern int debug_level;

    void
    estimate_covar (data, lnt, Sxx, matsiz, window_flag)
    float   *data;
    int     lnt;
    double  *Sxx;
    int     matsiz;
    int	window_flag;

# DESCRIPTION

Given *data* of size *lnt*, *estimate_covar* computes an estimate of the
sample covariance matrix *Sxx* . The size of *Sxx* is given by *matsiz*.
If *window_flag* is non-zero, a triangular window is applied to *data*.
*Sxx* is stored in row order.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

If the external *debug_level* is non-zero, various debugging messages
are printed. Higher values yield more verbose output.

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

\[1\]  
J.P.Burg, D.G.Luenberger, D.L.Wenger, "Estimation of Structured
Covariance Matrices" *Proceedings of the IEEE*, Vol. 70, No. 9 September
1982

\[2\]  
Shankar Narayan and J.P. Burg, "Spectral Estimation of Quasi-Periodic
Data", *Proceedings ICASSP 87*, pp. 944-947.

# SEE ALSO

    struct_cov(3-ESPSsp), genburg(3-ESPSsp),
    compute_rc(3-ESPSsp), get_vburg(3-ESPSsp), 
    refcof(1-ESPS)

# AUTHOR

Program by Shankar Narayan, man page by John Shore.
