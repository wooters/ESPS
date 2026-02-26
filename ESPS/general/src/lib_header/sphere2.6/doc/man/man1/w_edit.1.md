# NAME

    w_edit -  Modify and/or extract samples from a SPHERE waveform file.

# SYNOPSIS

    w_edit [-vf] -o [-[t|p]F:T]] [-oOUT ] { filein | - } { fileout | - }

# DESCRIPTION

W_edit is a waveform editing command to manipulate and extract samples
the waveform data in a sphere file.

If the file size has been changed by either the '-t' or '-s' option, the
program adds (or modifies) three header fields to describe the origins
of the data. Two "REAL" type header fields, 'start_time' and

in relation to the original file. The third field, 'data_origins', is
added to identify original file. The field contains a comma separated
list of fields from the original file including, "database_id",
"database_version" (if present), and either "conversation_id",
"utterance_id", or by default 'file1' from the command line.

The following functions can be performed on a file:

**-tF:T**  
Set the range for output from time F (seconds) to time T. If F is
missing, it defaults to the beginning of the file, if T is missing, go
to the end of the file.

**-sF:T**  
Set the range for output from F samples to T samples. If F is missing,
it defaults to the beginning of the file, if T is missing, go to the end
of the file.

**-cEXP**  
Extract only the samples from channels in EXP. The expression will also
add channels together if the '+' is used.

**-oOUT**  
Set the output format to the following formats:

**ulaw**  
output the samples as ulaw encoding.

**pcm_01 \| short_01**  
output the samples as PCM values in 01 sample_byte_format

**pcm_10 \| short_10**  
output the samples as PCM values in 10 sample_byte_format

**pcm \| short_natural**  
output the samples as PCM values in the cpu's natural byte format

<!-- -->

**-v**  
option gives verbose output.

# EXAMPLES

**w_edit -o short_10 -c2,1 stereo.wav reverse.wav**  
Convert a file the short_10 format and change the channel order of a
stereo file.

# SEE ALSO

w_encode(1)

# AUTHOR

Jon Fiscus (jon@jaguar.ncsl.nist.gov)
