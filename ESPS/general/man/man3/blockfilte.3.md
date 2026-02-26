# NAME

block_filter2 - filters data with FIR or IIR filter

init_fdata - initializes the filter data structure for *block_filter2*

block_filter - filters data with FIR or IIR filter (not supported as of
ESPS v5.0)

# SYNOPSIS

    #include <esps/feafilt.h>

    int
    block_filter2(nsamp, in, out, frec)
    long nsamp;
    struct sdata *in, *out;
    struct fdata **frec;

    #define FIR_FILTERING 1
    #define IIR_FILTERING 2

    struct fdata *
    init_fdata(type, filtrec, fh, cplx_sig, cplx_fil)
    int type;
    struct feafilt *filtrec;
    struct header *fh;
    int cplx_sig, cplx_fil;

    int block_filter (nsamp, x, y, pzfunc, state);
    int nsamp;
    double *x, *y, *state;
    struct zfunc *pzfunc;

# DESCRIPTION

*block_filter2* takes sampled data pointed to by *in*, filters it with a
real FIR or IIR filter that has its internal states and coefficients
pointed to by *frec*. The result is placed in some memory block pointed
to by *out*.

*In* and *out* point to the *sdata* data structures that support sampled
data of single or multichannels, and of data type of DOUBLE or
DOUBLE_CPLX.

    struct sdata{
      struct header *hd;
      struct feasd *rec;
      void *data, **ptrs;
      short data_type;

      int no_channel;
      int *channel;
      double sample_rate;
      char *name;
    };

The input sampled data can be either from file or memory. Data must be
of the type DOUBLE or DOUBLE_CPLX. Input sampled data read from a file
using function such as *get_feasd_recs (3-\SPS)* is pointed to by a
*struct feasd \** pointer which can be set to equal to *in-\>rec*. If
*in-\>rec* is non-NULL, *block_filter2* uses the data pointed by it and
ignores all other structure members in *in*.

If the sampled data is from memory, *in-\>rec* is set to NULL, and
*in-\>data* is set to point to the memory block for single channel data
or *in-\>ptrs* for multichannel data. *in-\>no_channel* is set to the
number of input channels. *in-\>data_type* is set to DOUBLE or
DOUBLE_CPLX. Other structure members are ignored. For multichannel data,
*in-\>ptrs\[s\]\[c\]* is the sample number *s* of channel *c*.

Similarly, if *out-\>rec* is non-NULL and points to some space allocated
by *allo_feasd_recs (3-\SPS)*, data pointed by it is written to a file
after calling *put_feasd_recs (3-\SPS)*. If the output data is to be
written to some memory block instead of a file, set *out-\>rec* to NULL
and set *out-\>data* for single channel data or *out-\>ptrs* for
multichannel data point to the memory block. Output data should be
either DOUBLE or DOUBLE_CPLX depending on the input data type.

In the IIR system, the filter is realized by cascading the second order
sub-systems of pairs of poles and zeros and their complex conjugate
counterparts. Each sub-system is implemented in the direct form II. This
is to insure the numerical stability of the system. In the FIR system,
the filter is realized in the direct form.

The coefficients of the second order IIR subsystems and internal states
of both IIR and FIR systems are initialized and allocated by the
function *init_fdata*. *init_fdata* returns the *fdata* data structure
which is used as the *frec* argument in *block_filter2*. *type*
specifies the type of filter, either *FIR_FILTERING* or *IIR_FILTERING*.
*filtrec* points to the *FEA_FILT (5-ESPS)* structure. *fh* is the
filter file header. *cplx_sig* is set to 1 if input data type is
DOUBLE_CPLX, 0 if DOUBLE. *cplx_fil* always has the value 0 for this
release.

*block_filter* takes an array of *nsamp* inputs in *x,* filters it with
the transfer function pointed to by *pzfunc,* and returns the *nsamp*
outputs in the *y* array. The user may change the values of *nsamp,
pzfunc-\>nsiz,* or *pzfunc-\>dsiz* between calls of the function and the
function will check whether it has to reallocate its own internal array
space.

The array pointed to by *state* contains the present state vector of the
filter, when implemented in "Direct" form. The calling program should
allocate space for the *state* array sufficient to store max
*(pzfunc-\>nsiz, pzfunc-\>dsiz)* elements. For FIR filters, the state
vector will contain the last *pzfunc-\>nsiz* input samples. For IIR
filters, the contents of the state vector are more complicated. Since
the function retains information about its past inputs and outputs
through the *state* array, the contents of this array should normally
not be altered by the calling program between calls to the function.

Data can be stored in the *state* array prior to the first call to
*block_filter* for the purposes of initialization. For either FIR or IIR
filters, the *state* array should be initialized to contain all zeroes
if the filtering operation is to assume zero inputs before the starting
point of the filtering. For FIR filters, the *state* array may be filled
with the previous *pzfunc-\>nsiz* samples to have the first output
computed correspond to "steady state" conditions.

# EXAMPLES

    FILE *ffile, *isdfile, *osdfile;
    struct header *fhd, ihd, ohd;
    struct feafilt *filtrec;
    struct fdata *frec;
    struct sdata *in, *out;
    int nsamp, size;


    /* get feafilt filter data */
    filtrec = allo_feafilt_rec(fhd);
    get_feafilt_rec(filtrec, fhd, ffile);


    /* initialize fdata filter data to allocate internal states...*/
    frec = (struct fdata *) init_fdata( IIR_FILTERING, filtrec, fhd, 0, 0);


    /* allocate in and output structures, set up pointers */
    in = (struct sdata *) malloc(sizeof(struct sdata));
    out = (struct sdata *) malloc(sizeof(struct sdata));

    in->rec = allo_feasd_recs( ihd, DOUBLE, 1000, (char *) NULL, NO);
    out->rec = allo_feasd_recs( ohd, DOUBLE, 1000, (char *) NULL, NO);


    /* main filtering loop */
    while( 0 != (size = get_feasd_recs( in->rec, 0L, nsamp, ihd, isdfile))){
       block_filter2(size, in, out, &frec);
       put_feasd_recs( out->rec, 0L, size, ohd, osdfile );
    }

# ERRORS AND DIAGNOSTICS

*block_filter2* function returns a non-zero value if an error occurs.
Error messages are printed to the standard error output, *stderr*.

*block_filter* returns 1 if the filtering was performed successfully.
The function prints an error message to *stderr* and exits if
*pzfunc-\>dsiz* is greater than 0 and *pzfunc-\>poles\[0\]* is equal to
0.

# BUGS

Due to the direct form implementation of the IIR filter, *block_filter*
is numerically unstable and is not supported as of the ESPS 5.0 release.
This function is replaced by *block_filter2*.

# REFERENCES

Leland B. Jackson, *Digital Filters and Signal Processing*, Kluwer
Academic Publishers, 1986

# SEE ALSO

    filter2(1-ESPS), FEA_FILT(5-ESPS), $ESPS_BASE/include/esps/feafilt.h

# AUTHOR

Derek Lin
