# NAME

spsassert - ESPS program verification

# SYNOPSIS

    #include <esps/spsassert.h>

    spsassert(expression,message)
    char *message

# DESCRIPTION

This macro is very helpful in catching programming errors, it is a tool
for defensive programming. The macro is also useful for putting
diagnostics into ESPS programs.

When it is executed, if *expression* is false, it prints

    	ESPS assertion failed:  message
    	Assertion failed:  file xyz, line nnn

on the standard error file and exits. *Xyz* is the source file and *nnn*
the source line number of the *assert* statement. *Message* is the
message passed as the second argument of the macro. The message should
include the name of the program or the function name (if a library
function) calling spsassert.

The include file *\<esps/spsassert.h\>* is included automatically in
programs that include *\<esps/esps.h\>*.
