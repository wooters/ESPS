# NAME

    zst - set start time to zero in ESPS FEA and label files

# SYNOPSIS

**zst** \[ **-l** *label_directory* \] \[ **-g** *label_file_extension*
\] \[ **-d** *data_file_extension* \] \[ **-x** *debug_level* \]
datafile\[s\]

# DESCRIPTION

*zst* is used to reset the start time information in ESPS FEA files and
waves label files. ESPS FEA files may contain a header item start_time
which specifies the time of the first record in seconds. If the data is
transformed into a file format which does not retain this initial offset
information, the time marks in associated label files will be incorrect.
*zst* can be used to reset the start time to zero and adjust the time
information in the label file before the data file is transformed.

For each specified data file, *zst* first reads the generic header item
start_time from each data file and sets it to 0 in that file. *zst* then
finds the label file corresponding to the data file and subtracts the
original start time from the times in label file. The labels are then
consistent with data that starts at time 0. The original label file
*labfile* is copied to *labfileBAK.*

*zst* is a shell script.

# OPTIONS

The following options are supported:

**-l** *label_directory*  
specifies a complete path to the directory containing the label files.
Otherwise each label file is assumed to be in the same directory as the
data file it labels.

**-g***"***label_file_extension***\[.lab\]*  
specifies the extension used in contructing the label file name from the
data file name.

**-d***"***data_file_extension***\[.wav\]*  
specifies data file extension. It is replaced by the label file
extension to form the label file name.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *zst* prints debugging messages and other
information on the standard error output. The messages proliferate as
the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

None read.

# ESPS COMMON

Not used.

# ESPS HEADERS

Header item start_time set to zero in all specified data files.

# EXAMPLES

Suppose a data file foo.fea and its label file foo.phn are in the
current directory. Their start times can be adjusted by executing

\$\> zst -g phn -d fea foo.fea

If the label file is stored in the directory labels, and the data file
is in the current directory, their start times can be adjusted by
executing

\$\> zst -l labels -g phn -d fea foo.fea

If an aribtrary number of data files fooXXX.fea are in the directory
data and their label files fooXXX.phn are in the directory labels, their
start times can be adjusted by executing

\$\> zst -l labels -g phn -d fea ./data/foo\*.fea

# BUGS

None known.

# SEE ALSO

addgen (1-ESPS), xwaves(1-ESPS), xlabel(1-ESPS)

# AUTHOR

Bill Byrne
