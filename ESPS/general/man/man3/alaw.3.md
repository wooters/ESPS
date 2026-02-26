# NAME

    linear_to_a - A-law compression of linear PCM data 
    a_to_linear - re-expansion of A-law compressed data
    linear_to_a_2 - A-law compression (with bit inversions) of linear PCM data 
    a_to_linear_2 - re-expansion of A-law compressed data (with bit inversions)

# SYNOPSIS

    int
    linear_to_a(inbuf, outbuf, bufsize)
    short	*inbuf;
    char	*outbuf;
    long	bufsize;

    int
    a_to_linear(inbuf, outbuf, bufsize)
    char	*inbuf;
    short	*outbuf;
    long	bufsize;

    int
    linear_to_a_2(inbuf, outbuf, bufsize)
    short	*inbuf;
    char	*outbuf;
    long	bufsize;

    int
    a_to_linear_2(inbuf, outbuf, bufsize)
    char	*inbuf;
    short	*outbuf;
    long	bufsize;

# DESCRIPTION

These functions do quasi-logarithmic companding (compression and
expansion) of 2-byte integer data by using the *A*-law with a value of
*A* = 87.56. This is the European PCM standard \[1\]. This compression
law is linear for small amplitudes and logarithmic for large amplitudes.
The function takes input data to be converted from *inbuf* and outputs
the converted data to *outbuf;* the argument *bufsize* is the number of
elements in the input array.

*linear_to_a* converts integer data with 13 significant bits (including
sign) to 8 bits by using a 13-segment, piecewise linear approximation to
the *A*-law compression characteristic \[1\]. An input value greater
than 4095 or less than -4096 gives the same output code as 4095 or
-4096.

*a_to_linear* converts 8-bit, logarithmically compressed data to 13-bit
linear data according to the piecewise-linear *A*-law approximation. A
table lookup procedure is used to decode the the compressed values.

*linear_to_a_2* and *a_to_linear_2* are versions of *linear_to_a* and
*a_to_linear* that take into account the CCITT recommended practice of
inverting certain bits of the *A*-law encoded data before transmission
\[2\]. (This is done to even out the density of *1*s and *0s* in the
output bit stream for low-level inputs.) It is easy to transform the
output of *linear_to_a* to that of *linear_to_a_2,* or vice versa:
modify each output byte by taking the exclusive *or* with the constant
*0xd5* (binary 11010101). Likewise, *a_to_linear_2* gives the same
output that *a_to_linear* would give if each input byte were modified in
the same way. Companding by applying *a_to_linear* to the output of
*linear_to_a* gives exactly the same result as using *a_to_linear_2* and
*linear_to_a_2* instead. The latter two functions are intended for use
when the coded form must be compatible with existing telecommunications
data. If a tractable numerical relation between the input and output
data is more important, then *a_to_linear* and *linear_to_a* are the
better choice.

# EXAMPLES

Running

> 
>     int i;
>     static short original[13] =
>     	{-4096, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 4095};
>     char encoded[13];
>     short decoded[13];
>
>     linear_to_a(original, encoded, (long) 13);
>     a_to_linear(encoded, decoded, (long) 13);
>
>     for (i = 0; i < 13; i++) printf("%5d", original[i]);
>     printf("\n");
>     for (i = 0; i < 13; i++) printf("%5x", encoded[i]&0xff);
>     printf("\n");
>     for (i = 0; i < 13; i++) printf("%5d", decoded[i]);
>     printf("\n");

prints the output


    	-4096	-5	-4	-3	-2	-1	0	1	2	3	4	5	4095	
    	ff	82	81	81	80	80	0	0	1	1	2	2	7f	
    	-4032	-5	-3	-3	-1	-1	1	1	3	3	5	5	4032	

Running the same code with the function names changed to *linear_to_a_2*
and *a_to_linear_2* prints the output


    	-4096	-5	-4	-3	-2	-1	0	1	2	3	4	5	4095	
    	2a	57	54	54	55	55	d5	d5	d4	d4	d7	d7	aa	
    	-4032	-5	-3	-3	-1	-1	1	1	3	3	5	5	4032	

# BUGS

None Known.

# REFERENCES

\[1\] John C. Bellamy, *Digital Telephony,* (New York: Wiley, 1982),
Appendix B.

\[2\] International Telegraph and Telephone Consultative Committee
(CCITT) *Orange Book* v. III-2 (1976), Recommendation G.711.

# SEE ALSO

*linear_to_mu* (3-ESPS), *mu_to_linear* (3-ESPS)

# AUTHOR

Manual page and programs by David Burton. Modified by Rodney Johnson.
