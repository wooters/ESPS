# NAME

    waves_show_sd - displays user time-series data in an xwaves window

# SYNOPSIS

    extern int debug_level;

    int
    waves_show_sd( samp_freq, start_time, data, length, type, 
    	num_channels, setting, name)
    double samp_freq;
    double *start_time;
    char *data;
    long length;
    int type;
    int num_channels;
    char *setting;
    char *name;

# DESCRIPTION

*Waves_show_sd* creates a temporary FEA_SD file from an array of user
time-series data, and displays it in an xwaves window by a call of
*send_xwaves2 (3-ESPS)* if an *xwaves* program is running in server
mode. A non-negative value is returned upon successful completion of the
call.

This is useful in debugging some DSP code. With this simple call,
intermediate results can be examined.

The following are input parameters:

*samp_freq*  
The sampling frequency of time-series data.

*start_time*  
An array storing the starting time of time-series data. Size of this
array is the number of channels in data. If NULL value is specified, 0
starting time is assumed.

*data*  
The user time-series data. For single-channel data, *data* is simply an
array of sampled-data points. For multi-channel data, *data* is
conceptually a 2-dimensional array with *length* rows and *num_channels*
columns. *Data* is cast to *(char \*)*.

*length*  
Length of sampled-data points.

*type*  
Type of *data*. All ESPS supported data types are valid.

*num_channels*  
Number of channels.

*setting*  
This is a string of *xwaves* commands. If NULL is specified, default
*xwaves* behavior is expected; otherwise, use this argument to set
*xwaves* attributes.

*name*  
The name of FEA_SD file to be created. If NULL is specified, *name* is
set to a string containing the contents of the *unix* environment
variable ESPS_TEMP_PATH, followed by '/wavesXXXXXX', where Xs are
replace by current process ID.

# EXAMPLES

    int i, j, num_channels = 2;
    float *data, stuff1[1000], stuff2[1000];

    for( i=0, j=0; i<1000; i++, j+=2){
      data[j] = stuff1[i];
      data[j+1] = stuff2[i];
    }
    if( -1 == waves_show_sd(8000.0, NULL, data, 1000, FLOAT, 
    	num_channels, NULL, NULL))
      error...

# ERRORS AND DIAGNOSTICS

Program returns -1 with warning messages if *data* is NULL,
*length\<=0*, non-recognized *type*, or *num_channels\<=0*.

# WARNING

*Waves_show_sd* does not remove the temporary file created. It is
programmer's responsibility to delete them.

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

FEA_SD(5-ESPS), send_xwaves2(3-ESPS), xwaves(1-ESPS),
e_temp_name(3-ESPS)

# AUTHOR

Derek Lin
