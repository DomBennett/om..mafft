
<!--
The README should be used to describe the program. It acts like the homepage of
your module.

Edit README.Rmd not README.md. The .Rmd file can be knitted to parse real-code
examples and show their output in the .md file.

To knit, use devtools::build_readme() or outsider.devtools::build()

Edit the template to describe your program: how to install, import and run;
run exemplary, small demonstrations; present key arguments; provide links and
references to the program that the module wraps.

Learn more about markdown and Rmarkdown:
https://daringfireball.net/projects/markdown/syntax
https://rmarkdown.rstudio.com/
-->

# Run [`mafft`](https://mafft.cbrc.jp/alignment/software/) through `outsider` in R

[![Build
Status](https://travis-ci.org/DomBennett/om..mafft.svg?branch=master)](https://travis-ci.org/DomBennett/om..mafft)

> MAFFT (Multiple Alignment through Fast Fourier Transformation):
> Multiple alignment program for amino acid or nucleotide sequences
> offering range of methods: L-INS-i (accurate; for alignment of \<∼200
> sequences), FFT-NS-2 (fast; for alignment of \<∼30,000 sequences),
> etc.

<!-- Install information -->

## Install and look up help

``` r
library(outsider)
#> ----------------
#> outsider v 0.1.0
#> ----------------
#> - Security notice: be sure of which modules you install
module_install(repo = 'dombennett/om..mafft')
#> -----------------------------------------------------
#> Warning: You are about to install an outsider module!
#> -----------------------------------------------------
#> Outsider modules install and run external programs
#> via Docker <https://www.docker.com>. These external
#> programs may communicate with the internet and could
#> potentially be malicious.
#> 
#> Be sure to know the module you are about to install:
#> Is it from a trusted developer? Are colleagues using
#> it? Is it supposed to download lots of data? Is it
#> well used (e.g. check number of stars on GitHub)?
#> -----------------------------------------------------
#>  Module information
#> -----------------------------------------------------
#> program: mafft
#> details: Multiple alignment program for amino acid or nucleotide sequences
#> docker: dombennett
#> github: dombennett
#> url: https://github.com/DomBennett/om..mafft
#> image: dombennett/om_mafft
#> container: om_mafft
#> package: om..mafft
#> Travis CI: Failing/Erroring
#> -----------------------------------------------------
#> Enter any key to continue or press Esc to quit
# module_help(repo = 'dombennett/om..mafft')
```

<!-- Detailed examples -->

## Aligning DNA sequences

> Small alignment example using the `--auto` argument.

``` r
library(outsider)
mafft <- module_import(fname = 'mafft', repo = "dombennett/om..mafft")

# get help
mafft('--help')
#> ------------------------------------------------------------------------------
#>   MAFFT v7.407 (2018/Jul/23)
#>   https://mafft.cbrc.jp/alignment/software/
#>   MBE 30:772-780 (2013), NAR 30:3059-3066 (2002)
#> ------------------------------------------------------------------------------
#> High speed:
#>   % mafft in > out
#>   % mafft --retree 1 in > out (fast)
#> 
#> High accuracy (for <~200 sequences x <~2,000 aa/nt):
#>   % mafft --maxiterate 1000 --localpair  in > out (% linsi in > out is also ok)
#>   % mafft --maxiterate 1000 --genafpair  in > out (% einsi in > out)
#>   % mafft --maxiterate 1000 --globalpair in > out (% ginsi in > out)
#> 
#> If unsure which option to use:
#>   % mafft --auto in > out
#> 
#> --op # :         Gap opening penalty, default: 1.53
#> --ep # :         Offset (works like gap extension penalty), default: 0.0
#> --maxiterate # : Maximum number of iterative refinement, default: 0
#> --clustalout :   Output: clustal format, default: fasta
#> --reorder :      Outorder: aligned, default: input order
#> --quiet :        Do not report progress
#> --thread # :     Number of threads (if unsure, --thread -1)

# download
wd <- file.path(tempdir(), 'mafft_example')
if (!dir.exists(wd)) {
  dir.create(wd)
}
# example DNA
seq_file <- file.path(wd, 'example_seq.fasta')
url <- 'https://raw.githubusercontent.com/DomBennett/om..pasta/master/example_seq.fasta'
download.file(url = url, destfile = seq_file)

# align
al_file <- file.path(wd, 'alignment.fasta')
mafft(arglist = c('--auto', '--quiet', seq_file, '>', al_file))

# verify
cat(paste0(readLines(al_file, n = 10), collapse = '\n'))
#> >X02729 Methanococcus vannielli. #
#> ----tatctattaccctacc----ctggggaatggcttggcttgaaacgccgatgaagga
#> cgtggtaagctgcgataagcctaggcgaggcgcaa-cagcctttgaacctaggatttccg
#> aatgggacttcctacttttgtaa--------------------tccgtaaggattggtaa
#> cgcgggggattgaagcatcttagtacccgcaggaaaagaaatca-actgaga-ttccgtt
#> agtagaggcgattgaacacggatcagggcaaactgaatcccttcg-------------gg
#> gagatgtggtgttatagggccttct------tttcgcctgttgagaaaagctgaagtt-g
#> actggaacg-tcacactatagagggtgaaagtcccgtaagcgcaatcgattcaggtt---
#> tgaagtgt-ccctgagtaccgtgcgttggatatcgcgcgggaatt-tgggaggcatcaac
#> ttccaactctaaatacgtttcaagaccgatagcgtac-tagtaccgcgagggaaagctga

# add new sequences using the --add argument
al_file2 <- file.path(wd, 'alignment2.fasta')
url <- 'https://raw.githubusercontent.com/DomBennett/om..mafft/master/test_data/extra_seqs.fasta'
extra_file <- file.path(wd, 'extra_seqs.fasta')
download.file(url = url, destfile = extra_file)
# (no "--quiet" this time)
mafft(arglist = c('--add', extra_file, '--reorder', al_file, '>', al_file2))
#> nadd = 3
#> nthread = 0
#> nthreadpair = 0
#> nthreadtb = 0
#> ppenalty_ex = 0
#> stacksize: 8192 kb
#> generating a scoring matrix for nucleotide (dist=200) ... done
#> Gap Penalty = -1.53, +0.00, +0.00
#> 
#> 
#> 
#> Making a distance matrix ..
#> 
#> There are 10 ambiguous characters.
#>     1 / 13
#> done.
#> 
#> Constructing a UPGMA tree (efffree=0) ... 
#>     0 / 13   10 / 13
#> done.
#> 
#> Progressive alignment 1/2... 
#> STEP     1 / 12  fSTEP     2 / 12  fSTEP    12 / 12  f
#> done.
#> 
#> Making a distance matrix from msa.. 
#>     0 / 13
#> done.
#> 
#> Constructing a UPGMA tree (efffree=1) ... 
#>     0 / 13   10 / 13
#> done.
#> 
#> Progressive alignment 2/2... 
#> STEP     1 / 12  fSTEP     2 / 12  fSTEP    12 / 12  f
#> done.
#> 
#> disttbfast (nuc) Version 7.407
#> alg=A, model=DNA200 (2), 1.53 (4.59), -0.00 (-0.00), noshift, amax=0.0
#> 0 thread(s)
#> 
#> 
#> Strategy:
#>  FFT-NS-2 (Fast but rough)
#>  Progressive method (guide trees were built 2 times.)
#> 
#> If unsure which option to use, try 'mafft --auto input > output'.
#> For more information, see 'mafft --help', 'mafft --man' and the mafft page.
#> 
#> The default gap scoring scheme has been changed in version 7.110 (2013 Oct).
#> It tends to insert more gaps into gap-rich regions than previous versions.
#> To disable this change, add the --leavegappyregion option.
```

<!-- Remove module after running above example -->

### Key arguments

`mafft` has the following signature:

    mafft "--option" "input_file" > "output_file"

These arguments can be passed through R via the `arglist` as a character
vector as demonstrated in the example above. Note, option arguments
(`--op`, `--ep`, `--maxiterate`, etc.) must always precede the “input \>
output” statement. Also note, `--man` does not via R.

## Links

Find out more by visiting the [MAFFT
homepage](https://mafft.cbrc.jp/alignment/software/).

## Please cite/read

  - Yamada, Tomii, Katoh 2016 (Bioinformatics 32:3246-3251) additional
    informationApplication of the MAFFT sequence alignment program to
    large data—reexamination of the usefulness of chained guide trees.
  - Katoh, Standley 2016 (Bioinformatics 32:1933-1942) A simple method
    to control over-alignment in the MAFFT multiple sequence alignment
    program.
  - Katoh, Standley 2013 (Molecular Biology and Evolution 30:772-780)
    MAFFT multiple sequence alignment software version 7: improvements
    in performance and usability.
  - Katoh, Frith 2012 (Bioinformatics 28:3144-3146) Adding unaligned
    sequences into an existing alignment using MAFFT and LAST.
  - Katoh, Toh 2010 (Bioinformatics 26:1899-1900) Parallelization of the
    MAFFT multiple sequence alignment program.
  - Katoh, Asimenos, Toh 2009 (Methods in Molecular Biology 537:39-64)
    Multiple Alignment of DNA Sequences with MAFFT. In Bioinformatics
    for DNA Sequence Analysis edited by D. Posada
  - Katoh, Toh 2008 (BMC Bioinformatics 9:212) Improved accuracy of
    multiple ncRNA alignment by incorporating structural information
    into a MAFFT-based framework.
  - Katoh, Toh 2008 (Briefings in Bioinformatics 9:286-298) Recent
    developments in the MAFFT multiple sequence alignment program.
  - Katoh, Toh 2007 (Bioinformatics 23:372-374) Errata PartTree: an
    algorithm to build an approximate tree from a large number of
    unaligned sequences.
  - Katoh, Kuma, Toh, Miyata 2005 (Nucleic Acids Res. 33:511-518) MAFFT
    version 5: improvement in accuracy of multiple sequence alignment.
    (describes \[ancestral versions of\] the G-INS-i, L-INS-i and
    E-INS-i strategies)
  - Katoh, Misawa, Kuma, Miyata 2002 (Nucleic Acids Res. 30:3059-3066)
    MAFFT: a novel method for rapid multiple sequence alignment based on
    fast Fourier transform.
  - Bennett et al. (2020). outsider: Install and run programs, outside
    of R, inside of R. *Journal of Open Source Software*, In
review

## <!-- Footer -->

<img align="left" width="120" height="125" src="https://raw.githubusercontent.com/ropensci/outsider/master/logo.png">

**An `outsider` module**

Learn more at [outsider
website](https://docs.ropensci.org/outsider/). Want to build your
own module? Check out [`outsider.devtools`
website](https://docs.ropensci.org/outsider.devtools/).
