# NAME

larcbk2rc - convert a scalar codebook that contains log area ratios to a
codebook containing reflection coefficients.

# SYNOPSIS

**larcbk2rc** \[ **-x** *debug_level* \] *lar.scbk rc.scbk*

# DESCRIPTION

*Larcbk2rc* takes an ESPS LAR SCBK file *lar.scbk* and converts it to an
ESPS RC SCBK file.

The input file *lar.scbk* must be an ESPS SCBK file with
*hd.scbk-\>codebook_type =* LAR\_{VCD or UNVCD}\_CBK. Otherwise
*larcbk2rc* exits with an error message. *Larcbk2rc* creates and writes
the ESPS RC SCBK output file *rc.scbk.* If "-" is supplied in place of
*lar.scbk,* then standard input is used. If "-" is supplied in place of
*rc.scbk,* standard output is used.

The header of *lar.scbk* is included as a source in *rc.scbk* and the
*larcbk2rc* command line is added as a comment. *Larcbk2rc* transforms
the *enc* and *dec* values in *lar.scbk* to reflection coefficients and
stores them in *rc.scbk.* The *code* values and *final_pop*\[\] values
are copied from *lar.scbk* to *rc.scbk.* The values of *final_dist* and
*cdwd_dist*\[\] are set to -1 in *rc.scbk.* (See SCBK (5-ESPS).)

# OPTIONS

The following options are supported:

**-x** *debug_level*  
If *debug_level* is positive, *larcbk2rc* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0, no messages are
printed. The default is 0.

# ESPS PARAMETERS

The ESPS parameter file is not read by *larcbk2rc.*

# ESPS COMMON

The ESPS Common file is not read by *larcbk2rc.*

# ESPS HEADERS

*Larcbk2rc* reads the following values from the input SCBK file:

> 
>
>     common.type
>     common.ndrec
>
> The following items are copied from the header of *lar.scbk* to the
> header of *rc.scbk:*
>
> > variable.comment
> >     hd.scbk->num_cdwds
> >     hd.scbk->element_num
> >
> > The following values are set in the header of *rc.scbk:*
> >
> > > hd.scbk->num_items = 0
> > >     hd.scbk->distortion = -1
> > >     hd.scbk->convergence = -1
> > >     hd.scbk->codebook_type = RC_CBK, RC_UNVCD_CBK or RC_VCD_CBK
> > >     depending on if codebook_type of the input file is LAR_CBK,
> > >     LAR_UNVCD_CBK, or LAR_VCD_CBK.

# AUTHOR

Manual page by John Shore
