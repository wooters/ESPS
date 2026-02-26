# NAME

toep_solv - Solve real symmetric Toeplitz systems of linear equations

# SYNOPSIS

**toep_solv** \[ **-f** *crsfield* \] \[ **-x** *debug_level* \] \[
**-F** *autfield* \] \[ **-P** *param* \] \[ **-W** *pwrfield* \]
*autocor.fea* *crosscor.fea* *output.filt*

# DESCRIPTION

*Toep_solv* repeatedly obtains an \`\`autocorrelation vector'' *r* from
its first input file and a corresponding \`\`cross-correlation vector''
*v* from its second file. For each such pair of vectors, it solves the
system of equations

*Rw = v*

where *R* is a Toeplitz matrix with coefficients given by

Rij = r\|i-j\|

and writes the solution vector *w* to the output file.

The first input file is typically a FEA_ANA file containing normalized
autocorrelations, as indicated by a value AUTO for the header item
*spec_rep* (see FEA_ANA(5-ESPS)). However, any FEA file having a scalar
field *raw_power* and a vector field *spec_param* of type FLOAT is
accepted, and in fact alternative field names may be chosen with the
**-W** and **-F** options. A vector *r* is obtained from these two
fields in each input record. The value of r0 is the contents of the
*raw_power* field, and the values of r1, . . . , rm are obtained by
multiplying the contents of the *spec_param* field by r0. Here *m,* the
size of the *spec_param* field, equals the order of the
autocorrelations.

The second input file may be any FEA file having a vector field
*cross_cor* of type FLOAT, and an alternative field name may be chosen
with the **-f** option. For example files written by the program
*cross_cor*(1-ESPS) are acceptable. The vector *v* obtained from each
record is simply the contents of the given field. The size of the field
must be *m* + 1, where *m,* as above, is the size of the *spec_param*
field in the first input file.

The output file is a FEA_FILT file. The elements of each solution vector
*w* are treated as coefficients of a FIR filter and written in an output
record as elements of *re_num_coeff.*

The solution vectors are computed by *stsolv*(3-ESPS), which uses
Levinson's method - reflection coefficients are computed as intermediate
results, and a warning is printed if a reflection coefficient with
magnitude 1 or greater is computed. In that case the output record
contains the solution of a system of some reduced order.

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-f** *crsfield* **\[cross_cor\]**  
The name of the field in the second input file that contains the
cross-correlation vectors *v.*

**-x** *debug_level* **\[0\]**  
A positive value causes various debugging messages to be printed to the
standard error output - the higher the value, the more messages. At the
default level of 0, no messages are printed.

**-F** *autfield* **\[spec_param\]**  
The name of the field in the first input file that contains the
normalized autocorrelation vectors used in computing the autocorrelation
vectors *r.*

**-P** *param* **\[params\]**  
**-W** *pwrfield* **\[raw_power\]**  
The name of the field in the first input file that contains the total
power r0 used in computing the autocorrelation vectors *r.*

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*crsfield - string*  
The name of the field in the second input file that contains the
cross-correlation vectors. This parameter is not read if the **-f**
option is used. The default is "cross_cor".

*autfield - string*  
The name of the field in the first input file that contains the
normalized autocorrelation vectors. This parameter is not read if the
**-F** option is used. The default is "spec_param".

*pwrfield - string*  
The name of the field in the first input file that contains the total
power. This parameter is not read if the **-W** option is used. The
default is "raw_power".

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The value of *common.type* is checked in the two input file headers. The
output header is a new FEA_FILT file header. The generic header item
*max_num* is set equal to the number of output filter coefficients,
which is the same as the number of elements of an input
cross-correlation vector; *max_denom* becomes 0. The values given to
*type* and *method* are FILT_ARB and PZ_PLACE. All other FEA_FILT
generic header items are filled in with NONE, 0, or NULL. Generic header
items *crsfield, autfield,* and *pwrfield* are added to record the
values obtained from the command line, from the parameter file, or by
default. As usual, the command line is added as a comment, and the
headers of the input files are added to the output file header as source
files.

# EXAMPLE

Sometimes one needs to estimate the coefficients of a linear filter,
give two pieces of information: an original version of a signal and the
corresponding filtered version, possibly with added noise. An estimate
may be obtained as the solution *w* of a Toeplitz system for which the
matrix elements r\|i-j\| are autocorrelations of the original signal,
and the right-hand side *v* consists of cross-correlations of the
filtered signal with the original. The problem can thus be solved by
*toep_solv* together with *auto*(1-ESPS) and *cross_cor*(1-ESPS).
Suppose for example that the original signal is a thousand-sample
segment of a sampled-data file *orig.sd* starting at sample 1001, and
that the filtered signal is in a sampled-data file *filt.sd* starting at
sample 501. The following commands will estimate an order-10 causal FIR
filter that will transform the original signal to one as close as
possible to the filtered signal in a least-squares sense.

    auto -p1001:2000 -o10 orig.sd auto.fana
    cross_cor -p501:1500 -p1001:2000 -o0:10 filt.sd orig.sd ccor.fea
    toep_solv auto.fana ccor.fea filter.filt

# SEE ALSO

    stsolv(3-ESPSsp), auto(1-ESPS), cross_cor(1-ESPS),
    FEA(5-ESPS), FEA_ANA(5-ESPS), FEA_FILT(5-ESPS)

# BUGS

There should be an option -r to allow selecting a subrange of the
records in the input files. Tags are ignored.

# FUTURE CHANGES

Accommodate double-precision data.

# AUTHOR

Rodney Johnson. Modified to write FEA_FILT files by Bill Byrne.
