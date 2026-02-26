# NAME

get_snr - Compute the signal-to-noise ratio between 2 data segments

# SYNOPSIS

float\
get_snr ( refData, procData, segmentSize )\
float refData\[\], procData\[\];\
int segmentSize;

# DESCRIPTION

This function takes 2 input data vectors and information about their
size and computes an SNR measurement by using the following formula:

         SNR = 10 * log10 { SUMn refData(n)^2 / SUMn {refData(n) - procData(n)}^2 }
                         

where *refData(n)* is the reference data, *procData(n)* is the processed
data, and *SUMn* is the sum over all the input data elements (from 1 to
*segmentSize*).

*get_snr* handles the singular cases involving 0 in the following way:

 ·  
if only the numerator is zero, the 10\*log10{} result is set to -385.0

 ·  
if only the denominator is zero, the 10\*log10{} result is set to +385.0

 ·  
if both numerator and denominator are zero, the 10\*log10{} result is
set to 0.0

# BUGS

None known.

# SEE ALSO

# REFERENCES

\[1\] S. Quackenbush, T. Barnwell, and M. Clements, *Objective Measures
of Speech Quality,* Prentice Hall, New Jersey, 1988, Chap. 2

# AUTHOR

David Burton
