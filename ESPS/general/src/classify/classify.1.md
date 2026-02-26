# NAME

classify - maximum-likelihood classification of feature records

# SYNOPSIS

**classify** \[ **-P** *param_file* \] \[ **-d** \] \[ **-e** *elements*
\] \[ **-f** *field* \] \[ **-h** *file.his* \] \[ **-x** *debug_level*
\] \[ **-C** *field* \]\
\[ **-L** *field* \] *input.stat* *input.fea* *output.fea*

# DESCRIPTION

*Classify* takes as inputs an ESPS feature file of any subtype and an
ESPS statistics (FEA_STAT(5-ESPS)) file containing mean vectors and
inverse covariance matrices. It writes an output feature file of the
same subtype as the input feature file. Complex valued inverse
covariance matrices, mean vectors, and input classification fields are
not supported yet. If \`\`-'' is given for *input.fea,* the standard
input is used. If \`\`-'' is given for *input.stat,* the standard input
is used, but the input files must not both be the standard input. If
\`\`-'' is given for *output.fea,* the standard output is used.

*Classify* classifies each record of the input feature file into one of
several classes on the basis of information in the statistics file. The
possible classes are those named in the *class* field in the records in
the statistics file. Since that is a coded field, the class names
actually refer to strings in the *enums* array for the field *class* in
the statistics-file header, but there need not be a statistics record
for every such string. There must not be more than one record for any
one class.

Classification is by maximum likelihood. To classify a record, the
program computes a likelihood for each class by a method to be
described. The record is assigned to the class for which the likelihood
is greatest.

The output file is a copy of the input feature file with two additional
fields in each record. One is a coded field that identifies the class to
which the record is assigned. The other is a vector field that contains
the likelihoods. These occur in the same order as the corresponding
class names in the *enums* array for the new coded field. The
likelihoods are normalized so that their sum is 1 for each record; they
may thus be viewed as posterior class probabilities for a prior
distribution that (at present) is implicitly taken to be uniform.

To compute the likelihood, given a feature record and a statistics
record, *classify* first assembles a vector consisting of values of
certain elements of fields in the feature record. The length of this
\`\`feature vector'' must match the generic header item *statsize* in
the statistics-file header. The inverse covariance matrix and the mean
vector in the statistics record define a multivariate Gaussian
probability density; the desired likelihood is the value of the density
at the point given by the feature vector.

In the simplest case, the elements of the feature vector are simply all
the elements of the field named by the generic header item *statfield*
in the statistics-file header; however, the field name may be overridden
by the **-f** option, and a subset of the elements may be selected by
the **-e** option.

If *statfield* does not name a field in the input feature file, and
neither **-f** nor **-e** is selected, then the elements of the feature
vector are chosen with the help of the derived-field mechanism explained
in FEA(5-ESPS). In that case *statfield* must name a field that is
flagged as *derived* in the reference header of the statistics-file
header, and the field elements specified in the corresponding
*srcfields* entry must exist in the input feature file; those field
elements then become the elements of the feature vector. The **-d**
option forces use of the derived-field mechanism even when the contents
of *statfield* coincide with the name of a field in the input statistics
file.

# OPTIONS

The following options are supported:

**-d**  
Forces the use of the derived-field mechanism of feature files even when
*statfield* in the statistics-file header is the name of a field in the
input feature file. (See the Description section for more detail.) This
option may not be used if **-e** or **-f** is used.

**-e** *elements*  
The argument is in the form expected by the function
*grange_switch(3-ESPS)* and specifies the set of field elements that are
to comprise the feature vector for each input record. The field from
which the elements are selected is that specified with the **-f**
option, if any; if **-f** is not used, then the field is that named in
the generic header item *statfield* in *input.stat.* This option may not
be used if **-d** is used.

**-f** *field*  
The specified field must exist in *input.fea.* The elements of the
feature vector for each input record are drawn from this field instead
of the field named in the generic header item *statfield* in
*input.stat.* This option may not be used if **-d** is used.

**-h** *file.his*  
Place various intermediate results in the ASCII history file *file.his.*
At the end place summary statistics such as the total number of records
classified, number of records in each class, and fraction of records in
each class.

**-x** *debug_level*  
If *debug_level* is positive, *classify* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0, no messages are
printed. The default is 0.

**-C** *field*  
Specifies the name of the field in the output feature file that is to
contain the classification result for each record. Default is *class.*
The program exits with an error message if the field is already present
in the input feature file.

**-L** *field*  
Specifies the name of the field in the output feature file that is to
contain the vector of normalized likelihood values. Default is
*posteriors.* The program exits with an error message if the field is
already present in the input feature file.

# ESPS PARAMETERS

The following ESPS parameters are supported:

*elements - string*  
A string in the form expected by *grange_switch(3-ESPS)* that specifies
the set of field elements that are to comprise the feature vector for
each input record. This has the same function as the command line option
*-e*.

*in_field - string*  
A string specifies the field from which the elements of the feature
vector for each input record are drawn, instead of the field named in
the generic header item *statfield* in *input.stat*.

*class_fld_name - string*  
Specifies the name of the field in the output feature file that is to
contain the classification result for each record.

*like_fld_name - string*  
Specifes the name of the field in the output feature file that is to
contain the vector of normalized likelihood values.

# ESPS COMMON

This program does not read or write the common file.

# ESPS HEADERS

The output header is an altered copy of the input feature-file header
made with *copy_header*(3-ESPS). New values are filled in for
*common.prog,* *common.vers,* and *common.date.* The command line is
added to the comment field. The two input files are made the source
files of the output. Two new fields are added with
*add_fea_fld*(3-\SPS). The following items in the statistics-file header
are accessed: *common.type,* *common.tag,* *hd.fea-\>fea_type,* the
generic header items *statsize* and *statfield,* all items consulted by
*allo_feastat_rec*(3-EPSP) and *get_feastat_rec*(3-ESPS), and, in case
the derived-field mechanism is used, *variable.refhd.* In that case
these fields of the reference header are accessed: *hd.fea-\>names,*
*hd.fea-\>derived,* and *hd.fea-\>srcfields.*

If the generic header item *record_freq* exists in the input file, the
generic header item *start_time* is written in the output file. If it
exists in the input file header, the generic header item *record_freq*
is copied to the output file header. This item gives the number of
records per second of original data analyzed.

# FUTURE CHANGES

Option to input prior probabilities for the classes and perform
maximum-posterior-probability classification. Fix problem noted under
\`\`Bugs''.

The generic header items *elements* and *in_field* are written to record
the specifications provided by the command line option: **-e**, **-f**,
or the ESPS parameters: *elements*, *in_field*.

# EXAMPLE

Suppose you want to classify speech analysis frames as \`\`voiced'',
\`\`unvoiced'', or \`\`silent'' on the basis of raw power and (for some
reason) reflection coefficients number 2, 4, 5, and 6. Obtain 3
fea_ana(5-ESPS) files, say *voi.fana,* *unv.fana,* and *sil.fana,*
containing training sequences of voiced, unvoiced, and silent frames.
Also prepare an Ascii file, *fields,* containing the lines

    field = svector
    raw_power[0]
    spec_param[1,3:5]

or substitute a name of your choice for *svector.*

Execute the command

> fea_deriv fields voi.fana voi.fea

This will create a feature file *voi.fea* having a single vector field
*svector* of length 5. In each record of *voi.fea* the contents of
*svector* will consist of the contents of *raw_power,*
*spec_param*\[1\], *spec_param*\[3\], *spec_param*\[4\], and
*spec_param*\[5\] in the corresponding record of *voi.fana.* In the
header of *voi.fea,* the element of *hd.fea-\>derived* corresponding to
"svector" in *hd.fea-\>names* will have the value YES, and the
corresponding element of *hd.fea-\>srcfields* will contain the strings
"raw_power" and "spec_param\[1,3:5\]". Likewise execute

    fea_deriv fields unv.fana unv.fea
    fea_deriv fields sil.fana sil.fea

to create files *unv.fea* and *sil.fea.*

Execute

    fea_stats -I -f svector -n VOICED voi.fea clas.stat
    fea_stats -I -f svector -n UNVOICED unv.fea clas.stat
    fea_stats -I -f svector -n SILENCE sil.fea clas.stat

to create a fea_stat(5-ESPS) file *clas.stat* and append 3 records, each
containing a mean vector, an inverse covariance matrix, and a value for
the coded field *class.* The *class* values in the 3 fields will be
"VOICED", "UNVOICED", and "SILENCE". The generic header items
*statfield* and *statsize* will contain "svector" and 5.

Now, given a fea_ana file *test.fana* of records to be classified, use

> classify clas.stat test.fana result.fana

to create a fea_ana file *result.fana* of classification results. This
will be a copy of *test.fana* with a coded field *class* indicating
"VOICED", "UNVOICED", or "SILENCE" for each frame, and a 3-element
vector field *posteriors* giving the normalized likelihoods for the 3
voicing classes for each record.

The order of the likelihoods may or may not be \`\`voiced'',
\`\`unvoiced'', \`\`silence''. To find out, use

> psps -D -v result.fana

to determine the order of the strings "VOICED", "UNVOICED", and
"SILENCE" in the field definition for *class.*

# SEE ALSO

fea_deriv(1-ESPS), fea_stats(1-ESPS), classify(3-ESPSsp),
get_deriv_vec(3-ESPSu), FEA(5-ESPS), FEA_STAT(5-ESPS)

# DIAGNOSTICS

    classify: unknown option -letter
    Usage: classify . . . .
    classify: can't open filename: reason
    classify: filename is not an ESPS file
    classify: filename is not an ESPS feature file
    classify: filename is not an ESPS fea_stat file
    classify: -f and -e are incompatible with -d
    classify: field is not a derived field
    classify: feature-vector length inconsistent with statsize in stat file

# BUGS

The correspondence between class names and elements of the vectors of
likelihoods can be scrambled by programs like *select*(1-ESPS), which
can alter headers or copy records from one file into another with a
different header.

Input classification fields that are derived from complex fields are not
check for being complex. If the input field is derived from complex
valued fields, errors will result.

# REFERENCES

# AUTHOR

Rodney W. Johnson. Thanks to Richard Goldhor for some bug fixes.
