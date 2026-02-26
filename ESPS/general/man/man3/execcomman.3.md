# NAME

    exec_command - fork a shell to run a unix command

# SYNOPSIS


    #include <stdio.h>

    void
    exec_command(cmd)
    char *cmd;

# DESCRIPTION

*exec_command* executes a command *cmd* by handing it to /bin/sh. The
shell is forked using *execvp*(3). The string *cmd* should be a valid
unix command given user's environment.

# EXAMPLES


    	char *command[200];
    	char *file;
    	 . . .

    	/* simple command */

    	sprintf(command, "plot3d %s", file);	
    	exec_command(command);

    	 . . .

    	/* a command with a pipe */

    	sprintf(command "fft %s - | plotspec -");
    	exec_command(command);

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

# AUTHOR

program and man page by John Shore; this was based on the *olwm*
function *execCommand*.
