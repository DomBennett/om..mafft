library(outsider)

# import
mafft <- module_import('mafft', repo = 'dombennett/om..mafft')

# get help
mafft('--help')

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
mafft(arglist = c('--auto', seq_file, '>', al_file))
