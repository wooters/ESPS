# NAME

interp_filt - perform interpolation filtering on a data array.

# SYNOPSIS

\
int interp_filt (nx, x, y, pzfunc, state, up, down, poutflag, pout);\
int nx, up, down, \*poutflag, \*pout;\
double \*x, \*y, \*state;\
struct zfunc \*pzfunc;

# DESCRIPTION

*interp_filt* takes an array of *nx* inputs in *x,* performs
interpolation filtering, and returns the result in *y.* This changes the
sampling rate by a factor of *up/down.* To accomplish this it raises the
sampling rate by a factor of *up* by inserting zeros into the input data
sequence, filters it with the transfer function pointed to by *pzfunc,*
and downsamples the resulting sequence by a factor of *down* to result
in *\*pout* outputs. Depending on the values of *nx* and *\*poutflag* on
any particular call to the function, *\*pout* will either be
*nx\*up/down* or *nx\*up/down + 1.*

In the case of IIR filtering, a weighted sum must be computed for each
sample at the higher sampling rate *(up\*src_sf).* For FIR filtering,
however, the function is implemented so as to compute only the samples
which will be returned in the *y* array. The user may change *nx,* and
*\*pzfunc,* between calls of the function, but the values passed on the
first call of the function for *nx, pzfunc-\>nsiz,* or *pzfunc-\>dsiz*
must never be exceeded.

*poutflag* is a pointer to a variable which indicates to the subroutine
which sample in the function's internal state array corresponds to the
next output. Normally, the calling program should initialize this
parameter to zero at the beginning of the filtering operation, and not
change it after that.

The array pointed to by *state* contains the present state vector of the
filter, when implemented in "Direct" form. The calling program should
allocate space for the *state* array sufficient to store max
*(up\*pzfunc-\>nsiz, up\*pzfunc-\>dsiz)* elements. For FIR filters, the
state vector will contain the previous input samples at the *up\*src_sf*
sampling rate. For IIR filters, the contents of the state vector are
more complicated. Since the function retains information about its past
inputs and outputs through the *state* array, the contents of this array
should normally not be altered by the calling program between calls to
the function.

Data can be stored in the *state* array prior to the first call to
*interp_filt* for the purposes of initialization. For either FIR or IIR
filters, the *state* array should be initialized to contain all zeroes
if the filtering operation is to assume zero inputs before the starting
point of the filtering. For FIR filters, the *state* array may be filled
with the previous *up\*(pzfunc-\>nsiz)* which would occur at the
sampling rate *up\*src_sf,* in order to have the first computed output
correspond to "steady state" conditions.

# EXAMPLE

    /* The following is valid for FIR filtering. */

    skip_rec (fpin, start - pzfunc->nsiz, size_rec (ih));
    get_sd_recf (temp, pzfunc->nsiz, ih, fpin);

    /* Intersperse zeros in the state array to set the initial conditions. */
    for (i=0; i<pzfunc->nsiz; i++)
        {
        state [i*up] = temp[i];
        for (j=1; j<up; j++) state [i*up+j] = 0;
        }

    /* We're going to filter nan input samples. */
    nleft = nan;

    /* The first output will correspond to the first input. */
    outflag = 0;

    /* Main filtering loop. */
    while (nleft > nsamp))
        {
        get_sd_recf (x, nsamp, ih, fpin);
        nleft -= nsamp;
        interp_filt (nsamp, x, y, pzfunc, state, up, down, &outflag, &nout);
        put_sd_recf (y, nout, oh, fpout);
        }

    /* Finish up the odd samples. */
    get_sd_recf (x, nleft, ih, fpin);
    interp_filt (nleft, x, y, pzfunc, state, up, down, &outflag, &nout);
    put_sd_recf (y, nout, oh, fpout);

# DIAGNOSTICS

The function returns 1 if the filtering was performed successfully. The
function prints an error message to *stderr* and exits if
*pzfunc-\>dsiz* is greater than 0 and *pzfunc-\>poles\[0\]* is equal to
0.

# BUGS

None known.

# SEE ALSO

    filter(1-ESPS), ESPS(5-ESPS)

# REFERENCES

L.R. Rabiner and R.W.Schafer, *Digital Processing of Speech Signals,*
page 22, Prentice-Hall, 1978.

# AUTHOR

Brian Sublett
