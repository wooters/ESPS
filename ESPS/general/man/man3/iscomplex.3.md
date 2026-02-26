# NAME

    is_file_complex - does file contain any complex data types
    is_field_complex - is data type of field complex
    is_type_complex- does type code represent complex data

# SYNOPSIS

\#include \<esps/esps.h\>\
\#include \<esps.fea.h\>

    int
    is_file_complex(hd)
    struct header *hd;

    int
    is_field_complex(hd, name)
    struct header *hd;
    char *name;

    int
    is_type_complex(type)
    int type;

# DESCRIPTION

These functions test for complex data. *is_file_complex* returns YES if
any field in the file pointed to by the header is a complex valued
field; otherwise it returns NO. *is_field_complex* returns YES if the
named field in the file pointed to by the header is a complex valued
field; it returns NO otherwise. *is_type_complex* returns YES if the
type argument corresponds to a complex data type; otherwise it returns
NO.

# EXAMPLE


    int type;
    char *name = "samples";
    char *infile;
    struct header *hd;
    FILE *fp;

    	/*open file (argv[optind]) for reading and read header (hd)*/
    	infile = eopen(argv[0], argv[optind++], "r", FT_FEA, FEA_SD, &hd, &fp);

    	/*check if file contains any complex valued data fields*/
    	if(is_file_complex(hd) == YES){
    	   Fprintf(stderr, "files contains complex data");
            }

    	/*check if the field "samples" is complex*/
    	if(is_field_complex(hd, name) == YES){
    	   Fprintf(stderr, "field "samples" is complex");
    	}

    	/*check if the data type of field "samples" is complex*/
    	type = get_fea_type("samples", hd);
    	if(is_type_complex(type) == YES){
    	    Fprintf(stderr, "samples" is a complex data field");
    	}

# DIAGNOSTICS

None.

# SEE ALSO

*is_type_numeric*(3-ESPSu), *cover_type*(3-ESPSu)

# AUTHOR

Manual page by David Burton. Code by Alan Parker
